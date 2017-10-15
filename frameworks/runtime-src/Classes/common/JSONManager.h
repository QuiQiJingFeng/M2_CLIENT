//
//  JSONManager.hpp
//  client
//
//  Created by mu77 on 2017/7/18.
//
//

#ifndef JSONManager_hpp
#define JSONManager_hpp

#include "json/rapidjson.h"
#include "json/document.h"
#include "json/writer.h"
#include "json/stringbuffer.h"
#include "cocos2d.h"
/*这里继承自Ref，只是为了管理的方便，配合RefPtr<>使用简直是绝配(不用操心释放问题)就太棒了*/
class JSONManager :public cocos2d::Ref{
public:
    //解析JSON，解析之前会先释放之前解析好的数据
    void parseValueMapFromJSON(std::string contentStr);
    //获取已经解析好的Data
    cocos2d::ValueMap& getDataMap();
    cocos2d::ValueVector& getDataVector();
    JSONManager();
    ~JSONManager();
    
    void recurseSave(cocos2d::Value& currentMap, std::string key,rapidjson::Value & value);
    void recurseSave(cocos2d::Value& currentMap, int key,rapidjson::Value & value);
    void deleteDynamic();
private:
    static JSONManager* _only;
    std::vector<cocos2d::ValueMap*> _willDelete;
    std::vector<cocos2d::ValueVector*> _willDelete2;
    cocos2d::Value _data;
};
#endif /* JSONManager_hpp */
