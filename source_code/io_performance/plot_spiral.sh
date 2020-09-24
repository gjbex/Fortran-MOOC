#!/usr/bin/env bash

if [ $# -ne 1 ]
then
    (>&2 echo "error: expecting data file as argument" )
    exit 1
fi

if [ ! -e "$1" ]
then
    (>&2 echo "error: file '$1' does not exist" )
    exit 2
fi

if [[ "$1" == *.txt ]]
then
    gnuplot --persist << EOI
        set size square
        set polar
        plot "$1" using 1:2 with dots
EOI
elif [[ "$1" == *.bin ]]
then
    gnuplot --persist << EOI
        set size square
        set polar
        plot "$1" binary format='%double%double' using 1:2 with dots
EOI
else
    (>&2 echo "error: use files with extension .txt or .bin only" )
    exit 3
fi
