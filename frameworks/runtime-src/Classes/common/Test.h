//
//  Test.hpp
//  cocosDemo
//
//  Created by JingFeng on 2018/6/27.
//
//

#ifndef Test_h
#define Test_h

#include <stdio.h>
#include "FYDC.h"

class Test{
private:
    static Test* __instance;
    Test(){};
public:
    static Test* getInstance();
    
    FValue invoke1(FValueVector vector);
    
    void registerFunc(){
        REG_OBJ_FUNC(Test::invoke1,Test::getInstance(),Test::,"Test::invoke1")
    }
};


#endif /* Test_h */
