---
title: reliable transport
author: Charles Reiss (based on ...)
...
# Your Task

1.  Download the supplied simulator and skeleton code [here](files/reliable-skeleton.tgz) (last updated 22 July 2024).

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

    *  With no losses (loss rate 0), two packets per packet of data + 1 or 2 extra packets should be sent
       in total.
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

    <!-- FIXME: fast retransmit -->

2.  Test your implementation:

    *  With no losses (loss rate 0) and a timeout substantially longer than twice the transmission delay,
       no more than two packets per packet of data + 1 or 2 extra packets should be sent in total.
    *  With no or almost no losses, about config.MAXIMUM_SEQUENCE / 2 segments should
       be transmitted per round-trip. With a `--delay=1` and
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
    *  window size increasing by approximately one packet for each round trip time
       (provided this does not exceed the maximum) when packets are not lost
    *  when packets are lost, the window size is approximately halved (to a minimum of 1)

2.  Test your implementation:

    *  Losses should be handled like the previous methods.
    *  Regardless of the INITIAL_WINDOW setting, the transmission rate should be approximately determined
       by the simulated bandwidth (provided that the buffer size is not too small or large relative
       to the bandwidth-delay product).

<!-- FIXME: something with varying buffer -->

# Running the Code

## In simulator

1.  You can run your implementation in a simulator, which allows you to use how your code deals with packet
    loss or corruption and uses a simulated clock for timeouts.

    For example, a command like:

       python3 simulator.py --generate-input=100 --delay=0.1

    will run the simulator:

    *  transmitting 100 20-byte messages, which will be sent as fast as possible,
    *  a simulated delay of 0.1 time units for transmitting (in either direction),

    The simulator will check that the received data matches the sent data and is in order.
    The simulator will terminate without an error message when all data is received
    (via the `to_application` method).

2.  You can override `config.py` settings in the simulator using a corresponding command-line option;
    for example:

       python3 simulator.py ... --mode one-zero

    will run the simuluation with the settings specified by `...` but with `config.MODE` set to `'one-zero'`.

3.  The simulator supports simulated random losses with the `--drop` option.

    For example, a command like:

       python3 simulator.py --generate-input=100 --delay=0.1 --drop=0.01 --mode one-zero --timeout 1

    will run the simulation:

    *  transmitting 100 20-byte message, which will be sent as fast as possible,
    *  a simulated delay of 0.1 time units for transmitting (in either direction),
    *  with 1% of packets dropped (chosen at random),
    *  setting `config.MODE` to `'one-zero'` and `config.TIMEOUT` to `1`

2.  The simulator also supports simulated bandwidth limits using the
    
        --bandwidth=BANDWIDTH

    and

        --buffer=BUFFER-SIZE

    options.

    In this simulation each link has a buffer that can hold *BUFFER-SIZE* packets.
    To transmit a packet, it is first added to the buffer. Then, packets are removed
    the buffer at least 1/*BANDWIDTH* time units after the last packet was transmitted. 

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
