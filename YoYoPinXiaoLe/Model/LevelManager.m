//
//  LevelManager.m
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import "LevelManager.h"

@implementation LevelEntity

@end


@interface LevelManager ()
@property(nonatomic,retain)LevelEntity *currentLevel;
@property(nonatomic,retain)NSArray *Levels;
@end
@implementation LevelManager

-(id)initWithNumberOfLevels:(NSInteger)noOfLevels{
    self = [super init];
    if(self){
        NSMutableArray *levels = [NSMutableArray array];
        for (int i =0; i< noOfLevels; i++) {
            LevelEntity *level = [[LevelEntity alloc] init];
            level.LevelIndex = i+1;
            level.MaxScore = (i+1)*LEVEL_RANGE;
            level.MaxScore--;
            level.MinScore = (i)*LEVEL_RANGE;
            level.numberOfAddedCells = 3+i;
            if(i==noOfLevels-1){
                level.MaxScore = -1;
            }
            [levels addObject:level];
        }
        _Levels = [NSArray arrayWithArray:levels];
        _currentLevel = [_Levels objectAtIndex:0];
    }
    return self;
}

-(void)ResetLevel{
    _currentLevel = [_Levels objectAtIndex:0];
}

-(void)ReportScore:(NSInteger)score{
    LevelEntity *newLevel ;
    for(LevelEntity *level in _Levels){
        if(score>= level.MinScore && score<= level.MaxScore){
            newLevel = level;
        }else if(level.MaxScore==-1 && score>= level.MinScore){
            newLevel = level;
        }
    }
    if(newLevel!=_currentLevel && [_delegate respondsToSelector:@selector(levelManager:LevelChanged:)]){
        [_delegate levelManager:self LevelChanged:newLevel];
    }
    _currentLevel = newLevel;
}

-(LevelEntity*)GetCurrentLevel{
    return _currentLevel;
}

-(BOOL)isFinalLevel{
    return _currentLevel.MaxScore == -1;
}

@end
