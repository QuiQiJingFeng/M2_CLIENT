#ifndef __CCB_CCSEQUENCE_H__
#define __CCB_CCSEQUENCE_H__

#include <string>

#include "base/CCRef.h"
#include "editor-support/cocosbuilder/CCBSequenceProperty.h"

namespace cocosbuilder {

class CC_DLL CCBSequence : public cocos2d::Ref
{
public:
    CCBSequence();
    /**
     * @js NA
     * @lua NA
     */
    ~CCBSequence();
    float getDuration();
    void setDuration(float fDuration);
    
    CCBSequenceProperty* getCallbackChannel();
    void setCallbackChannel(CCBSequenceProperty* callbackChannel);

    CCBSequenceProperty* getSoundChannel();
    void setSoundChannel(CCBSequenceProperty* soundChannel);
    
    const char* getName();
    void setName(const char *pName);
    
    int getSequenceId();
    void setSequenceId(int nSequenceId);
    
    int getChainedSequenceId();
    void setChainedSequenceId(int nChainedSequenceId);
    
private:
    float _duration;
    std::string _name;
    int mSequenceId;
    int mChainedSequenceId;
    CCBSequenceProperty* mCallbackChannel;
    CCBSequenceProperty* mSoundChannel;
};


}


#endif // __CCB_CCSEQUENCE_H__
