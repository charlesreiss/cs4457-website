---
title: Framing
author: Charles Reiss
...

# Your Task

1.  Download the supplied skeleton code [here](files/framing-skeleton.tgz)^[
        If you want to work on portal or similar, you might find it useful to right-click the
        link, select "copy link" or "copy URL" from the drop-down menu, then run the command
        `wget THAT_URL`, where `THAT_URL` is the result of pasting the link/URL.
    ] (last updated 22 July 2024).

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

    4.  Be your own code and use only functionality built-in to python or supplied as
        part of its standard library. This means that it _is_ permissible to use
        the `zlib` module's [`crc32` function](https://docs.python.org/3/library/zlib.html#zlib.crc32)
        and the [`struct` module](https://docs.python.org/3/library/struct.html). But it
        is _not_ permissible to use, for example, [python-pppd](https://pypi.org/project/python-pppd/)

3.  Test your implementation using `test.py`. If you want to run additional tests, you might
    find it useful to modify the list of tests in `TESTS` or pass the `--verbose` option to this script.

    When grading, we may run additional tests and/or inspect your code by hand. Although
    the supplied tests do not intentionally omit any cases you must handle, since they are randomized, they
    may get "unlucky" and fail to detect an implementation which is actually broken.
    (Also, it may be possible for them to spuriously fail on a correct implementation,
    though I think that is unlikely.)

4.  *Briefly* document in a comment or docstring near the top of your `sendrecv.py` the
    frame format you choose.

4.  Submit your `sendrecv.py` by *TBD*.
