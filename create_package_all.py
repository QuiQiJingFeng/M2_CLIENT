#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import json
import sys
from Utils import Utils

VERSION = "1.0.0"

URL = "192.168.1.100:3000"

VERSION_INFO = {
    "packageUrl": "http://"+URL+"/package",
    "version": VERSION,
    "remoteVersionUrl": "http://192.168.1.100:3000/package/version.manifest",
    "remoteManifestUrl": "http://192.168.1.100:3000/package/project.manifest",
    "engineVersion": "3.15.1"
}

ASSETS_INFO = {
    "searchPath": [], 
    "packageUrl": "http://192.168.1.100:3000/package/{0}/".format(VERSION), 
    "version": VERSION, 
    "assets": {
    }, 
    "remoteVersionUrl": "http://192.168.1.100:3000/package/version.manifest", 
    "operator": "android", 
    "remoteManifestUrl": "http://192.168.1.100:3000/package/project.manifest", 
    "engineVersion": "3.1.5"
}

XXTEA_KEY = '10cc4fdee2fcd047'
XXTEA_SINGIN = 'gclR3cu9'

FILETERS_LIST = ['*.png','*.csb','*.plist','*.json','*.pb','*.atlas','*.lua','*.ogg','*.mp3','*.ttf']
RB_MODE_LIST = ['.png','.csb','.pb','.mp3','.ogg']

os.system('rm -r package;mkdir package;')
# 加密lua文件 并将加密后的文件写入package目录
Utils.encryptorDecryptFile(True,'src','package',XXTEA_KEY,XXTEA_SINGIN,FILETERS_LIST)
# 加密资源文件 并将加密后的文件写入package目录
Utils.encryptorDecryptFile(True,'res','package',XXTEA_KEY,XXTEA_SINGIN,FILETERS_LIST,[],RB_MODE_LIST)

ASSETS_CONFIG = {
    'src.zip':{'dir':'src'},
    'Default.zip':{'dir':'res/Default'},
    'card.zip':{'dir':'res/card'},
    'game.zip':{'dir':'res/game'},
    'games.zip':{'dir':'res/games'},
    'hallcomm.zip':{'dir':'res/hallcomm'},
    'proto.zip':{'dir':'res/proto'},
    'string.zip':{'dir':'res/string'}
}

# 切换目录
os.chdir("./package")
# 生成资源压缩包
for zip_name in ASSETS_CONFIG:
    entity = ASSETS_CONFIG[zip_name]
    dir_path = entity["dir"]
    md5 = Utils.Zip(dir_path,zip_name, FILETERS_LIST)
    entity['size'] = Utils.getFileSize(zip_name)
    entity['md5'] = md5
    entity['compressed'] = True
    del entity["dir"]

ASSETS_INFO['assets'] = ASSETS_CONFIG

# 生成热更的版本号列表
with open("version.manifest", 'w') as f:
    json.dump(VERSION_INFO, f, indent=4, sort_keys=True)
# 生成资源MD5列表
with open("project.manifest", 'w') as f:
    json.dump(ASSETS_INFO, f, indent=4, sort_keys=True)

os.system('rm -r res;rm -r src;')