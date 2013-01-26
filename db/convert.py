#!/usr/bin/env python

import os
import sys
import json

DELIMITER = ','
TEXT_FILE_EXTN = '.txt'
JSON_FILE_EXTN = '.json'

DB_DIR = os.path.dirname(os.path.realpath(__file__))
INPUT_DIR = os.path.join(DB_DIR, 'input')
OUTPUT_DIR = os.path.join(DB_DIR, 'data')

FILES = filter(lambda x:x.endswith(TEXT_FILE_EXTN), os.listdir(INPUT_DIR))

for fn in FILES:
	f = open(os.path.join(INPUT_DIR, fn), 'r')
	hdrline = f.readline().strip()
	typeline = f.readline().strip()
	lines = f.readlines()
	f.close()

	fields = hdrline.split(DELIMITER)
	lenfields = len(fields)

	types = typeline.split(DELIMITER)

	ret = {}
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
		ret[str(i)] = d
		i += 1
	s = json.dumps(ret)

	outfn = os.path.join(OUTPUT_DIR, fn[:-len(TEXT_FILE_EXTN)]+JSON_FILE_EXTN)
	g = open(outfn, 'w')
	g.write(s)
	g.close()
	print 'Wrote to '+outfn+'.'