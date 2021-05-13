//
//  CrystalBallMatrixView.m
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import "CrystalBallMatrixView.h"
#import "YoYoPinXiaoLe-Swift.h"

@implementation CrystalBallMatrixView

-(id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame withGame:nil gameReumed:NO];
}

-(id)initWithFrame:(CGRect)frame withGame:(GameEntity*)Game gameReumed:(BOOL)resumed{
    self = [super initWithFrame:frame];
    if (self) {
        _ReductionManager = [[ReductionManager alloc] init];
        self.backgroundColor = [UIColor colorWithRed:(57.0f/255.0f) green:(57.0f/255.0f) blue:(57.0f/255.0f) alpha:1.0];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 3;
        self.layer.cornerRadius = 10.0;
        
        IsGameResumed = resumed;
        if(Game){
            _currentGame = Game;
        }else{
            MSize *size = [[MSize alloc] init] ;
            size.width = 7;
            size.height = 7;
            Graph *graph = [[Graph alloc] initWithSize:size];
            ScoreEntity *Score = [[ScoreEntity alloc] init];
            
            _currentGame = [[GameEntity alloc] init];
            
            _currentGame.graph = graph;
            _currentGame.score = Score;
            _currentGame.nextCellsToAdd = [NSMutableArray array];
        }
        
        levelManager = [[LevelManager alloc] initWithNumberOfLevels:3];
        levelManager.delegate = self;
        
        self.SelectedPath = [NSMutableArray array];
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)levelManager:(LevelManager *)lvlProvider LevelChanged:(LevelEntity *)newLevel{
    if(newLevel == [lvlProvider GetCurrentLevel]){
        return;
    }
    
    for(int i=0 ;i<newLevel.numberOfAddedCells;i++){
        if(i>=_currentGame.nextCellsToAdd.count){
            GraphCell *Gcell = [[GraphCell alloc] init];
            Gcell.color = [self getRandomColor];
            [_currentGame.nextCellsToAdd addObject:Gcell];
        }
    }
    [self addNextCellsToSuperView];
}

-(void)saveGame{
    [self persistGameToPermenantStore];
    [self saveGameToReductionManager];
}

-(void)saveGameToReductionManager{
    [_ReductionManager EnqueueGameInReductionList:_currentGame];
    if([_ReductionManager CanReduction]){
        _ReductionBtn.enabled = YES;
    }
}

-(void)persistGameToPermenantStore{
}

-(void)reductionLastMove{
    GameEntity *UndoneGame = [_ReductionManager ReductionLastMove];
    if(UndoneGame){
        [self reloadGame:UndoneGame];
        [self persistGameToPermenantStore];
        _ReductionBtn.enabled = NO;
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(newSuperview){
        if(IsGameResumed){
            [self reloadGame:_currentGame];
        }else{
            [self reloadNewGame];
        }
    }
}

-(void)reloadNewGame{
    if([_delegate respondsToSelector:@selector(resetNextAddedCells)]){
        [_delegate resetNextAddedCells];
    }
    [levelManager ResetLevel];
    [_ReductionManager ResetManager];
    _ReductionBtn.enabled = NO;
    [_currentGame.score ResetScore];
    [_currentGame.graph ResetGraph];
    [self updateScore];
    [self reloadWithSize:_currentGame.graph.size gameResumed:NO];
}

-(void)reloadGame:(GameEntity*)game{
    _currentGame = game;
    [self updateScore];
    
    [self reloadWithSize:_currentGame.graph.size gameResumed:YES];
}

//**********************MATRIX RELOAD WITH CELLS ***************************************************
-(void)reloadWithSize:(MSize*)size gameResumed:(BOOL)resumed{
    
    NSArray *subviews = [self subviews];
    for(UIView *subview in subviews){
        if(subview.tag>=1000)
            [subview removeFromSuperview];
    }
    self.frame = CGRectMake(0, 0, (CELL_SIZE*size.width)+20, (CELL_SIZE*size.height)+20);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        self.center = CGPointMake(160, 210);
    }else{
        self.center = CGPointMake(350, 250);
    }
    [self loadWithCellsGameResumed:resumed];
}

-(void)loadWithCellsGameResumed:(BOOL)Resumed{
    int TotalCellsCount = _currentGame.graph.size.width*_currentGame.graph.size.height;
    CGFloat AnimationDelay =0.0;
    int CurrentX = CELL_SIZE;
    CurrentX *= -1;
    CurrentX += 5;
    int CurrentY = 5;
    for(int i =0 ;i<TotalCellsCount;i++){
        if((i/_currentGame.graph.size.height)*_currentGame.graph.size.height != i){
            //if did not reach full height
            //increase Y
            CurrentY+=CELL_SIZE+2;
        }else{
            //if reached full height
            //Reset Y and increase X
            CurrentY = 5;
            CurrentX+=CELL_SIZE+2;
        }
        XZYoYoCellView *cell = [[XZYoYoCellView alloc] initWithFrame:CGRectMake(CurrentX, CurrentY, CELL_SIZE, CELL_SIZE)];
        cell.tag = i+1000;
        cell.delegate = self;
        
        GraphCell *graphCell = [_currentGame.graph getGraphCellWithIndex:i];
        [cell setStatusWithGraphCell:graphCell Animatation:CellAnimationTypeNone];
        cell.SetTouchable = NO;
        [self addSubview:cell];
        AnimationDelay += 0.1;
    }
    if(!Resumed){
        [self generateDisorderCellsAndAddToSuperView:NO];
        [self performSelector:@selector(addNewCells) withObject:nil afterDelay:0.5];
    }else{
        [self addNextCellsToSuperView];
    }
}

//顶部提示
- (void)showBannerWithMessage:(NSString*)msg withTitle:(NSString*)title{
    TopPromptView * view = [TopPromptView new];
    [view show];
}

-(GraphCellStatus)getRandomColor{
    int randomIndex = arc4random_uniform(5);
    if(randomIndex==0){
        return blue;
    }else if (randomIndex==1){
        return green;
    }else if (randomIndex==2){
        return red;
    }else if (randomIndex==3){
        return yellow;
    }else //if (randomIndex==4)
    {
        return orange;
    }
}

-(void)generateDisorderCellsAndAddToSuperView:(BOOL)addToSuperView{
    NSMutableArray *addedCells = [NSMutableArray array];
    for(int i=0 ;i<[levelManager GetCurrentLevel].numberOfAddedCells;i++){
        GraphCell *CopyGCell = [[GraphCell alloc] init];
        [addedCells addObject:CopyGCell];
        CopyGCell.color = [self getRandomColor];
    }
    
    _currentGame.nextCellsToAdd = addedCells;
    if(addToSuperView)
        [self addNextCellsToSuperView];
}
-(void)addNextCellsToSuperView{
    if([_delegate respondsToSelector:@selector(addNextCellsWithGraphCells:)]){
        [_delegate addNextCellsWithGraphCells:_currentGame.nextCellsToAdd];
    }
    
}

-(void)addNewCells{
    NSArray *unoccupiedCells = [_currentGame.graph getUnOccupiedCells];
    if(unoccupiedCells.count<[levelManager GetCurrentLevel].numberOfAddedCells){
        [self gameOver];
        return;
    }
    [DisorderUnOccupiManager generateDisorderUnOccupiedCellsIndexes:[levelManager GetCurrentLevel].numberOfAddedCells WithUnOccupiedCells:unoccupiedCells withCompletionBlock:^(NSArray* result){
        NSMutableArray *AddedCells = [NSMutableArray array];
        for(int i=0 ;i<[levelManager GetCurrentLevel].numberOfAddedCells;i++){
            GraphCell *AddedGCell = [self.currentGame.nextCellsToAdd objectAtIndex:i];
            GraphCell *LocalGCell = [self.currentGame.graph getGraphCellWithIndex:((NSNumber*)[result objectAtIndex:i]).intValue];
            LocalGCell.color = AddedGCell.color;
            XZYoYoCellView *LocalCell = [self getXZYoYoCellViewWithIndex:((NSNumber*)[result objectAtIndex:i]).intValue];
            [AddedCells addObject:LocalGCell];
            [LocalCell setStatusWithGraphCell:LocalGCell Animatation:CellAnimationTypeAdded withDelay:i withCompletionBlock:^(BOOL finished){
                int numberOfAddedCells = [levelManager GetCurrentLevel].numberOfAddedCells ;
                if(i==numberOfAddedCells-1) {
                    [self detectAndRemoveConnectedCellsAndUpdateScoreWithCompetionBlock:^(NSArray* detectedCells){
                        [self setUserInteractionEnabled:YES];
                        NSArray *unoccupiedCells = [self.currentGame.graph getUnOccupiedCells];
                        if(unoccupiedCells.count==0){
                            [self gameOver];
                            
                        }else{
                            [self generateDisorderCellsAndAddToSuperView:YES];
                            [self saveGame];
                        }
                    } withVerticesArray:AddedCells];
                }
            }];
        }
    }];
}

-(void)setScoreInScoreBoard:(NSInteger)score{
    _ScoreBoard.text = [NSString stringWithFormat:@"%ld",(long)score];
}

-(void)reportScoreToGameCenter{
    [XZGameCenterService saveHighScoreWithScore:_currentGame.score.score];
}

//******************HANDLE TOUCH EVENT************************************************************
-(void)xZYoYoCellViewTouched:(XZYoYoCellView *)touchedCell{
    if(touchedCell.IsOccupied==YES){
        if(_startCellIndex){
            //deselect prevoiusly selected Start Cell View
            GraphCell *LastSelectedStartGcell = [_currentGame.graph getGraphCellWithIndex:_startCellIndex.intValue];
            LastSelectedStartGcell.temporarilyUnoccupied = NO;
            
            XZYoYoCellView *LastSelectedStartXZYoYoCellView = [self getXZYoYoCellViewWithIndex:_startCellIndex.intValue];
            [LastSelectedStartXZYoYoCellView cellUnTouched];
        }
        if(_endCellIndex){
            //deselect prevoiusly selected End Cell View
            XZYoYoCellView *LastSelectedEndXZYoYoCellView = [self getXZYoYoCellViewWithIndex:_endCellIndex.intValue];
            [LastSelectedEndXZYoYoCellView cellUnTouched];
            [self unDrawPathWithPath:self.SelectedPath];
        }
        [_SelectedPath removeAllObjects];
        
        GraphCell *LastSelectedGcell = [self.currentGame.graph getGraphCellWithIndex:touchedCell.tag-1000];
        [touchedCell cellTouchedWithStatus:LastSelectedGcell.color];
        self.startCellIndex = [NSNumber numberWithInt:touchedCell.tag-1000] ;
        LastSelectedGcell.temporarilyUnoccupied = YES;
    }else{
        if(!_startCellIndex){
            return;
        }
        if(_endCellIndex){
            //deselect prevoiusly selected End Cell View
            XZYoYoCellView *LastSelectedEndXZYoYoCellView = [self getXZYoYoCellViewWithIndex:_endCellIndex.intValue];
            [LastSelectedEndXZYoYoCellView cellUnTouched];
            [self unDrawPathWithPath:self.SelectedPath];
        }
        self.endCellIndex = [NSNumber numberWithInt:touchedCell.tag-1000] ;
        [self.SelectedPath removeAllObjects];
        [self findFastesPathWithCompletionBlock:^(NSArray *path){
            [self.SelectedPath addObjectsFromArray:path];
            if(self.SelectedPath.count==0){
                [self showBannerWithMessage:@"Can't go there !" withTitle:@"Sorry"];
            }
            [self oKAction:nil];
        }];
    }
}

-(void)unDrawPathWithPath:(NSArray*)path{
    for(int i =1;i<path.count;i++){
        NSNumber *CellIndex = [path objectAtIndex:i];
        XZYoYoCellView *cell = [self getXZYoYoCellViewWithIndex:CellIndex.intValue];
        [cell removePathTraceImage];
    }
}

-(void)drawPathWithPath:(NSArray*)path{
    GraphCell *fromGCell = [_currentGame.graph getGraphCellWithIndex:((NSNumber*)[path objectAtIndex:0]).intValue];
    for(int i =1;i<path.count;i++){
        NSNumber *CellIndex = [path objectAtIndex:i];
        XZYoYoCellView *cell = [self getXZYoYoCellViewWithIndex:CellIndex.intValue];
        [cell setPathtTraceImageWithStatus:fromGCell.color];
    }
}

-(void)findFastesPathWithCompletionBlock:(FastestPathFinderBlock)block{
    [FastestPathFinder findFastestPathWithOccupiedCells:[_currentGame.graph getOcuupiedCells] withSize:_currentGame.graph.size withStart:self.startCellIndex WithEnd:self.endCellIndex WithCompletionBlock:block];
}

-(void)oKAction:(UIButton *)sender{
    if(self.SelectedPath.count==0 || !self.SelectedPath){
        [self setUserInteractionEnabled:YES];
        return;
    }
    [self setUserInteractionEnabled:NO];

    XZYoYoCellView *fromCell = [self getXZYoYoCellViewWithIndex:_startCellIndex.intValue];
    GraphCell *fromGCell = [_currentGame.graph getGraphCellWithIndex:_startCellIndex.intValue];
    fromGCell.temporarilyUnoccupied = NO;
    XZYoYoCellView *Tocell = [self getXZYoYoCellViewWithIndex:_endCellIndex.intValue];
    
    [self moveOccupiedCellFromIndex:self.startCellIndex.intValue toIndex:self.endCellIndex.intValue WithPath:self.SelectedPath];
    
    CompletionBlock block = ^(NSArray *detectedCells){
        if(detectedCells.count==0){
            [self addNewCells];
        }else{
            [self setUserInteractionEnabled:YES];
            [self saveGame];
        }
    };
    [self detectAndRemoveConnectedCellsAndUpdateScoreWithCompetionBlock:block withVerticesArray:[NSArray arrayWithObject:[_currentGame.graph getGraphCellWithIndex:_endCellIndex.intValue]]];
    _endCellIndex = nil;
    [Tocell cellUnTouched];
    _startCellIndex = nil;
    
    [fromCell cellUnTouched];
}

-(void)moveOccupiedCellFromIndex:(int)Fromindex toIndex:(int)toIndex WithPath:(NSArray*)path{
    XZYoYoCellView *fromCell = [self getXZYoYoCellViewWithIndex:Fromindex];
    XZYoYoCellView *toCell = [self getXZYoYoCellViewWithIndex:toIndex];

    GraphCell *FromGCell = [_currentGame.graph getGraphCellWithIndex:Fromindex];
    FromGCell.temporarilyUnoccupied = NO;
    GraphCell *toGCell = [_currentGame.graph getGraphCellWithIndex:toIndex];
    
    if(FromGCell.color!=unOccupied && toGCell.color==unOccupied){
        [_currentGame.graph ExchangeCellAtIndex:Fromindex WithCellAtIndex:toIndex];
    }
    
    UIColor *traceColor =nil;
    switch (FromGCell.color) {
        case red:
            traceColor = [UIColor redColor];
            break;
        case green:
            traceColor = [UIColor greenColor];
            break;
        case blue:
            traceColor = [UIColor blueColor];
            break;
            
        default:
            break;
    }
    [fromCell setStatusWithGraphCell:toGCell Animatation:CellAnimationTypeNone];
    [toCell setStatusWithGraphCell:FromGCell Animatation:CellAnimationTypeNone];
   
}

-(void)gameOver{
    [self reportScoreToGameCenter];
    XZAlertView * view = [[XZAlertView alloc] init];
    view.completion = ^{
        if([self.delegate respondsToSelector:@selector(crystalBallMatrixViewQuit:)]){
            [self.delegate crystalBallMatrixViewQuit:self];
        }
    };
    view.gameCompletion = ^{
        [self reloadNewGame];
    };

    [view show];
}

-(void)detectAndRemoveConnectedCellsAndUpdateScoreWithCompetionBlock:(CompletionBlock) block withVerticesArray:(NSArray*)vertices{
     [ConnectCellRowsManager getConnectedCellsWithGraph:_currentGame.graph withVertices:vertices withCompletionBlock:^(NSArray *result){
         // iterate on detected cells and remove them
         NSInteger numberOfCellsDetected = result.count;
         [self removeCells:result];
         //Update Score
         [self.currentGame.score ReportScoreWithNumberOfDetectedCells:numberOfCellsDetected];
         
         [self updateScore];
         
         //call completion block
         block(result);
    
    }];
}

-(void)removeCells:(NSArray*)cells{
    for(GraphCell *GCell in cells){
        GCell.color = unOccupied;
        int index = [_currentGame.graph getIndexOfGraphCell:GCell];
        XZYoYoCellView *cellView = [self getXZYoYoCellViewWithIndex:index];
        [cellView setStatusWithGraphCell:GCell Animatation:CellAnimationTypeRemoval];
    }
}

-(void)updateScore{
    [levelManager ReportScore:_currentGame.score.score];
    [self setScoreInScoreBoard:_currentGame.score.score];
    if([_delegate respondsToSelector:@selector(setProgress:withLevelNumber:)]){
        CGFloat Mod = _currentGame.score.score % (int)(LEVEL_RANGE);
        CGFloat progress = (CGFloat)(Mod/LEVEL_RANGE);
        if([levelManager isFinalLevel]){
            progress = 1.0f;
        }
        [_delegate setProgress:progress withLevelNumber:[levelManager GetCurrentLevel].LevelIndex];
    }
}

-(XZYoYoCellView*)getXZYoYoCellViewWithIndex:(int)index{
    return ((XZYoYoCellView*)[self viewWithTag:index+1000]);
}

@end
