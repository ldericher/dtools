# dtools

Minimal docker enabled [daemontools](https://cr.yp.to/daemontools.html) using centos image

## Quick start

    docker run -d --name daemontools ldericher/dtools

Services go to `/service` in the container.

You may want to look at the `test` tag and directory for a simple program run using daemontools:

    docker run -d --name daemontools ldericher/dtools:test

## readlog script

Use the `readlog` command to inspect individual services in a container. Without the `-f` flag, the whole log is displayed in `less`. With `-f`, the log's tail is watched.

    docker exec daemontools readlog <service>
    docker exec daemontools readlog -f <service>

# More info

Services on daemontools: As described [by the Master himself](https://cr.yp.to/daemontools.html).
