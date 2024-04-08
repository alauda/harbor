#!/bin/sh

set -e

/home/scanner/install_cert.sh

source /home/scanner/exports_env_in_dir.sh /etc/env-files/

export SCANNER_TRIVY_GITHUB_TOKEN=$gitHubToken

exec /home/scanner/bin/scanner-trivy
