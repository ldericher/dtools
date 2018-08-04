# dtools

Minimal docker enabled [daemontools](https://cr.yp.to/daemontools.html) using centos image

## Quick start

    docker run -d --name daemontools ldericher/dtools

Services go to `/service` in the container.

You may want to look at the `test` tag and directory for a simple program run using daemontools:

    docker run -d --name daemontools ldericher/dtools:test

# More info

Services on daemontools: As described [by the Master himself](https://cr.yp.to/daemontools.html).
