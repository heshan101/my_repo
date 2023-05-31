#!/usr/local/bin/python3

import TasksWrapper
tasks = TasksWrapper.TasksWrapper("T134487593,T134487595")

#print(tasks.get_taskinfo("description"))

task_list = tasks.get_taskinfo("details")
print('Printing tasks by detail.\n\n')
for task in task_list:
    print(task)
    print("\n\n\n")

task_list_summary = tasks.get_taskinfo('summary')
print('Printing tasks by summary.\n\n')
for task in task_list_summary:
    print(task)
    print('\n\n\n')

task_list_view = tasks.get_taskinfo('view')
print('Printing tasks by view.\n\n')
for task in task_list_view:
    print(task)
    print('\n\n\n')
