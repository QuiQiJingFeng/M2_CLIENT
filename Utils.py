# -*- coding: utf-8 -*-
import os
import time
import json
import re
import struct
import fnmatch
import zipfile
import hashlib


class Utils:
    'Utils类 提供常用方法的封装'
    # 定义私有属性

    ######################################################################
    # 文件目录处理相关
    ######################################################################
    # 检测是否是目录 return boolean
    @staticmethod
    def isDir(path):
        return os.path.isdir(path)

    # 检测是否是文件  return boolean
    @staticmethod
    def isFile(path):
        return os.path.isfile(path)

    # 检测是否是绝对路径  return boolean
    @staticmethod
    def isAbsolute(path):
        return os.path.isabs(path)

    # 检测路径是否存在 return boolean
    @staticmethod
    def isExist(path):
        return os.path.exists(path)

    # 返回路径的最后一节  return string
    @staticmethod
    def getBaseName(path):
        return os.path.basename(path)

    # 返回path的目录 returnstring
    @staticmethod
    def getPathDir(path):
        return os.path.dirname(path)

    # 路径字符转换
    # 在Linux和Mac平台上，该函数会原样返回path
    # 在windows平台上会将路径中所有字符转换为小写，并将所有斜杠转换为反斜杠。
    # return string
    @staticmethod
    def getConvertPath(path):
        return os.path.normcase(path)

    # 返回文件的后缀名(例如: .lua) return string
    @staticmethod
    def getLastSuffixName(path):
        return os.path.splitext(path)[1]

    # 获取文件的大小
    @staticmethod
    def getFileSize(path):
        return os.path.getsize(path)

    # 获取文件或目录的最后修改时间
    @staticmethod
    def getLastChangeTime(path):
        return os.path.getmtime(path)

    ######################################################################
    # 字符串处理相关
    ######################################################################
    # 字符串替换 并返回替换后的字符串
    # @content 原始字符串
    # @filt   匹配字符串
    # @rep    匹配后进行替换的字符串
    # @times  替换的次数 本参数可以省略,如果省略就意味着全部替换
    @staticmethod
    def replaceStr(content, filt, rep, times):
        return content.replace(filt, rep, times)

    # 字符串查找
    # 找到返回索引，找不到返回-1
    # 从下标0开始，查找在字符串里第一个出现的子串
    @staticmethod
    def findStr(content, sub):
        return content.find(sub, 0)

    # 字符串反向查找
    # 找到返回索引，找不到返回-1
    # 从下标0开始，查找在字符串里第一个出现的子串
    @staticmethod
    def rfindStr(content, sub):
        return content.rfind(sub, 0)

    # 字符串分割
    # @content 待分割的字符串
    # @char 分隔符
    # @times  分割次数,如果不指定则有多少分割多少
    @staticmethod
    def splitStr(content, char, times):
        return content.split(char, times)

    # 字符串截取 左闭右开区间[)
    # [0:3] 截取从索引[0] ~ [2] 的字符(不包含[3])
    # [:]   截取全部的字符
    # [6:]  截取索引[6]到末尾的所有字符
    # [:-3] 截取从索引[0]到索引[-4]之间的所有字符
    # [3]   截取索引为[3]的字符
    # [-5:-3] 截取索引[-5] ~ [-4]之间的所有字符
    @staticmethod
    def subStr(content, start, end):
        return content[start:end]

    # 获取字符串的长度
    @staticmethod
    def getStrLength(content):
        return len(content)

    # 去掉字符串中的空格
    @staticmethod
    def trimStr(content):
        return content.replace(" ", "")

    ######################################################################
    # 日期相关
    ######################################################################
    # 将格林威治时间转换成可读的日期
    # %y 两位数的年份表示（00-99）
    # %Y 四位数的年份表示（000-9999）
    # %m 月份（01-12）
    # %d 月内中的一天（0-31）
    # %H 24小时制小时数（0-23）
    # %I 12小时制小时数（01-12）
    # %M 分钟数（00=59）
    # %S 秒（00-59）
    # %a 本地简化星期名称
    # %A 本地完整星期名称
    # %b 本地简化的月份名称
    # %B 本地完整的月份名称
    # %c 本地相应的日期表示和时间表示
    # %j 年内的一天（001-366）
    # %p 本地A.M.或P.M.的等价符
    # %U 一年中的星期数（00-53）星期天为星期的开始
    # %w 星期（0-6），星期天为星期的开始
    # %W 一年中的星期数（00-53）星期一为星期的开始
    # %x 本地相应的日期表示
    # %X 本地相应的时间表示
    # %Z 当前时区的名称
    # %% %号本身
    @staticmethod
    def convertToDate(seconds):
        return time.strftime("%Y-%m-%d %H:%M:%S", seconds)

    # 获取当前的格林威治时间
    @staticmethod
    def getTime():
        return time.time()

    ######################################################################
    # 列表相关
    ######################################################################
    # 列表排序
    # @list 待排序的列表
    # @reverse 是否反转排列顺序
    # @compre 比较函数
    @staticmethod
    def sortList(array, rever, compare):
        sorted(array, reverse=rever, cmp=compare)

    ######################################################################
    # 文件相关
    ######################################################################
    # 获取文本文件内容
    @staticmethod
    def getStringFromFile(path,mode='r'):
        content = ""
        try:
            file = open(path, mode)
            content = file.read()
        except Exception, e:
            print '-------------------'
            print 'READ FILE ERROR:', e, path
            print '-------------------'
        return content

    # 写入文件内容
    @staticmethod
    def writeStringToFile(path, content):
        try:
            file = open(path, "w")
            file.write(content)
        except Exception, e:
            print '-------------------'
            print 'WRITE FILE ERROR:', e, path
            print '-------------------'

    # 向文件中追加内容
    @staticmethod
    def appendStringToFile(path, content):
        try:
            file = open(path, "a+")
            file.write(content)
        except Exception, e:
            print '-------------------'
            print 'APPEND FILE ERROR:', e, path
            print '-------------------'

    ######################################################################
    # 遍历指定目录,生成文件的MD5的json文件
    ######################################################################
    # 递归多个目录获取下面文件的MD5码并写入project.json文件
    # @curDir 需要递归的目录
    # @extra 需要忽略的目录 例如: *.svn *.git 或者 res/ui
    # @filt 筛选 例如 *.lua *.res
    # @path 生成的json文件写入路径
    # @ find 参数 -o 代表或的意思  -path '' -prune 代表忽略该目录 -name 代表筛选的目标
    # @ 参考 http://wangchujiang.com/linux-command/c/find.html
    @staticmethod
    def generalProjectFile(dirs=['src', 'res'], extra=['*.git', '*.svn'], filts=['*.png', '*.json', '*.atlas', '*.csb', '*.lua', '*.plist', '*.pb'], path='project.json'):  
        for curDir in dirs:
            # 查找当前目录
            command = 'find ' + curDir + ' '
            # 跳过指定目录
            command += '\( '
            for idx in xrange(len(extra)):
                command += '-path ' + extra[idx] + ' -prune '
                if(idx != len(extra) - 1):
                    command += '-o '
            command += '\) -o '
            # 指定类型为文件
            command += '-type f '
            # 指定文件的后缀
            command += '\( '
            for idx in xrange(len(filts)):
                command += '-name "' + filts[idx] + '" '
                if(idx != len(filts) - 1):
                    command += '-o '
            command += '\) '

            command += '-print0 | xargs -0 md5 -r >> temp.md5;'
            os.system(command)

        content = Utils.getStringFromFile('temp.md5')
        arrays = re.split('\n| ', content)
        size = len(arrays)
        srcMap = {}
        index = 0
        while(index + 1 < size):
            value = arrays[index]
            key = arrays[index + 1]
            index += 2
            srcMap[key] = value
        with open(path, 'w') as f:
            json.dump(srcMap, f, indent=4, sort_keys=True)
        os.system("rm temp.md5;")

    ######################################################################
    # lua 文件加密
    ######################################################################
    # 加密lua文件
    # @rootDir 加密的根目录
    # @outDir 输出目录
    # @xxteKey 加密的key
    # @xxteaSign 文件头 用来确定文件从哪里开始
    # @includes 筛选器 ['*.lua']
    # @excludes 要跳过的目录
    # @rblist 对于二进制文件 以rb方式读取,文本文件以rU方式读取
    # XXTEA_KEY = "10cc4fdee2fcd047"  XXTEA_SIGN = "gclR3cu9"
    @staticmethod
    def encryptorDecryptFile(isEncrypt=True, rootDir='src', outDir='.', xxteKey='10cc4fdee2fcd047', xxteaSign='gclR3cu9', includes=['*.lua'], excludes=[],rblist=['*.csb','*.png'],skip=['.mp3']):
        _DELTA = 0x9E3779B9

        def _long2str(v, w):
            n = (len(v) - 1) << 2
            if w:
                m = v[-1]
                if (m < n - 3) or (m > n):
                    return ''
                n = m
            s = struct.pack('<%iL' % len(v), *v)
            return s[0:n] if w else s

        def _str2long(s, w):
            n = len(s)
            m = (4 - (n & 3) & 3) + n
            s = s.ljust(m, "\0")
            v = list(struct.unpack('<%iL' % (m >> 2), s))
            if w:
                v.append(n)
            return v

        def Encrypt(str, key):
            if str == '':
                return str
            v = _str2long(str, True)
            k = _str2long(key.ljust(16, "\0"), False)
            n = len(v) - 1
            z = v[n]
            y = v[0]
            sum = 0
            q = 6 + 52 // (n + 1)
            while q > 0:
                sum = (sum + _DELTA) & 0xffffffff
                e = sum >> 2 & 3
                for p in xrange(n):
                    y = v[p + 1]
                    v[p] = (v[p] + ((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z))) & 0xffffffff
                    z = v[p]
                y = v[0]
                v[n] = (v[n] + ((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[n & 3 ^ e] ^ z))) & 0xffffffff
                z = v[n]
                q -= 1
            return _long2str(v, False)

        def Decrypt(str, key):
            if str == '':
                return str
            v = _str2long(str, False)
            k = _str2long(key.ljust(16, "\0"), False)
            n = len(v) - 1
            z = v[n]
            y = v[0]
            q = 6 + 52 // (n + 1)
            sum = (q * _DELTA) & 0xffffffff
            while (sum != 0):
                e = sum >> 2 & 3
                for p in xrange(n, 0, -1):
                    z = v[p - 1]
                    v[p] = (v[p] - ((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z))) & 0xffffffff
                    y = v[p]
                z = v[n]
                v[0] = (v[0] - ((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4) ^ (sum ^ y) + (k[0 & 3 ^ e] ^ z))) & 0xffffffff
                y = v[0]
                sum = (sum - _DELTA) & 0xffffffff
            return _long2str(v, True)

        def DoEncrypt(rootDir, xxteKey, xxteaSign, includes, excludes,rblist):
            for root, dirs, files in os.walk(rootDir, topdown=True):
                dirs[:] = [d for d in dirs if d not in excludes]
                for pat in includes:
                    for f in fnmatch.filter(files, pat):
                        suffix = Utils.getLastSuffixName(f)
                        mode = 'rU'
                        if suffix in rblist:
                            mode = 'rb'
                        file = open(os.path.join(root, f), mode)
                        s = file.read()
                        if suffix in skip:
                            str = s
                        else:
                            str = Encrypt(s, xxteKey)
                            str = xxteaSign + str
                        file.close()
                        
                        outpath = os.path.join(outDir,root)
                        if(not os.path.exists(outpath)):  
                            os.makedirs(os.path.join(outDir,root))

                        file = open(os.path.join(outDir,root, f), "wb")
                        file.write(str)
                        file.close()

        def DeEncrypt(rootDir, xxteKey, xxteaSign, includes, excludes):
            for root, dirs, files in os.walk(rootDir, topdown=True):
                dirs[:] = [d for d in dirs if d not in excludes]
                for pat in includes:
                    for f in fnmatch.filter(files, pat):
                        file = open(os.path.join(root, f), "rb")
                        s = file.read()
                        s = s[len(xxteaSign):]
                        str = Decrypt(s, xxteKey)
                        file.close()

                        outpath = os.path.join(outDir,root)
                        if(not os.path.exists(outpath)):  
                            os.makedirs(os.path.join(outDir,root))

                        file = open(os.path.join(outDir,root, f), "wb")
                        file.write(str)
                        file.close()
        if(isEncrypt):
            DoEncrypt(rootDir, xxteKey, xxteaSign, includes, excludes,rblist)
        else:
            DeEncrypt(rootDir, xxteKey, xxteaSign, includes, excludes)

    ######################################################################    # 压缩指定目录
    ######################################################################
    # @root_dir 要压缩的目录
    # @out_file_name 压缩文件的名称 xxx.zip
    # @includes 筛选要压缩的文件
    # @excludes 不进入压缩包的目录
    # 正在生成的存档不仅包含压缩文件数据，还包含“额外的文件属性” (创建时间)
    # 如果这种元数据在压缩之间有所不同，那么您将永远不会得到相同的校验和，因为压缩文件的元数据已更改，并已包含在归档中。
    # @return md5 所以要通过计算原始文件 来生成MD5,避免两次生成的MD5只不一样
    
    @staticmethod
    def Zip(root_dir, out_file_name, includes,excludes=[]):
        md5 = hashlib.md5()
        # 创建zip文件
        zf = zipfile.ZipFile(out_file_name, "w", zipfile.ZIP_DEFLATED)
        # 遍历文件夹
        for root, dirs, files in os.walk(root_dir, topdown=True):
            dirs[:] = [d for d in dirs if d not in excludes]
            # 文件夹排序
            dirs.sort()
            # 文件排序
            files.sort()
            # 添加初始目录
            zf.write(root + "/")
            # 筛选指定文件 并添加到zip文件中
            for pat in includes:
                for f in fnmatch.filter(files, pat):
                    file_path = os.path.join(root, f)
                    s = Utils.getStringFromFile(file_path,'rb')
                    zf.writestr(file_path, s)
                    md5.update(s)
        return md5.hexdigest()
