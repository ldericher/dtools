# dtools

[![Build Status](https://github.drone.yavook.de/api/badges/ldericher/dtools/status.svg)](https://github.drone.yavook.de/ldericher/dtools)

Minimal docker enabled [daemontools](https://cr.yp.to/daemontools.html) using centos image

## Quick start

    docker run -d --name daemontools ldericher/dtools

Services go to `/service` in the container.

You may want to look at the directory for a simple program run using daemontools.

## readlog script

Use the `readlog` command to inspect individual services in a container. Without the `-f` flag, the whole log is displayed in `less`. With `-f`, the log's tail is watched.

    docker exec daemontools readlog <service>
    docker exec daemontools readlog -f <service>

# More info

Services on daemontools: As described [by the Master himself](https://cr.yp.to/daemontools.html).
