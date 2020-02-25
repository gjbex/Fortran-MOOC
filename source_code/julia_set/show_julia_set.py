#!/usr/bin/env python

from argparse import ArgumentParser
import matplotlib.pyplot as plt
import numpy as np
import sys


def read_data(file_name):
    data = np.genfromtxt(file_name, dtype=np.uint8)
    return data


def visualize_data(data):
    plt.imshow(np.log1p(data/255.0))
    plt.axis('off')


def main():
    arg_parser = ArgumentParser(description='visualize julia set')
    arg_parser.add_argument('file', help='file name')
    options = arg_parser.parse_args()
    data = read_data(options.file)
    visualize_data(data)
    plt.show()
    return 0

if __name__ == '__main__':
    status = main()
    sys.exit(status)
