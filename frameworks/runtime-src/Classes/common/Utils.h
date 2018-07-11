//
//  Utils.hpp
//  aam2_client
//
//  Created by JingFeng on 2017/10/1.
//
//

#ifndef Utils_h
#define Utils_h

#include <string>
#include "FYDC.h"
class Utils {
    
public:
    //need full_path
    bool unzipFile(std::string path,std::string outpath);
    bool versionGreater(const std::string& version1, const std::string& version2);
    long xxteaDecrypt(unsigned char* bytes,long size,char* xxteaSigin,char* xxteaKey);
    
    // wav转mp3
    bool convertWavToMp3(string wavPath,string mp3Path);
    FValue convertWavToMp3(FValueVector vector);
    
    static Utils* getInstance();
    // 导入PlatformSDK.h头文件,并且实现registerFunc方法,那么就可以在Lua中直接调用
    void registerFunc(){
        REG_OBJ_FUNC(Utils::convertWavToMp3,Utils::getInstance(),Utils::,"Utils:convertWavToMp3")
    }

private:
    static Utils* __instance;
    Utils(){};
    
};

#endif /* Utils_h */
