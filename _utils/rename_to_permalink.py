#!/usr/bin/env python

from __future__ import print_function

import os
import pipes
import sys

def get_permalink(filename):
    frontmatter = -1
    for line in open(filename):
        line = line.rstrip()

        if line == '---':
            frontmatter += 1
            if frontmatter > 0:
                raise ValueError(
                    'cannot find permalink in frontmatter for {!r}'.format(
                        filename))
            continue

        if frontmatter != 0:
            continue

        if line.startswith('permalink: '):
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
            permalink = get_permalink(filepath)

            if not permalink.endswith('/'):
                print('SKIP: permalink does not end with /: {!r}'.format(
                    filepath))
                continue

            new_basename = os.path.basename(permalink.rstrip('/'))
            suspected_dir = os.path.join(dirpath, new_basename)

            new_filepath = os.path.join(suspected_dir, 'index.md') \
                if os.path.isdir(suspected_dir) \
                else suspected_dir + '.md'

            if new_filepath == filepath:
                continue

            if os.path.exists(new_filepath):
                print('SKIP: not overwriting existing file {!r}'.format(
                    new_filepath))
                continue

            print('renaming {!r} to {!r}'.format(filepath, new_filepath))
            #os.rename(filepath, new_filepath)
            os.system('git mv {} {}'.format(
                pipes.quote(filepath),
                pipes.quote(new_filepath)))

        for dirname in dirnames:
            if dirname != dirname.lower():
                print('WARNING: directory {!r} contains upper case letters, '
                    'correct manually'.format(os.path.join(dirpath, dirname)))



if __name__ == '__main__':
    sys.exit(main())
