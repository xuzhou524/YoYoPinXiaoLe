//
//  ReductionManager.m
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import "ReductionManager.h"

@implementation ReductionManager

-(id)init{
    self = [super init];
    if(self){
        ReductionGamesList = [NSMutableArray array];
    }
    return self;
}

-(void)EnqueueGameInReductionList:(GameEntity *)game{
    if(previousGame){
        [ReductionGamesList removeAllObjects];
        [ReductionGamesList addObject:previousGame];
    }
    previousGame = [game copy];
}

-(GameEntity*)ReductionLastMove{
    GameEntity *unDoneGame = nil;
    if(ReductionGamesList.count>0){
        unDoneGame = [ReductionGamesList lastObject];
        [ReductionGamesList removeLastObject];
        previousGame = [unDoneGame copy];
    }
    return [unDoneGame copy];
}

-(void)ResetManager{
    previousGame = nil;
    [ReductionGamesList removeAllObjects];
    
}

-(BOOL)CanReduction{
    return ReductionGamesList.count>0;
}

@end
