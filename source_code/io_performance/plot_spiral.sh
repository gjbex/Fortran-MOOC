#!/usr/bin/env bash

gnuplot --persist << EOI
    set size square
    set polar
    plot "$1" using 1:2 with dots
EOI
