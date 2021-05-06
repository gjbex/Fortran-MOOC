#!/usr/bin/env python

from argparse import ArgumentParser
import numpy as np

if __name__ == '__main__':
    arg_parser = ArgumentParser(description='solve set of linear equations')
    arg_parser.add_argument('--A', help='file containing A')
    arg_parser.add_argument('--b', help='file containing b')
    options = arg_parser.parse_args()
    A = np.genfromtxt(options.A)
    b = np.genfromtxt(options.b)
    x = np.linalg.solve(A, b)
    print(x)
