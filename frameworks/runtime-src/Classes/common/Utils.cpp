//
//  Utils.cpp
//  aam2_client
//
//  Created by JingFeng on 2017/10/1.
//
//

#include "Utils.h"
#include "cocos2d.h"
#include "unzip/unzip.h"
#include "xxtea/xxtea.h"
#include "lame/lame.h"
USING_NS_CC;

Utils* Utils::__instance = nullptr;

Utils* Utils::getInstance()
{
    if(__instance == nullptr){
        __instance = new Utils();
    }
    return __instance;
}

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

/*
   //wav格式音频转换成mp3格式的音频
 
    lame_set_quality(lame_global_flags *, int); 设置压缩品质，quality=0..9. 0=best (very slow). 9=worst. 品质越好转码速度越慢
 */
//const char* wav_path,const char* mp3_path
Value Utils::convertWavToMp3(ValueVector vector)
{
    string wav = vector[0].asString();
    string mp3 = vector[1].asString();
    const char* wav_path = wav.c_str();
    const char* mp3_path = mp3.c_str();

    FILE *fwav = fopen(wav_path, "rb");
    fseek(fwav, 1024*4, SEEK_CUR); //跳过源文件的信息头，不然在开头会有爆破音
    FILE *fmp3 = fopen(mp3_path, "wb");

    lame_global_flags * lame = lame_init(); //初始化
    lame_set_in_samplerate(lame, 8000.0); //设置wav的采样率
    lame_set_num_channels(lame, 1); //声道，不设置默认为双声道
    lame_set_quality(lame, 9);      //品质设置


    lame_init_params(lame);

    const int PCM_SIZE = 640 * 1; //双声道*2 单声道640即可
    const int MP3_SIZE = 8800; //计算公式pcm_size * 1.25 + 7200
    short int pcm_buffer[PCM_SIZE];
    unsigned char mp3_buffer[MP3_SIZE];

    int read, size;

    do {
        //将文件读进内存
        read = fread(pcm_buffer, sizeof(short int), PCM_SIZE, fwav);
        if (read == 0) {
            //当read为0，说明pcm文件已经全部读取完毕，调用lame_encode_flush即可。
            size = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
        } else { //当read不为0，调用lame_encode_buffer_xxx进行转码
            //双声道千万要使用lame_encode_buffer_interleaved这个函数
            //32位、单声道需要调用其他函数，具体看代码后面的说明
            size = lame_encode_buffer_interleaved(lame, pcm_buffer, read/2, mp3_buffer, MP3_SIZE);
        }
        //保存mp3文件
        fwrite(mp3_buffer, size, 1, fmp3);
    } while (read != 0);
    //记得各种关闭
    lame_close(lame);
    fclose(fmp3);
    fclose(fwav);
    return Value(true);
}












