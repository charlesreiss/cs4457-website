---
title: packet scheduling/queuing discpline
author: Charles Reiss
...

# Your Task

1.  Download the template code at TBD.

    This code includes a setup for a simulator where two connections
    called "c1" and "c2" between the same two hosts, a "sender"
    and "receiver". The "sender" can send packets to the "receiver" via
    a shared "forward" link, and the "receiver" to the "sender"
    via a shared "backward" link.

    Each connection uses AIMD congestion control, to divide the bandwidth
    of the "forward" link and only sends acknowledgments over the backward link.
    By default, the connections receive messages at a rate faster than the forward link's
    bandwidth indefinitely.

    The simulation allows for interchangeable buffer implementations on the simulated link.
    The default is a simple drop-tail, first-in-first-out scheme implemented in
    the "DropTailBuffer" in buffer.py

    For each connection, the simulation measures the achieved bandwidth and latency.

2.  Examine the latency and bandwidth achieved for each of the following scenarios

    A.  each connection generates messages faster than the link can handle
    B.  c1 generates messages at slightly less than half of the link's bandwidth
        and the c1 at the link's bandwidth
    C.  c2 generates messages at slightly less than half of the link's bandwidth
        and the c1 at the link's bandwidth

3.  Add a new buffer implemetnation in buffer.py called PriorityQueueBuffer

    In this implementation, implement a strict priority scheme where packets from
    connection c1 are serviced before packets from connection c2. You can identify which connection
    a packet is from using `packet.label` which will be `c1` for connection c1
    and `c2` for connection c2.

    When the queue capacity is exceeded, your implementation must discard the newest packet
    from connection c2, if possible; otherwise, it should discard the newest packet from
    connection c1.

    Measure the bandwidth and latency of your scheme with each of the above scenarios. If you
    are successful:

    *  for all scenarios, the latency for connection c1 should not substantially exceed
       the latency with the drop tail strategy
    *  for scenario A and scenario C, c1 should use almost all the bandwidth and c2 should get achieve than 10% of the available
       bandwidth.
    *  for scenario B, c1 should achieve its full desired bandwidth and c2 should use remaining bandwidth
    *  for scenario B, c1's latency should be much less than c2's and close to the link delay


2.  Add a new buffer implementation in buffer.py called WeightedFairQueuingBuffer.

    In this implementation, implement weighted fair queuing, where packets from connection c1
    get twice the bandwidth as packets from connection c2. You can identify which connection
    a packet is from using `packet.label` which will be `c1` for connection c1
    and `c2` for connection c2.

    Your implementation must avoid
    keeping more than the specified (in our call to `__init__`) capacity number of packets;
    provided that you achieve the bandwidth/latency results specified below, we do not care what
    scheme you choose for selecting what packets to drop when the queue is full.

    Measure the bandwidth and latency of your scheme with each of the above scenarios. If you
    are successful:

    *  for all scenarios, the median latency should not be much more than twice the total of
       the link delay + the buffer capacity divided by the link bandwidth
    *  for scenario A and scenario C, c1 should achieve about twice the bandwidth of connection c2
    *  for scenario B, c1 should achieve its full desired bandwidth and c2 should use remaining bandwidth

