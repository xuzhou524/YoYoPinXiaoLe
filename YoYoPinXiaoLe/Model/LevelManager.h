//
//  LevelManager.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>

#define LEVEL_RANGE 600.0f

@interface LevelEntity : NSObject
@property(nonatomic,assign)int LevelIndex;
@property(nonatomic,assign)int MaxScore;
@property(nonatomic,assign)int MinScore;
@property(nonatomic,assign)int numberOfAddedCells;
@end

@protocol LevelManagerDelegate;
@interface LevelManager : NSObject

@property(nonatomic,weak)id<LevelManagerDelegate> delegate;

-(id)initWithNumberOfLevels:(NSInteger)noOfLevels;

-(void)ReportScore:(NSInteger)score;

-(LevelEntity*)GetCurrentLevel;
-(void)ResetLevel;
-(BOOL)isFinalLevel;

@end


@protocol LevelManagerDelegate <NSObject>
-(void)levelManager:(LevelManager*)levelManager LevelChanged:(LevelEntity*)newLevel;
@end
