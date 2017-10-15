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

class Utils {
    
public:
    //need full_path
    static bool unzipFile(std::string path,std::string outpath);
    static bool versionGreater(const std::string& version1, const std::string& version2);
    static long xxteaDecrypt(unsigned char* bytes,long size,char* xxteaSigin,char* xxteaKey);
};

#endif /* Utils_h */
