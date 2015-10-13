#!/usr/bin/env python

from __future__ import print_function

import os
import re
import sys

re_camel = re.compile(r'[a-z][A-Z]')

def get_title(filename):
    frontmatter = -1
    for line in open(filename):
        line = line.rstrip()

        if line == '---':
            frontmatter += 1
            if frontmatter > 0:
                raise ValueError(
                    'cannot find title in frontmatter for {!r}'.format(
                        filename))
            continue

        if frontmatter != 0:
            continue

        if line.startswith('title: '):
            return line.split(None, 1)[1].strip()

    if frontmatter < 0:
        raise ValueError('no frontmatter found in {!r}'.format(filename))


def main():
    for dirpath, dirnames, filenames in os.walk('.'):
        for filename in filenames:
            if not filename.endswith('.md'):
                continue

            if dirpath == '.' and filename == 'README.md':
                continue

            filepath = os.path.join(dirpath, filename)
            title = get_title(filepath)

            if re_camel.search(title):
                print('{} {!r}'.format(filepath, title))


if __name__ == '__main__':
    sys.exit(main())
