#!/usr/local/bin/python3

# need to export ticket number and hostname at minimum and put in file called ticket.txt
# results will be written to file called dr_results.txt

# argv.py
import re
import argparse
import sys
import subprocess

if(sys.argv[1]):
    building=sys.argv[1]
print (building)
with open('dr_results.txt', mode='w') as dr_result:
    with open('ticket.txt') as ticket_file:
        ticket = ticket_file.readline()

        while(ticket):
            hosts = re.findall(r'((fa|ssw|rsw|rtsw|fsw|eb|csw|ctsw|dr)[0-9]+([a-z]+)?(\-|\.)?((p|s|du|uu)[0-9]+)?(\.)?([a-z]?[0-9]+)?\.pnb[0-9](:(eth|Ethernet|et\-)[0-9]+(\/[0-9]+)?(\/[0-9]+)?)?)', ticket)
            if hosts != None:

                for host in hosts:
                    dl_cmd = subprocess.getoutput('drainer list | grep ' + host[0])
                    #print(dl_cmd)
                    #print(ticket)
                    if dl_cmd != "":
                        dr_result.write(ticket + '\n' + dl_cmd)
                        print(ticket + '\n' + dl_cmd)

            ticket = ticket_file.readline()
   # with open('compared_drainer_results.txt', mode='w') as results:
   #     for item in tickets:
