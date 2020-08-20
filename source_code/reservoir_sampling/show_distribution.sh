#!/usr/bin/env bash

file_name=$1

for i in 1 2 3; do echo -n "$i: "; grep $i "$file_name" | wc -l; done
