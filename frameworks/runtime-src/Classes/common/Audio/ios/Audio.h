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
+(void) startRecordWithPath:(NSDictionary *)dict;
+(void) stopRecord;
-(void) stopRecordInner;
+(void) playAudioWithPath:(NSDictionary *)dict;
+(BOOL) isPlaying;
@end

