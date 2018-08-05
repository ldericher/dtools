# dtools:test

Minimal services running on `ldericher/dtools`.

Both print out "Test!" every three seconds, which is then logged by `multilog`.

## `test-normal` 

Running as a normal service.

## `test-runwhen` 

Running with runwhen, basically a cronjob but nicer. 
Refer to the RUNWHEN variable documented at the top of `test-runwhen/run`.
