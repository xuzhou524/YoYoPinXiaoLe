//
//  UndoManager.m
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import "UndoManager.h"

@implementation UndoManager

-(id)init{
    self = [super init];
    if(self){
        UndoGamesList = [NSMutableArray array];
    }
    return self;
}

-(void)EnqueueGameInUndoList:(GameEntity *)game{
    if(previousGame){
        [UndoGamesList removeAllObjects];
        [UndoGamesList addObject:previousGame];
    }
    previousGame = [game copy];
}

-(GameEntity*)UndoLastMove{
    GameEntity *unDoneGame = nil;
    if(UndoGamesList.count>0){
        unDoneGame = [UndoGamesList lastObject];
        [UndoGamesList removeLastObject];
        previousGame = [unDoneGame copy];
    }
    return [unDoneGame copy];
}

-(void)ResetManager{
    previousGame = nil;
    [UndoGamesList removeAllObjects];
    
}

-(BOOL)CanUndo{
    return UndoGamesList.count>0;
}

@end
