#!/bin/bash
set -euo pipefail

# This script deletes all .DS_Store and AppleDouble files (._*) in the current directory and its subdirectories.
find . -type f \( -name '.DS_Store' -o -name '._*' \) -delete
