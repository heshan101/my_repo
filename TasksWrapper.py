#!/usr/local/bin/python3

from subprocess import run, PIPE, TimeoutExpired
from multiprocessing import Pool
import json
import time
import re


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
        # stderr = None
        return stdout


class TasksWrapper:
    def __init__(self, task_num):
        self.task_num = task_num

    #Returns a summary list of tasks. Will take a single task number or a csv list of task numbers.
    #Action can be summary, view, details, description
    def get_taskinfo(self, action):
        task_list = []
        task_id = self.task_num.split(',')

        for task in task_id:
            cmd = 'tasks {} {}'.format(action, task)
            task_list.append(run_cmd(cmd))
        return task_list
