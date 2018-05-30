//
//  TestLuaOC.h
//  aam2_client
//
//  Created by JingFeng on 2017/10/7.
//
//

#import <Foundation/Foundation.h>

@interface TestLuaOC : NSObject

+(void) staticFunc:(NSDictionary*) dic;
+(void) callBackWithFuncID:(int) funcId andParams:(NSDictionary*) dic;
@end
