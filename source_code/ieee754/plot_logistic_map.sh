#!/usr/bin/env bash

echo $1

gnuplot --persist << EOI

    set key off
    plot "$1" using 1:3 with dots

EOI
