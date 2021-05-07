//
//  Connect5ViewController.m
//  Connect5
//
//  Created by Mohammed Eldehairy on 6/20/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "Connect5ViewController.h"

@interface Connect5ViewController ()

@end

@implementation Connect5ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES];
    
	ScoreBoard.layer.cornerRadius = 10;
    
    UIView *gameContainerView = [[UIView alloc] initWithFrame:CGRectMake(20, 120, 600, 400)];
    gameContainerView.frame = CGRectMake(20, 20, self.view.frame.size.width, 400);
    gameContainerView.center = CGPointMake(self.view.bounds.size.width/2, 280);
    gameContainerView.backgroundColor = UIColor.orangeColor;
    gameContainerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:gameContainerView];
    
    
    if(_IsResumedGame){
        _matrix = [[MatrixView alloc] initWithFrame:CGRectZero withGame:self.ResumedGame gameReumed:YES];
    }else{
        _matrix = [[MatrixView alloc] initWithFrame:CGRectZero] ;
    }
    _matrix.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    _matrix.delegate = self;
    _matrix.ScoreBoard = ScoreBoard;
    
    int y = 0;
    int xOffset = -15;
    int padding = 2;
    int cellSize = 32;
    
    for(int i = 0;i<MAX_NUMBER_OF_ADDED_CELLS;i++){
        CellView *cell = [[CellView alloc] initWithFrame:CGRectMake(20+i*(cellSize+padding)+xOffset, y , cellSize, cellSize)];
        cell.tag = 4000+i;
        [gameContainerView addSubview:cell];
    }
    
    _matrix.UndoBtn = UndoBtn;

    [gameContainerView addSubview:_matrix];

    [CancelBtn addTarget:_matrix action:@selector(CancelAction:) forControlEvents:UIControlEventTouchUpInside];
    CancelBtn.enabled = NO;
    okBtn.enabled = NO;
    [okBtn addTarget:_matrix action:@selector(OKAction:) forControlEvents:UIControlEventTouchUpInside];
    //_matrix.CancelBtn = CancelBtn;
    //_matrix.OKBtn = okBtn;

    progressView.pieFillColor = [UIColor colorWithRed:(37.0f/255.0f) green:(37.0f/255.0f) blue:(37.0f/255.0f) alpha:1.0];
    progressView.pieBorderColor = [UIColor whiteColor];
    progressView.pieBackgroundColor = [UIColor lightGrayColor];//[UIColor colorWithRed:(182.0f/255.0f) green:(195.0f/255.0f) blue:(214.0f/255.0f) alpha:1.0];
   // [progressView setProgress:0.6];
    
    //LevelLbl.text = @"Level 1";
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MatrixViewQuit:(MatrixView *)matrixView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)AddNextCellsWithGraphCells:(NSArray *)GCells{
    for(int i =0 ;i<MAX_NUMBER_OF_ADDED_CELLS;i++){
        CellView *cell = ((CellView*)[self.view viewWithTag:4000+i]);
        if(i<GCells.count){
            [cell SetStatusWithGraphCell:[GCells objectAtIndex:i] Animatation:CellAnimationTypeNone];
        }else{
            GraphCell *emptyCell = [[GraphCell alloc] init];
            emptyCell.color = unOccupied;
            [cell SetStatusWithGraphCell:emptyCell Animatation:CellAnimationTypeNone];
        }
    }
}

-(void)setProgress:(CGFloat)progress withLevelNumber:(int)levelNo{
    [progressView setProgress:progress];
    LevelLbl.text = [NSString stringWithFormat:@"Level %d",levelNo];
}

-(IBAction)QuitAction:(id)sender{
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Pause" andMessage:@""];
   
    [alertView addButtonWithTitle:@"Quit"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              
                              [self Quit];
                          }];
    
    [alertView addButtonWithTitle:@"New Game"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              
                              [self ResetNextCells];
                              [_matrix ReloadNewGame];
                          }];
    [alertView addButtonWithTitle:@"Cancel"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self Quit];
            break;
        default:{
            [self ResetNextCells];
            [_matrix ReloadNewGame];
        }
        break;
    }
}

-(void)ResetNextAddedCells{
    [self ResetNextCells];
}

-(void)ResetNextCells{
    GraphCell *emptyCell = [[GraphCell alloc] init];
    emptyCell.color = unOccupied;
    for(int i =0 ;i<MAX_NUMBER_OF_ADDED_CELLS;i++){
        CellView *cell = ((CellView*)[self.view viewWithTag:4000+i]);
        [cell SetStatusWithGraphCell:emptyCell Animatation:CellAnimationTypeNone];
    }
}

-(void)Quit{
    [self saveGame];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveGame{
    [_matrix saveGame];
}

-(void)reloadGame:(GameEntity *)game{
    [_matrix ReloadGame:game];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_matrix){
        [_matrix ResetUndo];
    }
}

-(void)ResetProgressAndLevel{
    [self setProgress:0.0f withLevelNumber:1];
}

-(void)ReloadNewGame{
    [self ResetProgressAndLevel];
    [self ResetNextCells];
    [_matrix ResetUndo];
    [_matrix ReloadNewGame];
}

-(void)dealloc{
}

-(void)UndoAction:(id)sender{
    [_matrix undoLastMove];
}

-(void)RedoAction:(id)sender{
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        return toInterfaceOrientation==UIInterfaceOrientationPortrait;
    }else{
        return YES;
    }
}

@end
