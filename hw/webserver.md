---
title: Webserver
author: Charles Reiss
...

# Your Task

1.  Using the standard Python [socket](https://docs.python.org/3/library/socket.html) library,
    and any data structure and text encoding-related standard Python libraries of your choice,
    create a webserver. Your webserver must:

    *  be startable by running `python3 webserver.py 127.0.0.1 PORT` 
    *  listen on IP address 127.0.0.1, port number PORT, and look for files in 
       `webroot` directory in the directory where it is run from
    *  implement HTTP/1.1, where
       *  only the GET method is supported; requests using any other method always return
          a "405 Method Not Allowed" error.
       *  GET requests for the path `/FOO` are handled as follows:
          *  if `FOO` contains any `/`s *or* the file `FOO` does not exist in `webroot`,
             then the webserver returns a "404 Not Found" response whose body
             is the contents of `404.html` in the webroot directory
             (or text of your choice if that file does not exist)
          *  if `FOO` exists in webroot but is not readable,
             the webserver returns a "403 Not Authorized" response whose
             body is the contents of `403.html` in the webroot directory
             (or text of your choice if that file does not exist)
          *  otherwise, the webserver returns "200 OK" response whose
             body is the contents of the file `FOO` in webroot
       *  When returning a file from a GET request, if its extension `html` or `htm`,
          the `Content-Type` header is set to `text/html`; if its extension is `txt`,
          the `Content-Type` header is set to `text/plain`. Otherwise, the
          `Content-Type` header may be omitted or set as you choose.

2.  Test your server using TBD.

3.  Submit your server by TBD.
