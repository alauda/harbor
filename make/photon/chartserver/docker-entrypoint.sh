#!/bin/bash
set -e


/home/chart/install_cert.sh

source /home/chart/exports_env_in_dir.sh /etc/env-files/

#Start the server process
exec /home/chart/chartm
