#!/usr/local/bin/python3

import os
import sys
import re

print('')
print('')
print('Please paste Resort information')
print('')
print("Press 'ctrl+d' on MAC or 'ctrl+z' on windows devices to exit, followed by the return/enter key")
print('')

lines = sys.stdin.readlines()

print('')
print('---------------------------')
print('|   Circuit Information   |')
print('---------------------------')
print('')


out = [(" " if line.startswith(" ") else "\n") + line.strip() for line in lines]
out = ''.join(out).split('\n')
#print(out)


regex = re.compile(r'((fa|ma|ssw|rsw|fsw|eb|csw|dr)[0-9]+([a-z]+)*(\-|\.)+((p|s|du|uu)[0-9]+)*(\.f01)+\.pnb[-0-9]:(eth|Ethernet|et\-)[0-9]+(\/[0-9]+)*(\/[0-9]+)*)', re.MULTILINE)
out=[re.findall(regex, e) for e in out]
#for [x for x in out if x != []]:
print('##################')
print(out)




'''
regex = re.compile(r'((fa|ma|ssw|rsw|fsw|eb|csw|dr)[0-9]+([a-z]+)?(\-|\.)?((p|s|du|uu)[0-9]+)?(\.f01)?\.pnb[-0-9]:(eth|Ethernet|et\-)[0-9]+(\/[0-9]+)?(\/[0-9]+)?)', re.MULTILINE)
out=[re.findall(regex, e) for e in out]
print(out)
'''

#regex=re.findall('((fa|ma|ssw|rsw|fsw|eb|csw|dr)[0-9]+([a-z]+)?(\-|\.)?((p|s|du|uu)[0-9]+)?(\.f01)?\.pnb[-0-9]:(eth|Ethernet|et\-)[0-9]+(\/[0-9]+)?(\/[0-9]+)?)', out)
#print(regex)
