---
title: DNS
author: Charles Reiss, based on an assignment by Hyojoon Kim
...

# Your Task

## Part 1

1.  Download the supplied VM image for Virtualbox (x86-64) at TBD or for UTM (ARM macOS) at TBD.

    (or, install p4 according to the instructions at
    <https://github.com/jafingerhut/p4-guide/blob/master/bin/README-install-troubleshooting.md>
    and clone the git repository at TBD).

2.  Run the VM and login (username/password p4/p4 for the Virtualbox VM or
    username/password sdn/fun for the UTM VM).

2.  Go to the `p4tutorials/cs4457_f24` directory.

2.  Following the instructions below, setup a simulated network with four
    simulated hosts (`h1`, `h2`, `h3`, and `h4`) one simulated switch (`s1`) running 
    a data plane specified in `cs4457_f24.p4` and a control plane implemented in
    `mycontroller.py`.

    To do this, as described below, you'll run `make` to start the network emulator `mininet`.
    This will give you a prompt allowing you to run commands on each of the hosts.
    In another terminal, run `python3 mycontroller.py` to run the controller for the
    switch `s1`.

    Verify that the initial implementation:

    *  does not allow hosts to be reachable from each other until the controller is run to initialize
       the switch (using commands like `h1 ping h2` or `pingall` or `iperfudp 1M h1 h2` in mininet);
    *  allows all hosts to be reachable from each other when the switch is initialize
    *  broadcasts all frames sent by any simulated host to all other simulated hosts. This means:
       *  running the command `python3 print_counters.py` in a separate terminal will show
          a count of the number of packets and bytes sent to each of the switch's output ports.
          You should see that ports 1 through 4 all have the same number of packets/bytes output, no
          matter what commands you run.
       *  the packet traces in pcaps/s1-ethX_out.pcap will show what the switch outputted to each
          port. Examined with wireshark or with a command like `tcpdump -er pcaps/s1-ethX_out.pcap`,
          they should show that each port received the same data.

3.  There is no submission for part 1, but if your VM setup is not working, then you will not
    be ready to do part 2.

## Part 2

2.  Modify `mycontroller.py` to make the following call
    to `write_or_overwrite_table_entry` to make it so packets destined to 08:00:00:00:01:01
    (`h1`'s MAC address in `topology.json`)
    are sent to port 1:

        write_or_overwrite_table_entry(
            p4info_helper=p4info_helper,
            switch=s1,
            table_name='MyIngress.mac_dst_lpm',
            match_fields={
                # first 48 bits match this MAC address
                'hdr.ethernet.dstAddr': ('08:00:00:00:01:01', 48),
            },
            action_name='MyIngress.forward_to_port',
            action_params={
                'port': 1,
            }
        )

    Verify that this change causes packets destined for `h1` not to be duplicated on other ports
    but should still leave h1 reachable.
    In a file called `results.txt`, describe how you verified this, including showing any relevant
    output or measurements.

3.  Modify `cs4457_f24.p4` to make it so that packets are sent to the switch controller by default
    by modify the default action for the `mac_src_lpm` table.

    After doing this (and restarting the network simulation),
    `mycontroller.py` should start outputting information about every packet sent
    when you run commands in mininet.

    If you run a command like `h1 ping h2`, you should see ICMP echo request and ICMP echo reply messages.

4.  Now, add a table entry to `MyIngress.mac_src_lpm` so that packets from `h1`'s MAC address
    are not forwarded to the controller:

        write_or_overwrite_table_entry(
            p4info_helper=p4info_helper,
            switch=s1,
            table_name='MyIngress.mac_src_lpm',
            match_fields={
                'hdr.ethernet.dstAddr': ('08:00:00:00:01:01', 48),
            },
            action_name='NoAction',
            action_params={}
        )

    Verify that this prevents mycontroller.py from printing out information about packets _from_
    `h1`'s MAC address. In the file `results.txt` describe how you did this, including showing
    any relevant output or measurements.

5.  Submit your `results.txt`, modified `mycontroller.py`, and modified `cs4457_f24.p4`.

## Part 3

5.  Modify `process_packet` in `mycontroller.py` to add entries similar to
    the ones we added manually above for `h1` dynamically. Rather than hard-coding any
    MAC addresses and port numbers, you should look at each transmitted packet that
    comes from a MAC address not yet handled and add entries to the tables to handle forwarding
    for that MAC address.

    Verify that your solution makes it so that, after each host sends some traffic (such as because
    you ran `pingall`), each host does only receives packets destined for its own MAC address
    (or packets sent to a broadcast/multicast MAC address). In the file `results.txt` describe how
    you did this, including showing any relevant output or measurements.

5.  Submit your `results.txt`, modified `mycontroller.py`, and modified `cs4457_f24.p4`.

# Understanding cs4457_f24.p4:

2.  `cs4457_f24.p4`: This contains an implementation of the data plane
    of a very simple switch:

    *  Initially, frames are parsed in MyParser(), which extracts headers for use by later steps.

       In this stage, we also setup a special header (called `hdr.packet_in` in the code)
       that is used to send packets^[really, layer-2 frames,
       but we will use the term "packet" since that is consistent with the P4 documentation.] to the
       control plane for special processing. Corresponding code in MyEgress() will disable this header
       before sending out packets to destinations other than the control plane.

    *  Then packets enter ingress processing MyIngress(). This stage does table lookups based
       on the source and destination MAC addresses of the packet. These tables can be configured
       by the control plane to choose one of four actions:

       *  sending a copy of the packet to the controller;
       *  forwarding the packet to a particular output port;
       *  broadcasting the packet to all (non-controller) output ports;
       *  doing nothing

    *  If a packet is sent on any output port (including to the control plane),
       then MyEgress() runs. Currently this has logic which will:

       *   avoid sending the control-plane information header to non-control-plane ports
       *   increment a counter to track how many bytes and packets are sent to each destination

    *  Before packets are sent out, MyDeparser() runs, which converts headers back into bytes.

# Hints

## Understanding mycontroller.py

3.  `mycontroller.py` which contains an implementation of the control plane.

    The code in the `main()` function:

    *  connects to the switch
    *  loads the P4 program into the switch (from a compiled file which will be produced by `make`)
    *  configures the switch to support functionality to send packets to multiple destinations
    *  runs a loop where it receives packets sent from the switch and sends them to
       the process_packet function

4.  Initially, the loop that receives packets from the switch won't do anything because
    the cs4457_f24.p4 does not run the `copy_to_controller` action.

5.  The `process_packet` function decodes some "metadata" fields that are setup by `cs4457_f24.p4`.
    These are defined in the `header packet_in_header_t` in `cs4457_f24.p4` and set
    in `MyIngress` (by modifying `hdr.packet_in`).

    To prevent the "metadata" fields from being output as part of packets sent to the simulated
    hosts, code in MyEgress marks this metadata as invalid except when the switch is outputting
    to the controler.

    The controller's code in `process_packet` extracts the fields from the metadata into
    local variables for your convenience later. When the fields are sent to the controller,
    each metadata field is sent separately, but without only an index instead of a name,
    and without information about the size or format of the field. This means that if you modify
    the metadata fields in `cs4457_f24.p4` without corresponding modifications to `mycontroller.py`,
    mycontroller will read the wrong data.

## Running the simulated network

1.  `topology.json` specifies the layout of the simulated network and how the hosts are configured.
 
    In this case, there will be one switch called `s1` connected to four hosts `h1`, `h2`, `h3`, `h4`.

    The hosts are assigned MAC addresses and informed of the MAC addresses of all other hosts.

    Running `make` will compile the .p4 file and start a simulated network based on `topology.json`,
    and give you a prompt in the `mininet` tool.

    In the mininet tool you can:

    *  Run a command `FOO` on a particular simulated host, like `h1`, using a command `h1 FOO`.

       In the command you run the names of other hosts will be replaced by their IP addresses.

       For example `h1 ping h2` will run the command `ping 10.0.1.2` (since `10.0.1.2`
       is the configured IP address of h2 in topology.json). The `ping` command
       sends echo requests (using the IP control protocol ICMP) 
       to a particular host and prints out messages when it gets echo replies.

       The simulated hosts are implemented by running a normal program with its network configuration
       changed, so you can run arbitrary commands.

    *  Get a terminal within a simulated host `h1` using `xterm h1`

    *  Test whether each host is reachable from each other with `pingall`

    *  Send data from host `h1` to host `h2` using TCP using a command like `iperf h1 h2` (named after the
        a well known networking testing tool called `iperf`)

    *  Send data from host `h1` to host `h2` using UDP at 1Mbps using a commnad like `iperfudp 1M h1 h2`.

    (and more, see also the command `help` in mininet)

1.  We need to run our controller program to setup the emulated switch. Until this is done, none of
    the hosts will be able to contact each other.

    You can run `python3 mycontroller.py` in another terminal to do this.

    Note that exiting `mininet` or terminating the python3 program will stop the network.

1.  We provide a utility program called `print_counters.py` which will contact the emulated switch
    and retrieve counts of how many packets and bytes have been sent on each port.

    You can run it in a separate terminal using `python3 print_counters.py`.

    The utility program uses the same code as `mycontroller.py` to connect to this switch, but does
    send any commands that would register it as the controller of the switch or any commands
    that would reconfigure the switch.
