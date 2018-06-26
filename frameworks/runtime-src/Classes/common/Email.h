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
    
    
public:
    static Email* getInstance();
    /*
     string smtpServer = "smtp.163.com";
     int smptPort = 25;
     string username = "gejinnian224@163.com";//网易邮箱(如果是新注册的邮箱不能填写@163.com,老邮箱必须填写)
     string pw = "fhqydidxil1zql";      //网易老邮箱直接用邮箱密码即可,新邮箱必须设置客户端授权码
     string to = "gejinnian212@163.com";
     string title = "邮件标题";
     string content = "HELLO 这是一封测试邮件";
     */
    
    bool SendEmail(const string& smtpServer,int smtpPort, const string& username, const string& pw, const string& to,const string& title, const string& data);
    
    Value SendEmail(ValueVector vector);

    string Base64Encode(const string& src);

    Value Base64Encode(ValueVector vector);
    
    /*
     读取所有邮件的标题
     */
    string ReadAllEmailTitle(const string& imapServer, int port, const string& username, const string& passwd);

    Value ReadAllEmailTitle(ValueVector vector);
    inline static void registerFunc(){
        REGISTER_PLATFORM(Email::SendEmail,Email::getInstance(),Email::,"Email:SendEmail")
        REGISTER_PLATFORM(Email::Base64Encode,Email::getInstance(),Email::,"Email:Base64Encode")
        REGISTER_PLATFORM(Email::ReadAllEmailTitle,Email::getInstance(),Email::,"Email:ReadAllEmailTitle")
    }
private:
    static Email* __instance;
};

#endif /* Email_hpp */
