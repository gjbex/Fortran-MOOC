#!/usr/bin/env python

import argparse
from bs4 import BeautifulSoup
import subprocess


def parse_args():
    parser = argparse.ArgumentParser(description='Convert FutureLearn Markdown to HTML')
    parser.add_argument('input_file', help='Input Markdown file to convert')
    parser.add_argument('output_file', help='Output HTML file')
    return parser.parse_args()

def main():
    args = parse_args()

    # Run pandoc on the input file to convert Markdown to HTML, using MathJax and no code highlighting
    # Output is captured in a string to be further processed by BeautifulSoup
    try:
        process = subprocess.run(
            [
                'pandoc',
                '--mathjax',
                '--no-highlight',
                '--to=html5',
                args.input_file,
            ],
            check=True,
            capture_output=True,
        )
    except subprocess.CalledProcessError as e:
        print(f'Error running pandoc: {e}')
        return 1
    except FileNotFoundError:
        print('Error: pandoc is not installed or not found in PATH.')
        return 2
    html = process.stdout.decode('utf-8')

    # Parse the HTML with BeautifulSoup
    soup = BeautifulSoup(html, 'html.parser')

    # Find all <span class="math display">...</span>
    for span in soup.find_all('span', class_='math display'):
        if (content := span.string) and content.startswith(r'\[') and content.endswith(r'\]'):
            # Remove \[ and \], replace with \( and \)
            inner = content[2:-2]  # remove \[ and \]
            span.replace_with(f'\\({inner}\\)')

    # Write the modified HTML to a new file
    with open(args.output_file, 'w', encoding='utf-8') as file:
        file.write(str(soup))

if __name__ == '__main__':
    main()
