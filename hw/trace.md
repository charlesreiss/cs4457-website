---
title: Reliable Transport
author: Charles Reiss
...

# Your Task

1.  Obtain a packet trace of uploading a file of at least 1MB by TBD.

2.  Extract from that trace, extract: 

    *  the timestamp for each TCP segment in the trace
    *  whether the segment was an ACK, SYN, SYN+ACK, or something else
    *  the segment number for each segment sent from the local to remote host
    *  the acknowledgment number for each ACK segment sent from the remote to local host

    Create a scatterplot of this data, with time as the X axis, segment number or
    acknowledgment number as the Y axis,
    and some indication of the type of segment in the marker (color, marker shape, etc.)

    Save this plot in PNG or PDF or SVG format in `segments_by_time.png` or `segments_by_time.pdf`
    or `segments_by_time.svg`.

3.  In a text file `answers.txt`, answer the following questions:

    1.  Were transmitted data packets ever resent in the trace?

    2.  TCP allows a receiver to acknowledge multiple segments at once with one acknowledgment.
        (For example, if 1000-data-byte segments with segment numbers 3000, 4000, 5000, 6000, 7000 are sent,
        an acknowledgment with 6000 will acknowledge 3000, 4000, and 5000, stating the receiver is expecting
        How often does this happen in the trace?

    3.  What was the approximate round-trip-time between the local and remote host? Was this consistent throughout
        the trace? Explain briefly what calculations you used to determine this.

    4.  As best can be determined from the trace,
        what was the approximate bandwidth available between the local and remote host? Explain briefly
        what calculations you used to determine this.


