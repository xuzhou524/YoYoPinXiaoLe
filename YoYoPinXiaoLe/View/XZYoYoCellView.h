//
//  XZYoYoCellView.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GraphCell.h"
#import "UIView+Glow.h"
#define RIGHT_IMAGE_NAME @"SQUARE2.png"
#define WRONG_IMAGE_NAME @"WRONG TOUCH.png"
#define SQUARE_IMAGE @"SQUARE WHITE UNPRESSED.png"
#define CELL_SIZE ((([[UIDevice currentDevice] userInterfaceIdiom]) == (UIUserInterfaceIdiomPhone)) ? (42.5) : (60))
@protocol XZYoYoCellViewDelegate;
typedef void (^CellAnimationCompletionBlock)(BOOL finished);
typedef enum
{
    CellAnimationTypeRemoval,
    CellAnimationTypeAdded,
    CellAnimationTypeNone
    
}CellAnimationType;
@interface XZYoYoCellView : UIView<UIGestureRecognizerDelegate>
{
    UIImageView *contentView;
    //UIImageView *BackImgView;
}
@property(nonatomic,assign)id<XZYoYoCellViewDelegate> delegate;
@property(nonatomic)BOOL IsOccupied;
@property(nonatomic)BOOL SetTouchable;


//Notify the Cell that it has been touched to glow
-(void)cellTouchedWithStatus:(GraphCellStatus)status;
-(void)cellUnTouched;

// Methods to set the colour status of the cell with animation
-(void)SetStatusWithGraphCell:(GraphCell*)GCell Animatation:(CellAnimationType)animationType;
-(void)SetStatusWithGraphCell:(GraphCell*)GCell Animatation:(CellAnimationType)animationType withDelay:(NSTimeInterval)delay withCompletionBlock:(CellAnimationCompletionBlock)completionBlock;

-(void)setPathtTraceImageWithStatus:(GraphCellStatus)color;
-(void)RemovePathTraceImage;
-(UIColor*)getColorWithStatus:(GraphCellStatus)status;
@end
@protocol XZYoYoCellViewDelegate <NSObject>
-(void)XZYoYoCellViewTouched:(XZYoYoCellView*)cellView;
@end
