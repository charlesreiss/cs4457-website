---
title: distance vector routing
author: Charles Reiss
...

# Your Task

1.  Download the skeleton code at TBA.

2.  Edit `entity.py` to implement a distributed distance vector algorithm using distributed
    Bellman-Ford.

    In this file, you will implement four functions described in more detal below.

    Three of these functions relate to constructing and maintaining the routing information:
    *  `initialize_costs` --- setup initial costs based on the simulated network
        topology
    *  `build_packet_array` --- return packets to send neighbors to share
        distance information
    *  `update` --- handle receiving a packet, possible producing new packets
        to send to neighbors

    One of these should query the information:
    *  `forward_next_hop` --- given a destination, return best next hop for a packet
        being sent to that destination

3.  Test your submission by TBD.

4.  Submit your code by TBD.

# Detailed description

TO DO: copy from previous version
