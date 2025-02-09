#ifndef _CCB_CCLAYERCOLORLOADER_H_
#define _CCB_CCLAYERCOLORLOADER_H_

#include "editor-support/cocosbuilder/CCLayerLoader.h"

namespace cocosbuilder {

/* Forward declaration. */
class CCBReader;

class CC_DLL LayerColorLoader : public LayerLoader {
public:
    /**
     * @js NA
     * @lua NA
     */
    virtual ~LayerColorLoader() {};
    CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(LayerColorLoader, loader);

protected:
    CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(cocos2d::LayerColor);

    virtual void onHandlePropTypeColor3(cocos2d::Node * pNode, cocos2d::Node * pParent, const char * pPropertyName, cocos2d::Color3B pColor3B, CCBReader * ccbReader);
    virtual void onHandlePropTypeByte(cocos2d::Node * pNode, cocos2d::Node * pParent, const char * pPropertyName, unsigned char pByte, CCBReader * ccbReader);
    virtual void onHandlePropTypeBlendFunc(cocos2d::Node * pNode, cocos2d::Node * pParent, const char * pPropertyName, cocos2d::BlendFunc pBlendFunc, CCBReader * ccbReader);
};

}

#endif
