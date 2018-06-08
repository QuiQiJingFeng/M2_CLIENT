//
//  Audio.h
//  aam2_client
//
//  Created by JingFeng on 2018/5/31.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Audio : NSObject

@property (nonatomic, strong) AVAudioRecorder * __recorder;//录音器
@property (nonatomic, strong) AVAudioPlayer * __player; //播放器

+(id)getInstance;

/*
 开始录音
 @path 录音的存储路径
 @return BOOL
 */
-(NSNumber*) recordBegin:(NSString*)path;

/*
 停止录音
 @return BOOL
 */
-(NSNumber*) stopRecord;

/*
 播放音频
 */
-(NSNumber*) playAudioWithPath:(NSString *)path;

/*
 停止正在播放的声音
 */
-(NSNumber*) stopAllAudio;

/*
 当前是否正在播放声音
 */
-(NSNumber*) isPlayingAudio;
@end

