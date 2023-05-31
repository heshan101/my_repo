#!/usr/bin/env python3
import argparse
from subprocess import run, PIPE, TimeoutExpired
from multiprocessing import Pool
import json
import time
import re

"""
This tool checks for drained circuits
then verifies there is an open NWT or an open task with an owner.
"""

parser = argparse.ArgumentParser(
    description="""
    Usage:
        Specify a site to check: 'pnb' 'atn'
            -s pnb
            Example: ./drained_circuit_audit.py -s pnb
            You can specify all sites by using 'all' as the site name

            -c hostname:interface
            Example: ./drained_circuit_audit.py --c rsw034.p071.f01.pnb5:eth1/3/1
        """,
    formatter_class=argparse.RawTextHelpFormatter,
)
#group = parser.add_mutually_exclusive_group(required=True)
group = parser.add_argument_group("Query", "Query circuits at a datacenter for a drained circuit audit.")
group.add_argument("-s", "--site", type=str.lower, help="site name")
group.add_argument("-c", "--circuit", type=str.lower, help="circuit name")
group.add_argument("-d", "--device", type=str.lower, help="device name")
group.add_argument("-r", "--regex", type=str.lower, help="regex")
args = parser.parse_args()


def run_cmd(cmd):
    # run a given command, implement retries and error detection, return stdout
    for _attempt in range(1):
        try:
            result = run(cmd, timeout=300, stdout=PIPE, stderr=PIPE, shell=True)
        except TimeoutExpired as e:
            result = e
        stdout, stderr = result.stdout, result.stderr

        if stdout:
            stdout2 = stdout.decode('utf-8')
            return stdout2
        elif stderr:
            stderr2 = stderr.decode('utf-8')
            return stderr2
    else:
        print("Command failed:" + cmd)
        stdout = None
        #stderr = None
        return stdout


def find_resort(drained_element):
    element_name = drained_element['element_name']
    element_type = drained_element['element_type']
    is_galaxy = drained_element['is_galaxy']
    resort_results = {}
    resort_results['open_nwt_bool'] = False
    cmd_resort = 'resortcli get name="{}" -f Status,ticket_number --json'.format(element_name)

    if is_galaxy:
        items = element_name.split(".", 1)
        element_name = "{}.*{}".format(items[0], items[1])
        cmd_resort = 'resortcli get name=~"{}" -f Status,ticket_number --json'.format(element_name)

    resort_list = run_cmd(cmd_resort)

    resort_results['resort_status'] = 'CLOSED'
    resort_results['resort_ticket'] = 'unknown'

    try:
        resort_json = json.loads(resort_list)
        for resort_dict in resort_json:
            if resort_dict['Status'] != 'CLOSED':
                resort_results['resort_status'] = resort_dict['Status']
                resort_results['resort_ticket'] = "nwt{}".format(str(resort_dict['ticket_number']))
                resort_results['open_nwt_bool'] = True  # found an open ticket, move into next element_name
    except:
        if '(No results)' in resort_list:
            resort_results['resort_status'] = 'no_ticket'
            resort_results['resort_ticket'] = 'unknown'
        elif resort_list is None:
            resort_results['resort_status'] = 'result_fail'
            resort_results['resort_ticket'] = 'unknown'

    if 'CIRCUIT' in element_type and resort_results['open_nwt_bool'] == False:
        # Try with Z/A-end layout if not a agg/port_channel (reversed)
        result_groups = re.search(r"(.*:.*)-(\D\D.*[a-z]{3}[0-9].*:.*)", element_name)
        if result_groups:  # element_name is format "host:int-host:int"
            a_device = result_groups.group(1)
            z_device = result_groups.group(2)
            element_name_reversed = "{}-{}".format(z_device, a_device)
            cmd_resort = 'resortcli get name="{}" -f Status,ticket_number --json'.format(element_name_reversed)
            resort_list = run_cmd(cmd_resort)
            try:
                resort_json = json.loads(resort_list)
                for resort_dict in resort_json:
                    if resort_dict['Status'] != 'CLOSED':
                        resort_results['resort_status'] = resort_dict['Status']
                        resort_results['resort_ticket'] = "nwt{}".format(str(resort_dict['ticket_number']))
                        resort_results['open_nwt_bool'] = True  # found an open ticket, move into next element_name
            except:
                if '(No results)' in resort_list:
                    resort_results['resort_status'] = 'no_ticket'
                    resort_results['resort_ticket'] = 'unknown'
                elif resort_list is None:
                    resort_results['resort_status'] = 'result_fail'
                    resort_results['resort_ticket'] = 'unknown'
    return resort_results


def find_task(drained_element):
    task_id = drained_element['task_id']
    cmd_task = 'tasks summary {}'.format(task_id)
    task_string = run_cmd(cmd_task)
    task_list = task_string.split()
    task_results = {}
    task_results['task_owner'] = task_list[1]
    task_results['task_status'] = task_list[2]
    return task_results


def dt(epoch_time):
    dt = time.strftime('%Y-%m-%d', time.localtime(epoch_time))
    return dt


def result_handler(drained_element):
    # get resort ticket info if it exists
    resort_results = find_resort(drained_element)
    drained_element.update(resort_results)

    # get task info if it exists
    task_results = find_task(drained_element)
    drained_element.update(task_results)

    # print results to stdout
    result_list = []
    if drained_element['open_nwt_bool'] == False:
        result_list.append(drained_element['element_name'])
        result_list.append(drained_element['created_time'])
        result_list.append(drained_element['db_id'])
        result_list.append(drained_element['task_id'])
        result_list.append(drained_element['task_status'])
        result_list.append(drained_element['task_owner'])
        result_list.append(drained_element['resort_status'])
        result_list.append(drained_element['resort_ticket'])
        print('{:75s} {:12s} {:10s} {:12s} {:12s} {:20s} {:12s} {:14s}'.format(*result_list))


def thread_control(drained_results):
    #processes
    pool = Pool()
    pool.map(result_handler, drained_results)
    pool.close()
    pool.join()


def get_drained_elements(inp):
    if 'site' in inp['type']:
        # input is a site, generate generic circuit regex

        # Use this to capture all interaces/aggs drained
        # input_regex = '.*{}.*:.*'.format(inp['value'])

        # Use this to capture only circuits with A/Z-end ' host:int' pairs
        # input_regex = '.*:.*-\D\D.*{}.*:.*'.format(inp['value'])

        # Use this to capture only fabric circuits
        input_regex = '(rsw|rtsw|ssw|fa).*{}.*'.format(inp['value'])
        element_type = 'CIRCUIT'
        print("Defaulting to circuits when a site is provided.")

    elif 'circuit' in inp['type'] or 'device' in inp['type']:  # used for circuits, devices
        input_regex = '.*{}.*'.format(inp['value'])
        # print(input_regex)
        element_type = inp['type'].upper()
    elif 'regex' in inp['type']:
        input_regex = '.*{}.*'.format(inp['value'])
        element_type = 'CIRCUIT'
        print("Defaulting to circuits when a regex is provided.")
    else:
        print("Did not find valid drainer query input.")
        exit()

    drained_list = 'drainer list -f drained_items.is_ref==1 -f drained_items.display_name=~"{}" -f drained_items.element_type="{}" -F json'.format(input_regex, element_type)

    drained_circuit_list = run_cmd(drained_list)
    try:
        drained_circuit_json = json.loads(drained_circuit_list)
    except:
        print("Failed to gather drained items")
        exit()
    drained_results = []


    if drained_circuit_json is None:
        print("Did not find any drained items matching input, exiting...")
        exit()

    #print(json.dumps(drained_circuit_json, indent=4, sort_keys=True))
    #exit()

    for drain_job in drained_circuit_json:
        caller = drain_job['caller']['name']
        created_time = dt(drain_job['created_time'])
        db_id = str(drain_job['db_id'])
        task_id = "T{}".format(str(drain_job['task_id']))
        is_galaxy = False

        # Set drain job to galaxy if any item matches
        for drained_items in drain_job['drained_items']:
            element_name = drained_items['display_name']
            result = re.search(r"(fsw\d+)\-\w\w\d+(.p.*)", element_name)
            # element_name matches a galaxy lc/fc/mm card
            if result:
                # set true if any item in the drain job is a galaxy card
                is_galaxy = True

        for drained_items in drain_job['drained_items']:
            tmp_dict = {}
            element_name = drained_items['display_name']
            result = re.search(r"(fsw\d+)\-\w\w\d+(.p.*)", element_name)
            # element_name matches a galaxy lc/fc/mm card
            if result:
                element_name = '{}{}'.format(result.group(1), result.group(2))
            # rebuild dict so we have an entry per circuit drained
            tmp_dict['caller'] = caller
            tmp_dict['created_time'] = created_time
            tmp_dict['db_id'] = db_id
            tmp_dict['task_id'] = task_id
            tmp_dict['element_name'] = element_name
            tmp_dict['element_type'] = element_type
            tmp_dict['is_galaxy'] = is_galaxy
            drained_results.append(tmp_dict)

    # dedupe drained_results so we only have one entry per unique hostname
    drained_results_deduped = []
    for i in range(len(drained_results)):
        if drained_results[i] not in drained_results[i+1:]:
            drained_results_deduped.append(drained_results[i])

    #print(json.dumps(drained_results_deduped, indent=4, sort_keys=True))
    #exit()
    # return a list of dicts
    return drained_results_deduped


def main(args):
    s = getattr(args, "site", None)
    c = getattr(args, "circuit", None)
    d = getattr(args, "device", None)
    r = getattr(args, "regex", None)
    inp = {}
    if s is None and c is None and d is None and r is None:
        print("Please provide an input.")
        print("Use --help to check usage, exiting...")
        exit()
    elif s == "all" and c is None and d is None and r is None:
        inp['value'] = "[a-z]{3}[0-9]"
        inp['type'] = 'site'
        print("Checking all sites")
    elif s and c is None and d is None and r is None:
        inp['value'] = s.lower().strip()
        inp['type'] = 'site'
        print("Checking site: " + s)
    elif c and s is None and d is None and r is None:
        inp['value'] = c.lower().strip()
        inp['type'] = 'circuit'
        print("Checking circuit: " + c)
    elif d and s is None and c is None and r is None:
        inp['value'] = d.lower().strip()
        inp['type'] = 'device'
    elif r and s is None and c is None and d is None:
        inp['value'] = r.lower().strip()
        inp['type'] = 'regex'
    else:
        print("Error with input.")
        exit()


    # Get drained circuit list
    drained_results = get_drained_elements(inp)
    # print(json.dumps(drained_results, indent=4, sort_keys=True))
    # exit()

    print("Found {} drained elements, checking for open Tickets and Tasks.".format(len(drained_results)))
    print("Elements displayed below are drained but have no open tickets.")
    print("----")
    print('{:75s} {:12s} {:10s} {:12s} {:12s} {:20s} {:12s} {:14s}'.format("ELEMENT_NAME", "DRAIN_DATE", "DRAIN_ID", "TASK_ID", "TASK_STATUS", "TASK_OWNER", "NWT_STATUS", "NWT_NUMBER"))

    # Thread out each drained circuit
    thread_control(drained_results)
    print("----")

if __name__ == '__main__':
    main(args)
