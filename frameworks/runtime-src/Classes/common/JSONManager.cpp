//
//  JSONManager.cpp
//  client
//
//  Created by mu77 on 2017/7/18.
//
//

#include "JSONManager.h"

USING_NS_CC;
using namespace std;

JSONManager::JSONManager()
{
    
}
JSONManager::~JSONManager()
{
    deleteDynamic();
}
//删除所有动态开辟的空间
void JSONManager::deleteDynamic()
{
    for (auto item:_willDelete) {
        delete item;
    }
    
    _willDelete.clear();
    
    for (auto item:_willDelete2) {
        delete item;
    }
    
    _willDelete2.clear();
    
    if(_data.getType() == Value::Type::MAP)
    {
        _data.asValueMap().clear();
    }
    
    if(_data.getType() == Value::Type::VECTOR)
    {
        _data.asValueVector().clear();
    }
}
//获取解析好的数据
ValueMap& JSONManager::getDataMap()
{
    return _data.asValueMap();
}

//获取解析好的数据
ValueVector& JSONManager::getDataVector()
{
    return _data.asValueVector();
}

//开始解析
void JSONManager::parseValueMapFromJSON(string contentStr)
{
    deleteDynamic();
    
    rapidjson::Document doc;
    doc.Parse<rapidjson::kParseDefaultFlags>(contentStr.c_str());
    if(doc.HasParseError())
    {
        //log("GetParseError%u\n", doc.GetParseError());
    }
    
    CCASSERT(doc.IsObject() || doc.IsArray(), "doc Must be object or array");
    
    if( doc.IsObject() ) {
        _data = ValueMap();
        auto root = doc.GetObject();
        for(auto iter = root.begin(); iter != root.end(); ++iter) {
            auto key = (iter->name).GetString();
            rapidjson::Value & value = iter->value;
            recurseSave(_data,key,value);
        }
    }else if(doc.IsArray()) {
        _data = ValueVector();
        auto root = doc.GetArray();
        for(rapidjson::SizeType idx = 0; idx < root.Size(); idx++) {
            rapidjson::Value & value = root[idx];
            recurseSave(_data,idx,value);
        }
    }
}
//递归简历数组方法，和下面的方法相互递归掉用
void JSONManager::recurseSave(Value& currentVector, int key,rapidjson::Value & value)
{
    if (value.IsArray()) {
        auto newVector = new ValueVector();
        Value newValue(*(newVector));
        
        _willDelete2.push_back(newVector);
        
        currentVector.asValueVector().push_back(newValue);
        
        int idx = 0;
        for (auto iter = value.Begin(); iter!=value.End(); ++iter) {
            
            recurseSave(currentVector.asValueVector()[key], idx, value[idx]);
            idx++;
        }
    }
    else if (value.IsObject())
    {
        auto newMap = new ValueMap();
        Value newValue(*(newMap));
        
        _willDelete.push_back(newMap);
        
        currentVector.asValueVector().push_back(newValue);
        
        for (auto iter = value.MemberBegin(); iter!=value.MemberEnd(); ++iter) {
            auto key2 = (iter->name).GetString();
            recurseSave(currentVector.asValueVector()[key], key2, iter->value);
        }
    }
    else if (value.IsInt())
    {
        auto tmp = Value(value.GetInt());
        currentVector.asValueVector().push_back(tmp);
        
        //log("%d 已添加到数组.... parent -%p",key,&currentVector);
    }
    else if (value.IsDouble())
    {
        auto tmp = Value(value.GetDouble());
        currentVector.asValueVector().push_back(tmp);
        //log("%d 已添加到数组.... parent -%p",key,&currentVector);
    }
    else if (value.IsBool()){
        auto tmp = Value(value.GetBool());
        currentVector.asValueVector().push_back(tmp);
        //log("%d 已添加到数组.... parent -%p",key,&currentVector);
    }
    else if (value.IsString())
    {
        auto tmp = Value(value.GetString());
        currentVector.asValueVector().push_back(tmp);
        //log("%d 已添加到数组.... parent -%p",key,&currentVector);
    }
    
}

void JSONManager:: recurseSave(Value& currentMap,string key,rapidjson::Value & value)
{
    
    if (value.IsArray()) {
        auto newVector = new ValueVector();
        Value newValue(*(newVector));
        //记录动态开辟的空间，留到以后删除用
        _willDelete2.push_back(newVector);
        
        currentMap.asValueMap()[key] = newValue;
        int idx = 0;
        for (auto iter = value.Begin(); iter!=value.End(); ++iter) {
            recurseSave(currentMap.asValueMap()[key], idx, value[idx]);
            idx++;
        }
    }
    else if (value.IsObject())
    {
        auto newMap = new ValueMap();
        Value newValue(*(newMap));
        
        _willDelete.push_back(newMap);
        
        currentMap.asValueMap()[key] = newValue;
        
        for (auto iter = value.MemberBegin(); iter!=value.MemberEnd(); ++iter) {
            auto key2 = (iter->name).GetString();
            recurseSave(currentMap.asValueMap()[key], key2, iter->value);
        }
    }
    else if (value.IsInt())
    {
        auto tmp = Value(value.GetInt());
        currentMap.asValueMap()[key] = tmp;
        //log("%s 已添加到数组.... parent -%p",key.c_str(),&currentMap);
    }
    else if (value.IsDouble())
    {
        auto tmp = Value(value.GetDouble());
        currentMap.asValueMap()[key] = tmp;
        //log("%s 已添加到数组.... parent -%p",key.c_str(),&currentMap);
    }
    else if (value.IsBool()){
        auto tmp = Value(value.GetBool());
        currentMap.asValueMap()[key] = tmp;
        //log("%s 已添加到数组.... parent -%p",key.c_str(),&currentMap);
    }
    else if (value.IsString())
    {
        auto tmp = Value(value.GetString());
        currentMap.asValueMap()[key] = tmp;
        //log("%s 已添加到数组.... parent -%p",key.c_str(),&currentMap);
    }
}
