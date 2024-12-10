#!/bin/bash
###############################################
#   Set Output File for Failed Login Attempts #
###############################################
LOG_FILE = # /path/to/your/desired/file.txt #
################################################################################
# Check /var/log/auth.log for Instances of Failed Logins / Incorrect Passwords #
################################################################################
grep "authentication failure;" /var/log/auth.log | awk '{print $1, $2, $3, $11}' >> $LOG_FILE
