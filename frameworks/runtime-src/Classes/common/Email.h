//
//  Email.hpp
//  Email
//
//  Created by JingFeng on 2018/6/22.
//  Copyright © 2018年 JingFeng. All rights reserved.
//

#ifndef Email_hpp
#define Email_hpp
#include <stdio.h>
#include <string>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include<unistd.h>  

#include "cocos2d.h"
#include "PlatformSDK.h"
USING_NS_CC;
typedef int SOCKET;

#define SOCKET_ERROR -1

using namespace std;
class Email{
private:
    Email(){};
    void Send(SOCKET& s, string& data);
    
    void Recv(SOCKET& s, char* buf, int len);
    
    string Base64Encode(const string& src);
public:
    static Email* getInstance();
    /*
     string smtpServer = "smtp.163.com";
     string account = "gejinnian224@163.com";
     string password = "fhqydidxil1zql";
     string targetEmail = "gejinnian212@163.com";
     string content = "HELLO 这是一封测试邮件";
     */
    
    bool SendEmail(const string& smtpServer,int smtpPort, const string& username, const string& pw, const string& to,const string& title, const string& data);
    
    Value SendEmail(ValueVector vector);
    
    inline static void registerFunc(){
        REGISTER_PLATFORM(Email::SendEmail,Email::getInstance(),Email::,"Email:SendEmail")
    }
private:
    static Email* __instance;
};

#endif /* Email_hpp */
