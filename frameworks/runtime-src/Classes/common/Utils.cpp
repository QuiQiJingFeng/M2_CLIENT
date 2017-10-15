//
//  Utils.cpp
//  aam2_client
//
//  Created by JingFeng on 2017/10/1.
//
//

#include "Utils.h"
#include "cocos2d.h"
#include "external/unzip/unzip.h"
#include "external/xxtea/xxtea.h"
USING_NS_CC;

static std::string basename(const std::string& path)
{
    size_t found = path.find_last_of("/\\");
    
    if (std::string::npos != found)
    {
        return path.substr(0, found);
    }
    else
    {
        return path;
    }
}

bool Utils::unzipFile(std::string path,std::string outpath)
{
#define BUFFER_SIZE    8192
#define MAX_FILENAME   512
    
    const std::string& zip = FileUtils::getInstance()->fullPathForFilename(path);
    
    size_t pos = zip.find_last_of("/\\");
    if (pos == std::string::npos)
    {
        return false;
    }
    
    const Data& data = FileUtils::getInstance()->getDataFromFile(zip);
    unzFile zipfile = unzOpenBuffer(data.getBytes(), data.getSize());
    
    if (!zipfile)
    {
        return false;
    }
    
    // Get info about the zip file
    unz_global_info global_info;
    if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
    {
        CCLOG("can not read file global info of %s\n", zip.c_str());
        unzClose(zipfile);
        return false;
    }
    
    // Buffer to hold data read from the zip file
    char readBuffer[BUFFER_SIZE];
    // Loop to extract all files.
    uLong i;
    for (i = 0; i < global_info.number_entry; ++i)
    {
        // Get info about current file.
        unz_file_info fileInfo;
        char fileName[MAX_FILENAME];
        if (unzGetCurrentFileInfo(zipfile,
                                  &fileInfo,
                                  fileName,
                                  MAX_FILENAME,
                                  NULL,
                                  0,
                                  NULL,
                                  0) != UNZ_OK)
        {
            CCLOG("can not read compressed file info\n");
            unzClose(zipfile);
            return 0;
        }
        const std::string fullPath = outpath + fileName;
        
        // Check if this entry is a directory or a file.
        const size_t filenameLength = strlen(fileName);
        if (fileName[filenameLength - 1] == '/')
        {
            //There are not directory entry in some case.
            //So we need to create directory when decompressing file entry
            if (!FileUtils::getInstance()->createDirectory(basename(fullPath)))
            {
                // Failed to create directory
                CCLOG("can not create directory %s\n", fullPath.c_str());
                unzClose(zipfile);
                return false;
            }
        }
        else
        {
            // Entry is a file, so extract it.
            // Open current file.
            if (unzOpenCurrentFile(zipfile) != UNZ_OK)
            {
                CCLOG("can not extract file %s\n", fileName);
                unzClose(zipfile);
                return false;
            }
            
            // Create a file to store current file.
            FILE *out = fopen(fullPath.c_str(), "wb");
            if (!out)
            {
                CCLOG("can not create decompress destination file %s\n", fullPath.c_str());
                unzCloseCurrentFile(zipfile);
                unzClose(zipfile);
                return false;
            }
            
            // Write current file content to destinate file.
            int error = UNZ_OK;
            do
            {
                error = unzReadCurrentFile(zipfile, readBuffer, BUFFER_SIZE);
                if (error < 0)
                {
                    CCLOG("can not read zip file %s, error code is %d\n", fileName, error);
                    fclose(out);
                    unzCloseCurrentFile(zipfile);
                    unzClose(zipfile);
                    return false;
                }
                
                if (error > 0)
                {
                    fwrite(readBuffer, error, 1, out);
                }
            } while (error > 0);
            
            fclose(out);
        }
        
        unzCloseCurrentFile(zipfile);
        
        // Goto next entry listed in the zip file.
        if ((i + 1) < global_info.number_entry)
        {
            if (unzGoToNextFile(zipfile) != UNZ_OK)
            {
                CCLOG("can not read next file for decompressing\n");
                unzClose(zipfile);
                return false;
            }
        }
    }
    
    unzClose(zipfile);
    
    return true;
}

bool Utils::versionGreater(const std::string& version1, const std::string& version2)
{
    size_t pos1 = version1.find(".");
    size_t pos2 = version2.find(".");
    
    std::string majorVer1 = version1.substr(0, pos1);
    std::string majorVer2 = version2.substr(0, pos2);
    
    size_t pos3 = version1.find(".", pos1 + 1);
    size_t pos4 = version2.find(".", pos2 + 1);
    
    std::string minorVer1 = version1.substr(pos1 + 1, pos3 - pos1 - 1);
    std::string minorVer2 = version2.substr(pos2 + 1, pos4 - pos2 - 1);
    
    int m1 = atoi(majorVer1.c_str());
    int m2 = atoi(majorVer2.c_str());
    if (m1 > m2)
    {
        return true;
    }
    else if (m1 < m2)
    {
        return false;
    }
    
    int m3 = atoi(minorVer1.c_str());
    int m4 = atoi(minorVer2.c_str());
    
    if (m3 > m4)
    {
        return true;
    }
    else if (m3 < m4)
    {
        return false;
    }
    
    std::string fixVer1 = version1.substr(pos3 + 1);
    std::string fixVer2 = version2.substr(pos4 + 1);
    
    if (atoi(fixVer1.c_str()) > atoi(fixVer2.c_str()))
        return true;
    
    return false;
}
//解密
long Utils::xxteaDecrypt(unsigned char* bytes,long size,char* xxteaSigin,char* xxteaKey)
{
    xxtea_long len = 0;
    void *buffer = nullptr;
    buffer = xxtea_decrypt(bytes + strlen(xxteaSigin),
                           (xxtea_long)size - (xxtea_long)strlen(xxteaSigin),
                           (unsigned char*)xxteaKey,
                           (xxtea_long)strlen(xxteaKey),
                           &len);
    return len;
}

