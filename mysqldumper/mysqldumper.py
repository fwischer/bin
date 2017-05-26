#!/usr/bin/env python

from filehandler import FileHandler
from sqlexport import SqlExport

fileHandler = FileHandler('/Users/fwischer/Download/dump/', '/Users/fwischer/Download/archive/')

filehandler.create_if_not_exists()
filehandler.move_to_archive()
fileHandler.foo()

sqlexport = SqlExport('/Users/fwischer/Download/dump/', 'baufuchs_db_')
sqlexport.dump_sql()

