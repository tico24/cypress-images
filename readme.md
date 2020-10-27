
Based on the [official cypress images](https://github.com/cypress-io/cypress-docker-images).

The official images are programatically built, which bloats them out. They also have a number of critical vulnerabilities that they are choosing to not fix.

This build produces the equivalent of a cypress/browsers build.

You can change the environment variables at the top to choose specific browser versions.

Node version 14.

-----

This is by no means a perfect build and can almost certainly be shrunk further. I originally wrote it to overcome the vulnerabilities, but thought it might be useful to others:

https://github.com/cypress-io/cypress-docker-images/issues/370
https://github.com/cypress-io/cypress-docker-images/issues/380