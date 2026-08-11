#!/bin/bash
# sysinfo.sh - Prints basic system information
# Usage: ./sysinfo.sh

echo "===== SYSTEM INFO ====="

echo -e "\n--- Current User ---"
whoami

echo -e "\n--- Current Date ---"
date

echo -e "\n--- Disk Usage ---"
df -h

echo -e "\n========================"
