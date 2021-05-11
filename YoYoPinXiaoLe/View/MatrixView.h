//
//  MatrixView.h
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "MSize.h"
#import "CellView.h"
#import <QuartzCore/QuartzCore.h>
#import "FastestPathFinder.h"
#import "Graph.h"
#import "RandomUnOccupiedCellsGenerator.h"
#import <GameKit/GameKit.h>
#import "GameEntity.h"
#import "PersistentStore.h"
#import "ConnectedCellRowsDetector.h"
#import "SIAlertView.h"
#import "UndoManager.h"
#import "LevelProvider.h"

@protocol MatrixViewDelegate;
typedef void (^CompletionBlock)(NSArray* detectedCells);
typedef void (^AnimationCompletionBlock)(void);
typedef void(^UndoBlock)(NSArray* lastAddedCells,NSArray *lastRemovedCells,NSNumber *lastStartCellIndex,NSNumber *lastEndCellIndex);
@interface MatrixView : UIView<CellViewDelegate,UIAlertViewDelegate,LevelProviderDelegate>{
    UndoBlock undoBlock;
    BOOL IsGameResumed;
    LevelProvider *levelProvider;
    UndoManager *_UndoManager;
}
//UI Controls
@property(nonatomic,retain)UIButton *UndoBtn;
@property(nonatomic,retain)UILabel *ScoreBoard;
@property(nonatomic,strong)GameEntity *currentGame;

//Status Variables
@property(nonatomic,assign)id<MatrixViewDelegate> delegate;
@property(nonatomic,retain)NSMutableArray *SelectedPath;
@property(nonatomic,retain) NSNumber *startCellIndex;
@property(nonatomic,retain) NSNumber *endCellIndex;

-(id)initWithFrame:(CGRect)frame withGame:(GameEntity*)Game gameReumed:(BOOL)resumed;

-(void)ReloadNewGame;
-(void)ReloadGame:(GameEntity*)game;
-(void)saveGame;
-(void)undoLastMove;

@end
@protocol MatrixViewDelegate <NSObject>

-(void)MatrixViewQuit:(MatrixView*)matrixView;
-(void)AddNextCellsWithGraphCells:(NSArray*)GCells;
-(void)setProgress:(CGFloat)progress withLevelNumber:(int)levelNo;
-(void)ResetNextAddedCells;
@end
