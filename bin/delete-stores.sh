#!/bin/bash

# This script deletes all .DS_Store and AppleDouble files (._*) in the current directory and its subdirectories.

find . -name '.DS_Store' -delete
find . -name '._*' -delete
