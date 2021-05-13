//
//  ReductionManager.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "GameEntity.h"
@interface ReductionManager : NSObject{
    GameEntity *previousGame;
    NSMutableArray *ReductionGamesList;
}
-(void)EnqueueGameInReductionList:(GameEntity*)game;
-(GameEntity*)ReductionLastMove;
-(BOOL)CanReduction;
-(void)ResetManager;
@end
