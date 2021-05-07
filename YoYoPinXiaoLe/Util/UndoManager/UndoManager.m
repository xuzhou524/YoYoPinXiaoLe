//
//  UndoManager.m
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import "UndoManager.h"

@implementation UndoManager
-(id)init
{
    self = [super init];
    if(self)
    {
        UndoGamesList = [NSMutableArray array];
        //RedoGamesList = [NSMutableArray array];
    }
    return self;
}
-(void)EnqueueGameInUndoList:(GameEntity *)game
{
    if(previousGame)
    {
        [UndoGamesList removeAllObjects];
        [UndoGamesList addObject:previousGame];
    }
    previousGame = [game copy];
    /*[UndoGamesList removeAllObjects];
    [UndoGamesList addObject:[game copy]];*/
}
-(GameEntity*)UndoLastMove
{
    GameEntity *unDoneGame = nil;
    if(UndoGamesList.count>0)
    {
        
        
        
        unDoneGame = [UndoGamesList lastObject];
        [UndoGamesList removeLastObject];
        previousGame = [unDoneGame copy];
    }

    return [unDoneGame copy];
}
/*-(GameEntity*)RedoLastMove
{
    GameEntity *RedoneGame = nil;
    if(RedoGamesList.count>0)
    {
        RedoneGame = [RedoGamesList lastObject];
        [RedoGamesList removeLastObject];
        [UndoGamesList addObject:RedoneGame];
    }
    return [RedoneGame copy];
}*/
-(void)ResetManager
{
    previousGame = nil;
    [UndoGamesList removeAllObjects];
    
}
-(BOOL)CanUndo
{
    return UndoGamesList.count>0;
}
/*-(BOOL)CanRedo
{
    return RedoGamesList.count>0;
}*/
@end
