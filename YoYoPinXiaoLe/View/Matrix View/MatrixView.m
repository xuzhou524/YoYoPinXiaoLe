//
//  MatrixView.m
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import "MatrixView.h"
#import "YoYoPinXiaoLe-Swift.h"

@implementation MatrixView

-(id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame withGame:nil gameReumed:NO];
}

-(id)initWithFrame:(CGRect)frame withGame:(GameEntity*)Game gameReumed:(BOOL)resumed{
    self = [super initWithFrame:frame];
    if (self) {
        _UndoManager = [[UndoManager alloc] init];
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
        
        levelProvider = [[LevelProvider alloc] initWithNumberOfLevels:3];
        levelProvider.delegate = self;
        
        self.SelectedPath = [NSMutableArray array];
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)levelProvider:(LevelProvider *)lvlProvider LevelChanged:(LevelEntity *)newLevel{
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
    [self AddNextCellsToSuperView];
}

-(void)saveGame{
    [self PersistGameToPermenantStore];
    [self SaveGameToUndoManager];
}

-(void)SaveGameToUndoManager{
    [_UndoManager EnqueueGameInUndoList:_currentGame];
    if([_UndoManager CanUndo]){
        _UndoBtn.enabled = YES;
    }
}

-(void)PersistGameToPermenantStore{
    [PersistentStore persistGame:_currentGame];
}

-(void)undoLastMove{
    GameEntity *UndoneGame = [_UndoManager UndoLastMove];
    if(UndoneGame){
        [self ReloadGame:UndoneGame];
        [self PersistGameToPermenantStore];
        _UndoBtn.enabled = NO;
    }
}

-(void)ResetUndo{
   if(_UndoManager){
       [_UndoManager ResetManager];
       _UndoBtn.enabled = NO;
   }
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(newSuperview){
        if(IsGameResumed){
            [self ReloadGame:_currentGame];
        }else{
            [self ReloadNewGame];
        }
    }
}

-(void)ReloadNewGame{
    if([_delegate respondsToSelector:@selector(ResetNextAddedCells)]){
        [_delegate ResetNextAddedCells];
    }
    [levelProvider ResetLevel];
    [_UndoManager ResetManager];
    _UndoBtn.enabled = NO;
    [_currentGame.score ResetScore];
    [_currentGame.graph ResetGraph];
    [self UpdateScore];
    [self ReloadWithSize:_currentGame.graph.size gameResumed:NO];
}

-(void)ReloadGame:(GameEntity*)game{
    _currentGame = game;
    [self UpdateScore];
    
    [self ReloadWithSize:_currentGame.graph.size gameResumed:YES];
}

//**********************MATRIX RELOAD WITH CELLS ***************************************************
-(void)ReloadWithSize:(MSize*)size gameResumed:(BOOL)resumed{
    
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
    [self LoadWithCellsGameResumed:resumed];
}

-(void)LoadWithCellsGameResumed:(BOOL)Resumed{
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
        CellView *cell = [[CellView alloc] initWithFrame:CGRectMake(CurrentX, CurrentY, CELL_SIZE, CELL_SIZE)];
        cell.tag = i+1000;
        cell.delegate = self;
        
        GraphCell *graphCell = [_currentGame.graph getGraphCellWithIndex:i];
        [cell SetStatusWithGraphCell:graphCell Animatation:CellAnimationTypeNone];
        cell.SetTouchable = NO;
        [self addSubview:cell];
        AnimationDelay += 0.1;
    }
    if(!Resumed){
        [self GenerateRandomCellsAndAddToSuperView:NO];
        [self performSelector:@selector(AddNewCells) withObject:nil afterDelay:0.5];
    }else{
        [self AddNextCellsToSuperView];
    }
}

- (void) showBannerWithMessage:(NSString*)msg withTitle:(NSString*)title{
    [TSMessage showNotificationWithTitle:title
                                subtitle:msg
                                    type:TSMessageNotificationTypeError];
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

-(void)GenerateRandomCellsAndAddToSuperView:(BOOL)addToSuperView{
    NSMutableArray *addedCells = [NSMutableArray array];
    for(int i=0 ;i<[levelProvider GetCurrentLevel].numberOfAddedCells;i++){
        GraphCell *CopyGCell = [[GraphCell alloc] init];
        [addedCells addObject:CopyGCell];
       /* int randomIndex = arc4random_uniform(5);
        
        if(randomIndex==0)
        {
            CopyGCell.color = blue;
            
        }else if (randomIndex==1)
        {
            CopyGCell.color = green;
            
        }else if (randomIndex==2)
        {
            CopyGCell.color = red;
            
        }else if (randomIndex==3)
        {
            CopyGCell.color = yellow;
            
        }else if (randomIndex==4)
        {
            CopyGCell.color = orange;
        }*/
        CopyGCell.color = [self getRandomColor];
    }
    
    _currentGame.nextCellsToAdd = addedCells;
    if(addToSuperView)
        [self AddNextCellsToSuperView];
}
-(void)AddNextCellsToSuperView{
    if([_delegate respondsToSelector:@selector(AddNextCellsWithGraphCells:)]){
        [_delegate AddNextCellsWithGraphCells:_currentGame.nextCellsToAdd];
    }
    
}

-(void)AddNewCells{
    NSArray *unoccupiedCells = [_currentGame.graph getUnOccupiedCells];
    if(unoccupiedCells.count<[levelProvider GetCurrentLevel].numberOfAddedCells){
        [self GameOver];
        return;
    }
    [RandomUnOccupiedCellsGenerator GenerateRandomUnOccupiedCellsIndexes:[levelProvider GetCurrentLevel].numberOfAddedCells WithUnOccupiedCells:unoccupiedCells withCompletionBlock:^(NSArray* result){
        NSMutableArray *AddedCells = [NSMutableArray array];
        for(int i=0 ;i<[levelProvider GetCurrentLevel].numberOfAddedCells;i++){
            GraphCell *AddedGCell = [_currentGame.nextCellsToAdd objectAtIndex:i];
            GraphCell *LocalGCell = [_currentGame.graph getGraphCellWithIndex:((NSNumber*)[result objectAtIndex:i]).intValue];
            LocalGCell.color = AddedGCell.color;
            CellView *LocalCell = [self getCellViewWithIndex:((NSNumber*)[result objectAtIndex:i]).intValue];
            [AddedCells addObject:LocalGCell];
            [LocalCell SetStatusWithGraphCell:LocalGCell Animatation:CellAnimationTypeAdded withDelay:i withCompletionBlock:^(BOOL finished){
                int numberOfAddedCells = [levelProvider GetCurrentLevel].numberOfAddedCells ;
                if(i==numberOfAddedCells-1) {
                    [self DetectAndRemoveConnectedCellsAndUpdateScoreWithCompetionBlock:^(NSArray* detectedCells){
                        [self setUserInteractionEnabled:YES];
                        NSArray *unoccupiedCells = [_currentGame.graph getUnOccupiedCells];
                        if(unoccupiedCells.count==0){
                            [self GameOver];
                            
                        }else{
                            [self GenerateRandomCellsAndAddToSuperView:YES];
                            [self saveGame];
                        }
                    } withVerticesArray:AddedCells];
                }
            }];
        }
    }];
}

-(void)SetScoreInScoreBoard:(int)score{
    _ScoreBoard.text = [NSString stringWithFormat:@"%d",score];
}

-(void)ReportScoreToGameCenter{
    [XZGameCenterService saveHighScoreWithScore:_currentGame.score.score];
}

//******************HANDLE TOUCH EVENT************************************************************
-(void)CellViewTouched:(CellView *)touchedCell{
    if(touchedCell.IsOccupied==YES){
        if(_startCellIndex){
            //deselect prevoiusly selected Start Cell View
            GraphCell *LastSelectedStartGcell = [_currentGame.graph getGraphCellWithIndex:_startCellIndex.intValue];
            LastSelectedStartGcell.temporarilyUnoccupied = NO;
            
            CellView *LastSelectedStartCellView = [self getCellViewWithIndex:_startCellIndex.intValue];
            [LastSelectedStartCellView cellUnTouched];
        }
        if(_endCellIndex){
            //deselect prevoiusly selected End Cell View
            CellView *LastSelectedEndCellView = [self getCellViewWithIndex:_endCellIndex.intValue];
            [LastSelectedEndCellView cellUnTouched];
            [self UnDrawPathWithPath:self.SelectedPath];
        }
        [_SelectedPath removeAllObjects];
        
        GraphCell *LastSelectedGcell = [_currentGame.graph getGraphCellWithIndex:touchedCell.tag-1000];
        [touchedCell cellTouchedWithStatus:LastSelectedGcell.color];
        self.startCellIndex = [NSNumber numberWithInt:touchedCell.tag-1000] ;
        LastSelectedGcell.temporarilyUnoccupied = YES;
    }else{
        if(!_startCellIndex){
            return;
        }
        if(_endCellIndex){
            //deselect prevoiusly selected End Cell View
            CellView *LastSelectedEndCellView = [self getCellViewWithIndex:_endCellIndex.intValue];
            [LastSelectedEndCellView cellUnTouched];
            [self UnDrawPathWithPath:self.SelectedPath];
        }
        self.endCellIndex = [NSNumber numberWithInt:touchedCell.tag-1000] ;
        [self.SelectedPath removeAllObjects];
        [self FindFastesPathWithCompletionBlock:^(NSArray *path){
            [self.SelectedPath addObjectsFromArray:path];
            if(self.SelectedPath.count==0){
                [self showBannerWithMessage:@"Can't go there !" withTitle:@"Sorry"];
            }
           // _OKBtn.enabled = self.SelectedPath.count>0;
            [self OKAction:nil];
        }];
    }
}

-(void)UnDrawPathWithPath:(NSArray*)path{
    for(int i =1;i<path.count;i++){
        NSNumber *CellIndex = [path objectAtIndex:i];
        CellView *cell = [self getCellViewWithIndex:CellIndex.intValue];
        [cell RemovePathTraceImage];
    }
}

-(void)DrawPathWithPath:(NSArray*)path{
    GraphCell *fromGCell = [_currentGame.graph getGraphCellWithIndex:((NSNumber*)[path objectAtIndex:0]).intValue];
    for(int i =1;i<path.count;i++){
        NSNumber *CellIndex = [path objectAtIndex:i];
        CellView *cell = [self getCellViewWithIndex:CellIndex.intValue];
        [cell setPathtTraceImageWithStatus:fromGCell.color];
    }
}

-(void)FindFastesPathWithCompletionBlock:(FastestPathFinderBlock)block{
    [FastestPathFinder findFastestPathWithOccupiedCells:[_currentGame.graph getOcuupiedCells] withSize:_currentGame.graph.size withStart:self.startCellIndex WithEnd:self.endCellIndex WithCompletionBlock:block];
}

-(void)OKAction:(UIButton *)sender{
    if(self.SelectedPath.count==0 || !self.SelectedPath){
        [self setUserInteractionEnabled:YES];
        return;
    }
    [self setUserInteractionEnabled:NO];

    CellView *fromCell = [self getCellViewWithIndex:_startCellIndex.intValue];
    GraphCell *fromGCell = [_currentGame.graph getGraphCellWithIndex:_startCellIndex.intValue];
    fromGCell.temporarilyUnoccupied = NO;
    CellView *Tocell = [self getCellViewWithIndex:_endCellIndex.intValue];
    
    [self MoveOccupiedCellFromIndex:self.startCellIndex.intValue toIndex:self.endCellIndex.intValue WithPath:self.SelectedPath];
    
    CompletionBlock block = ^(NSArray *detectedCells){
        if(detectedCells.count==0){
            [self AddNewCells];
        }else{
            [self setUserInteractionEnabled:YES];
            [self saveGame];
        }
    };
    [self DetectAndRemoveConnectedCellsAndUpdateScoreWithCompetionBlock:block withVerticesArray:[NSArray arrayWithObject:[_currentGame.graph getGraphCellWithIndex:_endCellIndex.intValue]]];
    _endCellIndex = nil;
    [Tocell cellUnTouched];
    _startCellIndex = nil;
    
    [fromCell cellUnTouched];
    //_OKBtn.enabled = NO;
    //_CancelBtn.enabled = NO;
}

-(void)CancelAction:(UIButton *)sender{
    
}

-(void)MoveOccupiedCellFromIndex:(int)Fromindex toIndex:(int)toIndex WithPath:(NSArray*)path{
    CellView *fromCell = [self getCellViewWithIndex:Fromindex];
    CellView *toCell = [self getCellViewWithIndex:toIndex];

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
    [fromCell SetStatusWithGraphCell:toGCell Animatation:CellAnimationTypeNone];
    [toCell SetStatusWithGraphCell:FromGCell Animatation:CellAnimationTypeNone];
   
}

-(void)GameOver{
    [PersistentStore persistGame:nil];
    [self ReportScoreToGameCenter];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Game Over" andMessage:@"nice job !"];
    
    [alertView addButtonWithTitle:@"Quit"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                              if([_delegate respondsToSelector:@selector(MatrixViewQuit:)])
                              {
                                  [_delegate MatrixViewQuit:self];
                              }
                          }];
    
    [alertView addButtonWithTitle:@"New Game"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              
                              [self ReloadNewGame];
                              
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleFade;
    
    [alertView performSelector:@selector(show) withObject:nil afterDelay:0.5];
    
}

-(void)DetectAndRemoveConnectedCellsAndUpdateScoreWithCompetionBlock:(CompletionBlock) block withVerticesArray:(NSArray*)vertices{
    // get detected rows from the ConnectedCellsDetector helper class
     [ConnectedCellRowsDetector getConnectedCellsWithGraph:_currentGame.graph withVertices:vertices withCompletionBlock:^(NSArray *result){
         // iterate on detected cells and remove them
         int numberOfCellsDetected = result.count;
         [self RemoveCells:result];
         //Update Score
         [_currentGame.score ReportScoreWithNumberOfDetectedCells:numberOfCellsDetected];
         
         [self UpdateScore];
         
         //call completion block
         block(result);
    
    }];
}

-(void)RemoveCells:(NSArray*)cells{
    for(GraphCell *GCell in cells){
        GCell.color = unOccupied;
        int index = [_currentGame.graph getIndexOfGraphCell:GCell];
        CellView *cellView = [self getCellViewWithIndex:index];
        [cellView SetStatusWithGraphCell:GCell Animatation:CellAnimationTypeRemoval];
    }
}

-(void)SaveUndoAction{
   /* undoBlock = ^(NSArray* lastAddedCells,NSArray *lastRemovedCells,NSNumber *lastStartCellIndex,NSNumber *lastEndCellIndex){
        
        //Remove Added Cells
        for(NSNumber *addedCell in lastAddedCells)
        {
            GraphCell *GCell = [self.graph getGraphCellWithIndex:addedCell.intValue];
            
            CellView *LocalCell = [self getCellViewWithIndex:addedCell.intValue];
            
            GCell.color = unOccupied;
            GCell.temporarilyUnoccupied = NO;
            
            [LocalCell SetStatusWithGraphCell:GCell];
        }
        
        // Add Removed Cells
        for(GraphCell *removedCell in lastRemovedCells)
        {
            [self.graph UpdateGraphCellAtIndex:removedCell.index WithCell:removedCell];
            [[self getCellViewWithIndex:removedCell.index] SetStatusWithGraphCell:removedCell];
        }
        [FastestPathFinder findFastestPathWithOccupiedCells:[self.graph getOcuupiedCells] withSize:self.size withStart:lastEndCellIndex WithEnd:lastStartCellIndex WithCompletionBlock:^(NSArray *path){
            
            [self MoveOccupiedCellFromIndex:lastEndCellIndex.intValue toIndex:lastStartCellIndex.intValue WithPath:path];
            
        }];
        
    };*/
}

-(void)UpdateScore{
    [levelProvider ReportScore:_currentGame.score.score];
    [self SetScoreInScoreBoard:_currentGame.score.score];
    if([_delegate respondsToSelector:@selector(setProgress:withLevelNumber:)]){
        CGFloat Mod = _currentGame.score.score % (int)(LEVEL_RANGE);
        CGFloat progress = (CGFloat)(Mod/LEVEL_RANGE);
        if([levelProvider isFinalLevel]){
            progress = 1.0f;
        }
        [_delegate setProgress:progress withLevelNumber:[levelProvider GetCurrentLevel].LevelIndex];
    }
}

-(CellView*)getCellViewWithIndex:(int)index{
    return ((CellView*)[self viewWithTag:index+1000]);
}

//*********************CELL PATH ANIMATION ********************************************************
-(void)AnimatePath:(NSArray*)path withColor:(UIColor*)color withCompletionBlock:(AnimationCompletionBlock)block{
    for (int i =0;i<path.count;i++) {
        CellView *PreCell = nil;
        if (i>0) {
            PreCell = (CellView*)[self viewWithTag:((NSNumber*)[path objectAtIndex:i-1]).intValue+1000];
        }
        CellView *cell = (CellView*)[self viewWithTag:((NSNumber*)[path objectAtIndex:i]).intValue+1000];
        NSArray *cells = [NSArray arrayWithObjects:cell,[NSNumber numberWithBool:i==path.count-1],PreCell, nil];
        
        NSArray *objectArr = [NSArray arrayWithObjects:cells,color, nil];
        [self performSelector:@selector(CellBackGroundToYellow:) withObject:objectArr afterDelay:i*0.06];
    }
}

-(void)CellBackGroundToYellow:(NSArray*)objectArray{
    NSArray *cells = [objectArray objectAtIndex:0];
    
    UIColor *color = [objectArray objectAtIndex:1];
    
    CellView *currentCell = [cells objectAtIndex:0];
    if(cells.count==3){
        CellView *PreCell = [cells objectAtIndex:2];
        [self performSelector:@selector(SetBackToWhite:) withObject:PreCell afterDelay:0.06];
    }
    if(!((NSNumber*)[cells objectAtIndex:1]).boolValue)
        currentCell.backgroundColor = color;
}

-(void)SetBackToWhite:(CellView*)preCell{
    preCell.backgroundColor = [UIColor whiteColor];
}

-(void)dealloc{
    
}
@end
