---
title: packet schedule
author: Charles Reiss
...

# Your Task

1.  Download the template code at TBD.

    This code includes a setup for a simulator where two connections
    that use AIMD congestion control send data over a common link.
    The simulation also measures the transmission latency from when the
    application transmits messages until when they are received.

    In the initial simulation, the queue is managed using a "drop tail" strategy.

2.  Use the existing simulator measure how the connection performance is affected by
    the buffer size. When doing this:

    *  set --generate-input=... to a high number (e.g. 100k) and use --time-limit=.... to limit how
       long the simulation runs. Ensure that both connections do nothave enough time to send all
       the available data.
    *  vary the buffer size using --buffer-size=...
    
    Produce a plot of the achieved:
    
    *  average transmission time
    *  average bandwidth achieved

2.  Modify the simulation to implement "random early detection"; instead
    of only dropping packets when the queue is full, drop packets with
    probability `Min(0, (QueueOccupency% - 50) / 50)`%.

    Produce the same plot of the achieved average transmission time with your new scheme.

2.  Modify the simulation to implement each of the following schemes for taking packets
    out of the queue:

    *  a priority-based scheme, where packets for connection 1 are dropped before
       packets for connection 2 which are dropped before packets for connection 3;

    *  fair queuing, providing round-robin service between the three connections;

4.  In `results.txt` report:

    *  the bandwidth achieved under each queuing scheme with and without random early detection

5.  Submit your code and your results.txt in TBD.
