#!/bin/sh
set -e
lgogdownloader --update-check
lgogdownloader --download --save-serials
rm -rf $(lgogdownloader --check-orphans | grep ^/download)
