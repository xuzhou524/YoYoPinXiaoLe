//
//  CrystalBallMatrixView.h
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
#import "LevelManager.h"

@protocol CrystalBallMatrixViewDelegate;
typedef void (^CompletionBlock)(NSArray* detectedCells);
typedef void (^AnimationCompletionBlock)(void);
typedef void(^ReductionBlock)(NSArray* lastAddedCells,NSArray *lastRemovedCells,NSNumber *lastStartCellIndex,NSNumber *lastEndCellIndex);
@interface CrystalBallMatrixView : UIView<XZYoYoCellViewDelegate,UIAlertViewDelegate,LevelManagerDelegate>{
    ReductionBlock reductionBlock;
    BOOL IsGameResumed;
    LevelManager *levelManager;
    ReductionManager *_ReductionManager;
}
//UI Controls
@property(nonatomic,retain)UIButton *ReductionBtn;
@property(nonatomic,retain)UILabel *ScoreBoard;
@property(nonatomic,strong)GameEntity *currentGame;

//Status Variables
@property(nonatomic,assign)id<CrystalBallMatrixViewDelegate> delegate;
@property(nonatomic,retain)NSMutableArray *SelectedPath;
@property(nonatomic,retain) NSNumber *startCellIndex;
@property(nonatomic,retain) NSNumber *endCellIndex;

-(id)initWithFrame:(CGRect)frame withGame:(GameEntity*)Game gameReumed:(BOOL)resumed;

-(void)reloadNewGame;
-(void)reloadGame:(GameEntity*)game;
-(void)saveGame;
-(void)reductionLastMove;

@end
@protocol CrystalBallMatrixViewDelegate <NSObject>

-(void)crystalBallMatrixViewQuit:(CrystalBallMatrixView*)matrixView;
-(void)addNextCellsWithGraphCells:(NSArray*)GCells;
-(void)setProgress:(CGFloat)progress withLevelNumber:(int)levelNo;
-(void)resetNextAddedCells;
@end
