#!/bin/bash

echo ============================= >> /var/log/update_script.log
echo NEW UPDATE                    >> /var/log/update_script.log
date                               >> /var/log/update_script.log
echo ============================= >> /var/log/update_script.log
(apt update && apt -y upgrade) >> /var/log/update_script.log 2>> /var/log/update_script.log
echo ============================= >> /var/log/update_script.log
echo END UPDATE                    >> /var/log/update_script.log
echo ============================= >> /var/log/update_script.log
