//
//  Utils.m
//  aam2_client
//
//  Created by JingFeng on 2018/6/22.
//
//

#import "Utils.h"
#import <AdSupport/ASIdentifierManager.h>
#include <sys/utsname.h>
static Utils * __instance;

@implementation Utils

+(id)getInstance{
    //线程锁
    @synchronized(self){
        if(__instance == nil){
            __instance = [[Utils alloc] init];
        }
    }
    return __instance;
}

-(NSString*) getDeviceId{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* deviceId = [defaults stringForKey: @"device_id"];
    
    if (deviceId == nil)
    {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
        {
            deviceId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
        else
        {
            deviceId = [[NSUUID UUID] UUIDString];
            
        }
        [defaults setObject:deviceId forKey: @"device_id"];
        [defaults synchronize];
    }
    
    return deviceId;
}

-(NSString*) getDeviceType{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* deviceType = [defaults stringForKey: @"device_type"];
    if(deviceType == nil){
        struct utsname systemInfo;
        uname(&systemInfo);
        deviceType = [NSString stringWithUTF8String:systemInfo.machine];
        [defaults setObject:deviceType forKey: @"deviceType"];
        [defaults synchronize];
    }
    return deviceType;
    
}


@end
