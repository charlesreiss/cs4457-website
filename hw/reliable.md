---
title: Reliable Transport
author: Charles Reiss (based on ...)
...

<!-- FIXME: based on -->
<!-- FIXME: 
    maybe follow https://cseweb.ucsd.edu/classes/wi22/cse123-a
    they do segment on framing, which might make more sense
    -->

# Your Task

1.  Download the supplied simulator and skeleton code.

    In the skeleton code, you should only modify `ends.py`, which initially has code
    that implements transmission without any sort of reliablity.

    In `ends.py`, `ReliableSender` receives messages from its simulated application layer
    then transmits them using the simulated network layer:

    *  We will call the `from_application` method with each message to be sent.
       This method should return `True` if an attempt was made to transmit the message.
       If an attempt cannot immediately be made to transmit the message, then it should return False.
       (If you return False, do not attempt to transmit the message in the future; our code will
       call `from_application` again later.)
    *  Given a Packet object `p`, you can call `self.to_network(p)` to send it to the receiver.
       (You will probably do this from the `from_application` method.
    *  Whenever you are ready to receive more data from the application (after having
       returned False from `from_application`), you must call `self.ready_for_more_from_application()`.
       It is okay if you call this method more times than necessary.

    Then `ReliableReceiver` receives those messages from its simulated network layer
    (in the `from_network` method),
    and forwards them to its simulated application layer:

    *  We will call the `from_network` method with each packet received. (This method's return value
       does not matter.)
    *  Given a Message object `m`, you can call `self.to_application(m)` to send that message to the
       application.

    In `config.py`, we set global variables that will control your implementation,
    a variable `FOO` in this file is references as `config.FOO` below.

    Packet objects which have the following fields:

    *  `data`: up to 20 bytes, or the special value None to indicate no data is present
    *  `is_end`: a boolean field
    *  `seq_num`: an integer sequence number which must be between 0 and config.MAX_SEQUENCE  inclusive
    *  `ack_num`: an integer ack number which must be between 0 and config.MAX_SEQUENCE inclusive
        or the special value None to specify no ack number

    Message objects which have the following fields:

    *  `data`: up to 20 bytes (never None)
    *  `is_end`: a boolean field, which will be True if and only if this is the last message to be sent

    You will need to write/modify code to construct Packet objects from Message objects and vice-versa.

    The supplied code includes does not implement any form of reliability.


## Part 1 (first submission)

1.  Modify `ends.py`, so that when `config.MODE` is `one-zero`, it uses acknowledgments
    and a 1-bit sequence number (like in [section 2.5.1 of <i>Computer Networks:
    A Systems Approach</i>](https://book.systemsapproach.org/direct/reliable.html#stop-and-wait),
    and retransmits a packet (from the sender)
    indefinitely if an acknowledgment is not received config.TIMEOUT time units after a packet is sent.

2.  If `from_network` cannot immediately transmit a message, then it should return False and not
    queue the message. (Our simulator/testing code will try resending it later.)

2.  Test your implementation:

    *  With no losses (loss rate 0), two packets per 20 bytes of data + 1 or 2 extra packets should be sent in total.
    *  Running the simulator with high loss rates should still result in everything being transmitted
       consistently.
    *  With no or almost no losses, one segment should be transmitted per two delays, so running the simulator with
       `--delay=1` should result in a transmission rate of about 20 bytes/(1*2 time units) = 10 bytes per time unit.
## Part 2 (second submission)

<!-- FIXME: too much code for this supplied in book??? -->

1.  Modify `ends.py`, so that when `config.MODE` is `sliding`, it uses a sliding window
    (like in [section 2.5.2 of <i>Computer Networks:
    A Systems Approach</i>](https://book.systemsapproach.org/direct/reliable.html#sliding-window))
    with:
    *  a window size equal to `config.INITIAL_WINDOW` (which will be at least 1)
    *  sequence numbers ranging from 0 to `config.MAXIMUM_SEQUENCE` inclusive
       (`config.MAXIMUM_SEQUENCE` will be at least `config.INITIAL_WINDOW * 2 - 1`).
       To make your implementation simpler, we will gaurentee that MAXIMUM_SEQUENCE + 1 is a reasonable
       size for a Python list
    In addition:
    *   the first packet by the sender 
        sent should have a sequence number of 0, the second a sequence number of 1,
        and so on (regardless of the size of the packet)
    *   your implementation should retransmit packets (from the sender side) 
        after config.TIMEOUT time units of not receiving an ACK;
    *   your implementation must call `self.to_application` on messages in the order they were sent
        (even if they are not received in order)

2.  Test your implementation:

    *  With no losses (loss rate 0), no more than two packets per 20 bytes of data + 1 or 2 extra packets should be sent in total.
    *  With no or almost no losses, about config.MAXIMUM_SEQUENCE / 2 segments should be transmitted per round-trip. With a `--delay=1` and
       MAXIMUM_SEQUENCE of 10, this should resultin a transmission rate
       of around 20 bytes*5 segments/(1*2 time unit) = 50 bytes per time unit
    *  Running the simulator with high loss rates should still result in everything being transmitted
       consistently.

## Part 3 (third submission)

1.  Modify `ends.py`, so that when `config.MODE` is `variable-sliding`, it uses a variable sliding window,
    with:
    *  a initial window size equal to `config.INITIAL_WINDOW` (which will be at least 1)
    *  a maximum window size equal to `config.MAX_WINDOW` (which will be at least `config.INITIAL_WINDOW`)
    *  sequence numbers ranging from 0 to `config.MAXIMUM_SEQUENCE` inclusive
       (`config.MAXIMUM_SEQUENCE` will be at least `config.MAX_WINDOW * 2 - 1`).
       To make your implementation simpler, we will gaurentee that MAXIMUM_SEQUENCE + 1 is a reasonable
       size for a Python list
    *  window size increasing by one packet for each successful ACK (provided this does not exceed the maximum)
       and halving for each required retransmission (provided this does not make the new window size less than 1)

2.  Test your implementation by TBD.
    <!-- FIXME: bandwidth changing instructions -->

# Running the Code

1.  We provide two ways of running ends.py:

    *   One runs it over UDP/IP, allowing you to use the code on a real network. For this, run

            python3 udp_server.py --host=HOST --port=PORT --data-output=FILE

        to run a receiving UDP server on IP address (or DNS name) `HOST`, port number `PORT`, writing
        the received data to `FILE`. Then run

            python3 udp_client.py --host=HOST --port=PORT --data-input=FILE

        to run a sending UDP client that will connect to `HOST`, port number `PORT`, and send `FILE`
        in 20-byte chunks, followed by a special "END" segment.,

        In this mode, the timeout-related functions use real time. `udp_client.py` will exit when there
        are no pending timeouts after transmitting the special "END" segment. `udp_server.py` will exit
        after receiving the special "END" segment.

    *   The other runs it in a simulator, which allows you to use how your code deals with packet
        loss or corruption and allows you to run it faster (because the timeout functions will
        use a simulated clock).

        For this, run a command like

           python3 simulator.py --data-input=FILE --delay=0.1 --loss=0.01

        will run the simulation transmitting the contents of FILE with:

        *  a simulated delay of 0.1 time units,
        *  a simulated network buffer of 3 segments in each direction,

    The simulation will check that the received data matches the content of the FILE.

2.  The simulator also supports simulated bandwidth limits using the
    
        --bandwidth=BANDWIDTH

    and

        --buffer=BUFFER

    options.

    The simulated bandwidth is implemented by using the following logic
    on segment transmission:

    *  if the last segment was transmitted more than 1/*BANDWIDTH* time units ago, transmit
       the new segment immediately (so it is received with the *delay* time unit delay)
    *  if the last segment was transmitted less than 1/*BANDWIDTH* time units ago,
       and no other segments are pending transmission, transmit the the new segment
       1/*bandwidth* time units after the previous one;
    *  otherwise, if less than *BUFFER* segments are pending transmission

# API

## timers

1.  You will need to setup a timer to handle retransmissions, the `util` library provides a `create_timer`
    and `cancel_timer` method to do this.
    For example, code like:

        self.resend_timer = create_timer(
            10,
            lambda: self._do_resend()
        )

    will cause `self._do_resend()` to run 10 time units in the future.

    If, before `self._do_resend()` runs you decide you do not want to run it, then
    you can use

        cancel_timer(self.resend_timer)

    Most likely your `from_network` implementation that receives acknowledgments will do something like this.

# Hints


<!-- FIXME:
    packet -> frame
-->
