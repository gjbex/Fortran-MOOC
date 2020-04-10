#/usr/gin/env bash

gnuplot --persist << EOI
    set key off
    plot "$1" using 3:4 with lines
EOI
