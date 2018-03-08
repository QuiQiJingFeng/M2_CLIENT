#include "AppDelegate.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"
#include "lua_custom_register.h"

 #define USE_AUDIO_ENGINE 1
// #define USE_SIMPLE_AUDIO_ENGINE 1

#if USE_AUDIO_ENGINE && USE_SIMPLE_AUDIO_ENGINE
#error "Don't use AudioEngine and SimpleAudioEngine at the same time. Please just select one in your game!"
#endif

#if USE_AUDIO_ENGINE
#include "audio/include/AudioEngine.h"
using namespace cocos2d::experimental;
#elif USE_SIMPLE_AUDIO_ENGINE
#include "audio/include/SimpleAudioEngine.h"
using namespace CocosDenshion;
#endif

#include "common/JSONManager.h"
#include "common/Utils.h"

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
#if USE_AUDIO_ENGINE
    AudioEngine::end();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::end();
#endif

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
    // set OpenGL context attributes: red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

// if you want to use the package manager to install more packages, 
// don't modify or remove this function
static int register_all_packages()
{
    return 0; //flag for packages manager
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // set default FPS
    Director::getInstance()->setAnimationInterval(1.0 / 60.0f);

    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);

    register_all_packages();
    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign("10cc4fdee2fcd047", strlen("10cc4fdee2fcd047"), "gclR3cu9", strlen("gclR3cu9"));
    
    //register custom function
    register_custom_function(L);
    
    
    //如果是IOS/ANDROID 第一次启动 需要解压缩文件
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    FileUtils::getInstance()->setXXTEAKeyAndSign("10cc4fdee2fcd047", "gclR3cu9");
    
    string path = FileUtils::getInstance()->getWritablePath();
    bool exsit = FileUtils::getInstance()->isFileExist(path + "project.manifest");
    bool decompress = false;
    if(!exsit){
        decompress = true;
    }else{
        //沙盒目录的版本文件
        string content = FileUtils::getInstance()->getStringFromFile(path + "project.manifest");
        JSONManager json;
        json.parseValueMapFromJSON(content);
        auto data = json.getDataMap();
        
        string version2 = data["version"].asString();
        //程序包中的版本文件
        content = FileUtils::getInstance()->getStringFromFile("package/project.manifest");
        json.parseValueMapFromJSON(content);
        data = json.getDataMap();
        string version1 = data["version"].asString();
        bool greater = Utils::versionGreater(version1,version2);
        //(在不删除app的情况下,从商店更新会出现这种情况)
        if(greater){
            decompress = true;
        }
    }

    if(decompress){
        FileUtils::getInstance()->removeDirectory(path + "src/");
        FileUtils::getInstance()->removeDirectory(path + "res/");
        //获取程序包中的版本文件
        string assets_info = FileUtils::getInstance()->getStringFromFile("package/project.manifest");
        JSONManager json;
        json.parseValueMapFromJSON(assets_info);
        auto data = json.getDataMap();
        auto assets = data["assets"].asValueMap();
        //解压ZIP包到沙盒目录
        for(auto iter = assets.begin();iter != assets.end();++iter){
            Utils::unzipFile("package/"+ iter->first, path);
        }
        
        FILE * p_fd = fopen((path + "project.manifest").c_str(), "wb");
        fwrite(assets_info.c_str(), assets_info.size(), 1, p_fd);
        fclose(p_fd);
    }
    FileUtils::getInstance()->addSearchPath(path + "src");
    FileUtils::getInstance()->addSearchPath(path + "res");
#endif
    
#if CC_TARGET_PLATFORM == CC_PLATFORM_WIN
    FileUtils::getInstance()->addSearchPath("../../src", true);
    FileUtils::getInstance()->addSearchPath("../../res", true);
#endif
    
#if CC_64BITS
    FileUtils::getInstance()->addSearchPath("src/64bit");
#endif
    FileUtils::getInstance()->addSearchPath("src");
    FileUtils::getInstance()->addSearchPath("res");

    engine->executeString("print = release_print");
    if (engine->executeScriptFile("main.lua"))
    {
        return false;
    }

    return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

#if USE_AUDIO_ENGINE
    AudioEngine::pauseAll();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
    SimpleAudioEngine::getInstance()->pauseAllEffects();
#endif
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

#if USE_AUDIO_ENGINE
    AudioEngine::resumeAll();
#elif USE_SIMPLE_AUDIO_ENGINE
    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
    SimpleAudioEngine::getInstance()->resumeAllEffects();
#endif
}
