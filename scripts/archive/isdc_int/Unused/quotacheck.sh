#!/bin/sh

/usr/bin/at -s 8am tomorrow < /home/isdc_guest/isdc_int/local/bin/quotacheck.sh

/home/isdc_guest/isdc_int/local/bin/quotacheck.pl

