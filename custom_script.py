#!/usr/bin/python
# -*- coding: utf-8 -*-
import os

# custom_script.py
# event是在cocos命令中预先定义的事件名称。
# target_platform是您正在编译的目标平台。
# args是事件的更多参数。

def handle_event(event,target_platform,args):
    if(event == 'pre-build' and target_platform == 'android'):
        project_path = args['project-path']
        os.chdir(project_path)
        os.system('python create_package_all.py')
