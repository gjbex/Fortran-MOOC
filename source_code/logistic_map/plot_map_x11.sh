#!/usr/bin/env bash

gnuplot --persist << EOI
set terminal x11
set key off
plot "$1" using 1:2 with dots
EOI
