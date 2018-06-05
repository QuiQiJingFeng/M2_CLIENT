//
//  Audio.m
//  aam2_client
//
//  Created by JingFeng on 2018/5/31.
//
//

#import "Audio.h"
#define COUNTDOWN 15
static Audio * __instance;

@implementation Audio

+(id)getInstance{
    //线程锁
    @synchronized(self){
        if(__instance == nil){
           __instance = [[Audio alloc] init];
        }
    }
    return __instance;
}
//开始录音
+(void) startRecordWithPath:(NSDictionary *)dict{
    NSString *path = [dict objectForKey:@"cpath"];
    NSURL *urlpath = [NSURL fileURLWithPath:path];
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    [Audio getInstance];
    __instance.__recorder = [[AVAudioRecorder alloc] initWithURL:urlpath settings:recordSetting error:nil];
    if (__instance.__recorder) {
        //启动这个设置,当录音的时候其他声音会禁止掉,比如正在进行的音乐
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        __instance.__recorder.meteringEnabled = YES;

        [__instance.__recorder prepareToRecord];
        //开始录音
        [__instance.__recorder record];
        //计时,当COUNTDOWN秒之后调用停止录音的方法
        ;
 
        [__instance performSelector:@selector(stopRecordInner) withObject:__instance afterDelay:COUNTDOWN];
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
 
}

-(void) stopRecordInner{
    [Audio stopRecord];
}
//停止录音
+(void) stopRecord{
    if ([__instance.__recorder isRecording]) {
        [__instance.__recorder stop];
    }else{
        return;
    }
}

//播放音频
+(void) playAudioWithPath:(NSDictionary *)dict{
    NSString *path = [dict objectForKey:@"cpath"];
    if ([__instance.__player isPlaying])
        return;
    NSUInteger count = [__instance.__player retainCount];
    if(count > 0){
        for (int i = 0; i < count; i++) {
            [__instance.__player release];
        }
    }
    __instance.__player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
     //播放的时候其他音乐会关闭(qq音乐)。同样当用户锁屏或者静音时也会随着静音。
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [__instance.__player play];
}

// 检查当前音频是否播放完毕
+(BOOL) isPlaying{
   return [[__instance __player] isPlaying];
}


@end
