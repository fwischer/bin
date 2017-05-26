#!/usr/bin/env python

import os
import time
import shutil


class FileHandler:
    dumpDir = ''
    archiveDir = ''

    def __init__(self, dump_dir, archive_dir):
        self.archiveDir = archive_dir
        self.dumpDir = dump_dir

    def create_if_not_exists(self):
        if not os.path.exists(self.dumpDir):
            os.makedirs(self.dumpDir)
        if not os.path.exists(self.archiveDir):
            os.makedirs(self.archiveDir)

    def move_to_archive(self):
        cutoff = self._get_time_cutoff()

        files = os.listdir(self.dumpDir)
        for file in files:
            self.foo(cutoff, file)

    def foo(self, cutoff, file):
        if os.path.isfile(self.dumpDir + file):
            age = os.stat(self.dumpDir + file)
            fileage = age.st_ctime

            if fileage < cutoff:
                shutil.move(self.dumpDir + file, self.archiveDir + file)

    def _get_time_cutoff(self):
        now = time.time()
        cutoff = now - (14 * 86400)
        return cutoff


fileHandler = FileHandler('/Users/fwischer/Download/dump/', '/Users/fwischer/Download/archive/')
fileHandler.create_if_not_exists()
fileHandler.move_to_archive()

