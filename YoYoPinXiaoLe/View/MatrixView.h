//
//  MatrixView.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "MSize.h"
#import "XZYoYoCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "FastestPathFinder.h"
#import "Graph.h"
#import "DisorderUnOccupiManager.h"
#import <GameKit/GameKit.h>
#import "GameEntity.h"
#import "ConnectCellRowsManager.h"
#import "ReductionManager.h"
#import "LevelProvider.h"

@protocol MatrixViewDelegate;
typedef void (^CompletionBlock)(NSArray* detectedCells);
typedef void (^AnimationCompletionBlock)(void);
typedef void(^ReductionBlock)(NSArray* lastAddedCells,NSArray *lastRemovedCells,NSNumber *lastStartCellIndex,NSNumber *lastEndCellIndex);
@interface MatrixView : UIView<XZYoYoCellViewDelegate,UIAlertViewDelegate,LevelProviderDelegate>{
    ReductionBlock reductionBlock;
    BOOL IsGameResumed;
    LevelProvider *levelProvider;
    ReductionManager *_ReductionManager;
}
//UI Controls
@property(nonatomic,retain)UIButton *ReductionBtn;
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
-(void)reductionLastMove;

@end
@protocol MatrixViewDelegate <NSObject>

-(void)MatrixViewQuit:(MatrixView*)matrixView;
-(void)AddNextCellsWithGraphCells:(NSArray*)GCells;
-(void)setProgress:(CGFloat)progress withLevelNumber:(int)levelNo;
-(void)ResetNextAddedCells;
@end
