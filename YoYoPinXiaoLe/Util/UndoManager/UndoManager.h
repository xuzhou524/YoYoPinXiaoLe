//
//  UndoManager.h
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "GameEntity.h"
@interface UndoManager : NSObject{
    GameEntity *previousGame;
    NSMutableArray *UndoGamesList;
}
-(void)EnqueueGameInUndoList:(GameEntity*)game;
-(GameEntity*)UndoLastMove;
-(BOOL)CanUndo;
-(void)ResetManager;
@end
