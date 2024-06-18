---
title: packet schedule
author: Charles Reiss
...

# Your Task

1.  Download the template code at TBD.

    This code includes a setup for a simulator where three connections
    that use AIMD congestion control send data over a common link.

    In the initial simulation, the queue is managed using a FIFO strategy.

2.  Modify the simulation to implement "random early detection"; instead
    of only dropping packets when the queue is full, drop packets with
    probability `Min(0, (QueueOccupency% - 50) / 50)`%. (So no packets
    are dropped if the queue is less than 50% full, an incoming packet is dropped 50%
    of the time if the queue is 75% full, and an incoming packet is dropped 100%
    of the time if the queue is 100% full.)

2.  Modify the simulation to implement each of the following schemes for taking packets
    out of the queue:

    *  a priority-based scheme, where packets for connection 1 are dropped before
       packets for connection 2 which are dropped before packets for connection 3;

    *  fair queuing, providing round-robin service between the three connections;

4.  In `results.txt` report:

    *  the bandwidth achieved under each queuing scheme with and without random early detection

5.  Submit your code and your results.txt in TBD.
