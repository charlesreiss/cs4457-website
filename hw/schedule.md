---
title: packet scheduling/queuing discpline
author: Charles Reiss
...

# Your Task

1.  Download the template code at TBD.

    This code includes a setup for a simulator (the same as for the `reliable` assignment),
    which is configured to have two connections, called "c1" and "c2", between the same two hosts.
    Each connection sends packets from a sender to receiver on a shared link. Unlike the `reliable`
    assignment, there is no flow or congestion control; instead packets are generated at a rate
    specified when running the simulation.

    The simulation allows for interchangeable buffer implementations on the simulated link.
    The default is a simple drop-tail, first-in-first-out scheme implemented in
    the "DropTailBuffer" in buffer.py.

    See the instructions under the heading [running the template code](#template)
    regarding how to use the template code.

3.  Add a new buffer implementation in buffer.py called PriorityQueueBuffer

    In this implementation, implement a strict priority scheme where packets from
    connection c1 are serviced before packets from connection c2. You can identify which connection
    a packet is from using `packet.label` which will be `c1` for connection c1
    and `c2` for connection c2.

    When the queue capacity is exceeded, your implementation must discard the newest packet
    from connection c2, if possible; otherwise, it should discard the newest packet from
    connection c1.

    If you are successsful:

    *  no packet should be received out-of-order by connection c1 or c2
    *  as long as the rate of c1 is less than the link bandwidth, it should achieve its full bandwidth
       (in terms of messages received/time unit) and have a latency close to the link delay.

       This should occur:
       *  regardless of the rate of c2, even if the rate of c2 substantially exceeds the available bandwidth
       *  even if the rate of c1 is very small

    *  as long as the rate of c1 is substantially less than the link bandwidth, c2 should be able to
       use the remainder of the link bandwidth

2.  Add a new buffer implementation in buffer.py called WeightedFairQueuingBuffer.

    In this implementation, implement weighted fair queuing, where packets from connection c1
    get twice the bandwidth as packets from connection c2. You can identify which connection
    a packet is from using `packet.label` which will be `c1` for connection c1
    and `c2` for connection c2.

    If you are successful:

    *  no packet should be received out-of-order by connection c1 or c2
    *  if c1's rate is more than 67% of the capacity of the link and c2's rate is
       more than 34% of the capacity of the link, then c1 should achieve around
       66% of the capacity of the link and c2 around 33% of the capacity of the link
       (in terms of messages/time unit)
    *  if c1's rate is less than 66% of the capacity of the link, then:
       *  c1's latency should be close to the link delay, and
       *  c2 should recieve the remainder of the bandwidth of the link (if its rate is high enough)

3.  Submit your modified `buffer.py`.

# Running the template code {#template}

1.  When you run `main.py`, it will run the simulation with default settings and output information about what
    happened and the configuration:

        forward link: 10.0 packets/sec; link delay 1.0 +/- 0.0; 10-entry buffer.DropTailBuffer
        c1: generated 5.0 packets/sec
        c1: received 23517 in 5000.0 (4.7 messages/time unit)
        c1: latency: mean 1.47  +/- sd 0.30
        c1: 1158 messages skipped, 9 not received at end, 0 corrupt or received out-of-order
        c2: generated 5.0 packets/sec
        c2: received 23824 in 5000.0 (4.8 messages/time unit)
        c2: latency: mean 1.47  +/- sd 0.30
        c2: 1132 messages skipped, 9 not received at end, 0 corrupt or received out-of-order

    In this default configuration, the rate of messages being sent seem like they should exactly fill the link.
    But, there is randomness in the interval between packets. This means that sometimes packets cluster up enough
    to cause some to be dropped and sometimes there are periods when the link is underutilized.

2.  You can edit the simulation parameters with the various options listed with `python3 main.py --help`.

    You should notice that, with the default DropTailBuffer strategy, increasing the rate for one connection
    while leaving the other the same will cause both connections to drop a larger portion of packets ("messages skipped"),
    and will result in the higher sending rate connnection achieving a higher effective bandwidth.

    If these connections used TCP-style congestion control, then most likely both settle on approximately the same bandwidth.
    (The simulation supports plugging in your reliable part 3 implementation using the `--sender-class` and `--receiver-class`
    options, but that is not part of this assignment.)

3.  You can use the `--buffer-class=...` option to change to your own buffers in `buffer.py`.
