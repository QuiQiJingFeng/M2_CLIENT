#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import json
from Utils import Utils


class Resource:
    '脚本刷新原理: 生成本地MD5列表,跟app中的MD5列表比对,如果有文件更新则刷新'
    _remoteDir = ''
    _md5Name = ''
    _appPath = ''

    # 初始化md5文件名称,远端路径
    def __init__(self):
        self._md5Name = 'project.json'
        tarDir = './runtime/mac/'
        content = os.popen('ls ' + tarDir)
        self._appPath = tarDir + content.read().replace('\n', '', 1)
        self._remoteDir = self._appPath + '/Contents/Resources/'
    
    # 获取MD5码列表
    def getMD5List(self, path):
        is_exist = Utils.isExist(path)
        if(not is_exist):
            return {}
        content = ''
        with open(path, 'r') as f:
            content = json.load(f)
        return content

    # 刷新资源
    def refreshResource(self):
        # 生成本地MD5列表
        Utils.generalProjectFile()
        # 获取远端的MD5列表
        remoteList = self.getMD5List(self._remoteDir + self._md5Name)
        # 获取本地MD5列表
        localList = self.getMD5List(self._md5Name)
        command = ''
        for key in localList:
            # 如果两个文件的MD5值不一样,则替换
            if(remoteList.get(key) != localList.get(key)):
                remoteFile = self._remoteDir + key
                is_exist = Utils.isExist(remoteFile)
                if(not is_exist):
                    os.system('mkdir -p ' + Utils.getPathDir(remoteFile))
                print 'update key=>' + key
                command = 'cp {0} {1};'.format(key, remoteFile)
                os.system(command)
        command = 'cp {0} {1};'.format(self._md5Name, self._remoteDir + self._md5Name)
        command += 'rm ' + self._md5Name + ';'
        os.system(command)

    def runApp(self):
        command = 'open -n ' + self._appPath + ' --args -console enable;'
        os.system(command)


obj = Resource()
obj.refreshResource()
obj.runApp()
