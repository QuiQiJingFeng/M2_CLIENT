//
//  Email.cpp
//  Email
//
//  Created by JingFeng on 2018/6/22.
//  Copyright © 2018年 JingFeng. All rights reserved.
//

#include "Email.h"

Email* Email::__instance = nullptr;

Email* Email::getInstance(){
    if(__instance == nullptr){
        __instance = new Email();
    }
    return __instance;
}

//author: Zero

//facade of function send()
void Email::Send(SOCKET& s, string& data) {
    if( send(s, data.c_str(), data.length(), 0) == SOCKET_ERROR ) {
        printf("FYD:EMAIL SEND DATA ERROR, DATA =\n %s\n",data.c_str());
    }
}

//facade of function recv()
void Email::Recv(SOCKET& s, char* buf, int len) {
    memset(buf, 0, len);
    if( recv(s, buf, len, 0) == SOCKET_ERROR ) {
        printf("FYD:EMAIL RECEIVE DATA ERROR\n");
    }
}

string Email::Base64Encode(const string& src) {
    int i, j;
    long srcLen = src.length();
    string dst(srcLen / 3 * 4 + 4, 0);
    for(i = 0, j= 0; i <=srcLen - 3; i+=3, j+=4) {
        dst[j] = (src[i] & 0xFC) >> 2;
        dst[j+1] = ((src[i] & 0x03) << 4) + ((src[i+1] & 0xF0) >> 4);
        dst[j+2] = ((src[i+1] & 0x0F) << 2) + ((src[i+2] & 0xC0) >> 6);
        dst[j+3] = src[i+2] & 0x3F;
    }
    if( srcLen % 3 == 1 ) {
        dst[j] = (src[i] & 0xFC) >> 2;
        dst[j+1] = ((src[i] & 0x03) << 4);
        dst[j+2] = 64;
        dst[j+3] = 64;
        j += 4;
    }
    else if( srcLen % 3 == 2 ) {
        dst[j] = (src[i] & 0xFC) >> 2;
        dst[j+1] = ((src[i] & 0x03) << 4) + ((src[i+1] & 0xF0) >> 4);
        dst[j+2] = ((src[i+1] & 0x0F) << 2);
        dst[j+3] = 64;
        j+=4;
    }
    
    static unsigned char *base64 = (unsigned char*)("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=");
    for(i = 0; i < j; ++i) {    //map 6 bit value to base64 ASCII character
        dst[i] = base64[(int)dst[i]];
    }
    
    return dst;
}

bool Email::SendEmail(const string& smtpServer,int smtpPort, const string& username, const string& pw, const string& to,const string& title, const string& data) {
    hostent *ph = gethostbyname(smtpServer.c_str());
    if( ph == NULL ) {
        printf("FYD EMAIL SMTP HOST ERROR\n");
        return false;
    }

    sockaddr_in sin;
    memset(&sin, 0, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_port = htons(smtpPort);    //port of SMTP
    memcpy(&sin.sin_addr.s_addr,ph->h_addr_list[0], ph->h_length);
    
    //connect to the mail server
    SOCKET s = socket(PF_INET, SOCK_STREAM, 0);
    if( connect(s, (sockaddr*)&sin, sizeof(sin)) ) {
        printf("FYD EMAIL FAILED TO CONNECT MAIL SERVER\n");
        return false;
    }
    
    //
    char recvBuffer[1024];
    Recv(s, recvBuffer, sizeof(recvBuffer));    //wait for greeting message
    string info = "HELO " + smtpServer + "\r\n";
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));    //should recv "250 OK"
    
    info = "auth login\r\n";
    //start to log in
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));    //should recv "334 username:"(This is the decode message)
    info = Base64Encode(username) + "\r\n";
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));
    if( string(recvBuffer).substr(0, 3) != "334" ) {
        printf("FYD EMAIL USERNAME ERROR=%s\n",recvBuffer);
        return false;
    }
    info = Base64Encode(pw) + "\r\n";
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));
    if( string(recvBuffer).substr(0, 3) != "235") {
        printf("FYD EMAIL ERROR: PASSWORD ERROR=%s\n",recvBuffer);
        return false;
    }
    info = "mail from:<" + username + ">\r\n";
    //Set sender
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));    //should recv "250 Mail OK"
    
    info = "rcpt to:<" + to + ">\r\n";
    //set receiver
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));    //should recv "250 Mail OK"
    
    info = "data\r\n";
    //send data
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));    //should recv "354 End data with <CR><LF>.<CR><LF>"
    info = "to:" + to + "\r\n" + "subject:"+title+"\r\n\r\n" + data + "\r\n.\r\n";
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));
    
    info = "quit\r\n";
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));
    
    close(s);
    return true;
}

string Email::ReadAllEmailTitle(const string& imapServer, int port, const string& username, const string& passwd){
    hostent *ph = gethostbyname(imapServer.c_str());
    if( ph == NULL ) {
        printf("FYD EMAIL IMAP HOST ERROR\n");
        return "";
    }
    sockaddr_in sin;
    memset(&sin, 0, sizeof(sin));
    sin.sin_family = AF_INET;
    sin.sin_port = htons(port);    //port of IMAP
    memcpy(&sin.sin_addr.s_addr,ph->h_addr_list[0], ph->h_length);
    
    //connect to the mail server
    SOCKET s = socket(PF_INET, SOCK_STREAM, 0);
    if( connect(s, (sockaddr*)&sin, sizeof(sin)) ) {
        printf("FYD EMAIL FAILED TO CONNECT MAIL SERVER\n");
        return "";
    }
    
    char recvBuffer[1024*1024];
    Recv(s, recvBuffer, sizeof(recvBuffer));    //wait for greeting message
    string info = string("A01 LOGIN ") + username + " " + passwd+"\n";
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));
    if( string(recvBuffer).substr(0, 6) != "A01 OK" ) {
        printf("FYD EMAIL LOGIN ERROR\n");
        return "";
    }
    info = "A02 SELECT INBOX\n";
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));
    
    info = "A03 FETCH 1:* body[header.fields (\"subject\")]\n";
    Send(s, info);
    Recv(s, recvBuffer, sizeof(recvBuffer));
    return string(recvBuffer);
}

FValue Email::ReadAllEmailTitle(FValueVector vector)
{
    string imapServer = vector[0].asString();
    int port = vector[1].asInt();
    string username = vector[2].asString();
    string password = vector[3].asString();
    string str = ReadAllEmailTitle(imapServer,port,username,password);
    return FValue(str);
}

FValue Email::SendEmail(FValueVector vector)
{
    string smtpServer = vector[0].asString();
    int smtpPort = vector[1].asInt();
    string account = vector[2].asString();
    string password = vector[3].asString();
    string targetEmail = vector[4].asString();
    string title = vector[5].asString();
    string content = vector[6].asString();
    bool success = SendEmail(smtpServer,smtpPort,account,password,targetEmail,title,content);
    return FValue(success);
}


FValue Email::Base64Encode(FValueVector vector)
{
    string str = vector[0].asString();
    return FValue(str);
}



