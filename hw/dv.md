---
title: distance vector routing
author: Charles Reiss
...

# Your Task

1.  Download the skeleton code at TBA.

2.  Edit `entity.py` to implement a distributed distance vector algorithm using distributed
    Bellman-Ford, like is described in section
    [3.4.2](https://book.systemsapproach.org/internetworking/routing.html) of
    _Computer Networks: A Systems Approach_.

    Our simulator will construct an instance of the `Entity` class to represent each
    router on a simulated network. Each Entity will be assigned a 0-based index.

    The Entity class includes the following methods:

    *   a constructor (the `__init__` method) which stores the entity's index
        and total number of entities. Our skeleton code also sets up a
        instance variables to store a cost and next-hop table.
        You may modify this to store the state differently, but if you do so,
        you'll need to also modify the `forward_next_hop` method.

    *  `initialize_costs`: called with a list of the neighboring routers and
        the costs to reach them. This method should return a list of `Packet` objects
        to send (to the routers specified by each packet's destination).

        Our skeleton code stores the costs in an instance variable and returns
        an empty list of packets. You should modify it to return a non-empty list of
        packets.

    *  `update`: called when a packet is received from another route.r Like the
        `initialize_costs` method, it should return a (possibly empty) list of
        `Packet` objects to send to other routers. 

        Our skeleton code returns an empty list of packets. You should modify it to
        process the packet sent and send any update packets needed to neighboring nodes.

    *  `forward_next_hop`: return the next hop to use to reach a particular entity.
       Our skeleton code reads from the next-hop table setup by `__init__`, so if you
       use that table, you should not need to edit this method.

    *  `get_all_costs`: return a table of all next-hop costs. We will not use this for testing,
        but it may be helpful for debugging in combination with simulator's `display_forwarding_table`.

3.  Test your submission by:

    *  using or modifying `sample.py` to run the simulator by hand; and/or

    *  using `test.py` to run several automated test cases.

4.  Submit your code by TBD.
