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
-(NSNumber*) recordBegin:(NSString*)path{
    NSURL *urlpath = [NSURL fileURLWithPath:path];
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2 iphone只有1个麦克风,选单声道就可以了
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量 暂时不需要特别高的品质 一般即可,这样可以节省传输的数据量
                                   [NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey,
                                   nil];
    NSError* error;
    self.__recorder = [[AVAudioRecorder alloc] initWithURL:urlpath settings:recordSetting error:&error];
    if(error != nil){
        NSLog(@"录音器初始化失败%@",error);
        return [NSNumber numberWithBool:NO];
    }
    if (self.__recorder) {
        //启动这个设置,当录音的时候其他声音会禁止掉,比如正在进行的音乐
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        self.__recorder.meteringEnabled = YES;
        
        [self.__recorder prepareToRecord];
        //开始录音
        [self.__recorder record];
        //计时,当COUNTDOWN秒之后调用停止录音的方法,设置最大为15s，其实游戏中是10s，避免游戏中出问题而录音无法关掉
        [self performSelector:@selector(stopRecord) withObject:self afterDelay:COUNTDOWN];
    }
    return [NSNumber numberWithBool:YES];
}

// 停止录音
-(NSNumber*) stopRecord{
    if ([self.__recorder isRecording]) {
        [self.__recorder stop];
    }
    return [NSNumber numberWithBool:YES];
}

// 播放音频 一次只能播放一个
-(NSNumber*) playAudioWithPath:(NSString *)path{
    if([self.__player isPlaying])
        return [NSNumber numberWithBool:NO];
    // 释放之前的播放器
    int count = [self.__player retainCount];
    if(count > 0){
        [self.__player release];
    }
    //创建新的播放器
    self.__player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    //播放的时候其他音乐会关闭(qq音乐)。同样当用户锁屏或者静音时也会随着静音。
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [self.__player play];
    return [NSNumber numberWithBool:YES];
}

// 停止正在播放的 声音
-(NSNumber*) stopAllAudio{
    if([self.__player isPlaying])
        [self.__player stop];
    return [NSNumber numberWithBool:YES];
}

-(NSNumber*) isPlayingAudio{
    if([self.__player isPlaying])
        return [NSNumber numberWithBool:YES];
   return [NSNumber numberWithBool:NO];
}

@end
