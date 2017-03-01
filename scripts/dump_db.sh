#!/bin/sh
pg_dump -O -x -t access_sets -t competitors -t problems -t set_contents -t sets -t access_prereqs -t fame_problems -t languages -t notify_prereqs -t progress -t result_types -t results -t status_types -t submissions -t watchers train
