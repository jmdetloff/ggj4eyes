#!/usr/bin/env python

import os
import sys
import json

DELIMITER = '\t'
TEXT_FILE_EXTN = '.txt'
JSON_FILE_EXTN = '.json'

DB_DIR = os.path.dirname(os.path.realpath(__file__))
INPUT_DIR = os.path.join(DB_DIR, 'input')
OUTPUT_DIR = os.path.join(DB_DIR, 'data')
OUTPUT_FILE_NAME = os.path.join(OUTPUT_DIR, 'everything.json')

FILES = filter(lambda x:x.endswith(TEXT_FILE_EXTN), os.listdir(INPUT_DIR))

megadict = {}
for fn in FILES:
	fn_no_ext = fn[:-len(TEXT_FILE_EXTN)]
	f = open(os.path.join(INPUT_DIR, fn), 'r')
	hdrline = f.readline().strip()
	typeline = f.readline().strip()
	lines = f.readlines()
	f.close()

	fields = hdrline.split(DELIMITER)
	lenfields = len(fields)

	types = typeline.split(DELIMITER)

	ret = []
	i = 0
	for line in lines:
		line = line.strip()
		d = {}
		entries = line.split(DELIMITER)
		for j in range(0, lenfields):
			if types[j] == 'int':
				d[fields[j]] = int(entries[j])
			elif types[j] == 'str':
				d[fields[j]] = entries[j]
			elif types[j] == 'dict':
				d[fields[j]] = json.loads(entries[j])
		ret.append(d)
		i += 1
	megadict[fn_no_ext] = ret
	# s = json.dumps(ret)

# outfn = os.path.join(OUTPUT_DIR, fn[:-len(TEXT_FILE_EXTN)]+JSON_FILE_EXTN)
g = open(OUTPUT_FILE_NAME, 'w')
g.write(json.dumps(megadict))
g.close()
# print 'Wrote to '+outfn+'.'
print 'Exported data.'