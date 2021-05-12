//
//  PersistentStore.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "GameEntity.h"
#define LAST_GAME_KEY @"lastGame"
@interface PersistentStore : NSObject
+(void)persistGame:(GameEntity*)game;
+(GameEntity*)getLastGame;
@end
