---
title: Framing
author: Charles Reiss
...

# Your Task

1.  Download the supplied skeleton code at TBA.

2.  In `sendrecv.py` complete an implementation of MySender and MyReceiver.

    In MySender's `send_message` function, format a message to be sent
    as a sequence of bytes, then call `self.channel.send_bytes()` with those bytes.

    In MyReceiver's `handle_byte_from_network` function, receive a byte from
    the network, then call `self.got_message_function()` when those bytes
    represent a full message passed to `MySender`'s `send_message` function.

    To help you understand this interface, we have an example implementation in
    `nulsendrecv.py`, which can send and receive messages successfully, but does not
    implement all the requirements below.

    Your implementation must:

    1.  Be able to send messages of any length between 0 and 1023 bytes, inclusive

    2.  Allow messages to contain any sequence of bytes (of an appropriate length).
        (This means that, for example, we should be able to take some of the bytes your
        `send_message` function produces and send a new message containing them without
        it being corrupted.)

    3.  If a message's bytes are corrupted, by changing the values of bytes randomly
        and/or adding and removing bytes randomly, then:

        1.  You should detect this and avoid calling `got_message_function` with data
            that does not represent a valid message at least 99.99% of the time.

        2.  Other than possibly the next few messages or kilobytes of messages, future
            uncorrupted messages should be received correctly (regardless of where the
            corruption took place).
