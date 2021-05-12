//
//  LevelProvider.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "LevelEntity.h"
#define LEVEL_RANGE 600.0f
@protocol LevelProviderDelegate;
@interface LevelProvider : NSObject

@property(nonatomic,weak)id<LevelProviderDelegate> delegate;

-(id)initWithNumberOfLevels:(NSInteger)noOfLevels;

-(void)ReportScore:(NSInteger)score;

-(LevelEntity*)GetCurrentLevel;
-(void)ResetLevel;
-(BOOL)isFinalLevel;

@end


@protocol LevelProviderDelegate <NSObject>
-(void)levelProvider:(LevelProvider*)levelProvider LevelChanged:(LevelEntity*)newLevel;
@end
