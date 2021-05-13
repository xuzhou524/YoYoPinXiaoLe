//
//  XZYoYoCellView.m
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import "XZYoYoCellView.h"

@implementation XZYoYoCellView

- (id)initWithFrame:(CGRect)frame{
    //frame = CGRectMake(frame.origin.x, frame.origin.y, CELL_SIZE-0.5, CELL_SIZE-0.5);
    self = [super initWithFrame:frame];
    if (self) {
        contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:contentView];
        // Initialization code
        self.frame = frame;
        self.backgroundColor = [UIColor lightGrayColor];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.layer.cornerRadius = frame.size.width/2;
        self.layer.cornerRadius = frame.size.width/2;
        self.IsOccupied = NO;
        self.SetTouchable = YES;
        UITapGestureRecognizer *TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        TapGesture.delegate = self;
        [self addGestureRecognizer:TapGesture];
        TapGesture = nil;
    }
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

-(void)addInnerShadowToView{
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:[self bounds]];
    
    // Standard shadow stuff
    [shadowLayer setShadowColor:[[UIColor colorWithWhite:0 alpha:1] CGColor]];
    [shadowLayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [shadowLayer setShadowOpacity:1.0f];
    [shadowLayer setShadowRadius:5];
    
    // Causes the inner region in this example to NOT be filled.
    [shadowLayer setFillRule:kCAFillRuleEvenOdd];
    
    // Create the larger rectangle path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectInset(self.bounds, -42, -42));
    
    // Add the inner path so it's subtracted from the outer path.
    // someInnerPath could be a simple bounds rect, or maybe
    // a rounded one for some extra fanciness.
    
    CGMutablePathRef someInnerPath = CGPathCreateMutable();
    CGPathAddRect(someInnerPath, NULL, CGRectInset(self.bounds, -43, -43));
    
    
    CGPathAddPath(path, NULL, someInnerPath);
    CGPathCloseSubpath(path);
    
    [shadowLayer setPath:path];
    CGPathRelease(path);
    
    [[self layer] addSublayer:shadowLayer];
}

-(void)handleTap:(UIGestureRecognizer*)sender{
    if([_delegate respondsToSelector:@selector(xZYoYoCellViewTouched:)]){
        [_delegate xZYoYoCellViewTouched:self];
    }
}

-(void)setOccupiedWithColor:(UIColor*)color{
    self.backgroundColor = color;
}

-(void)cellTouchedWithStatus:(GraphCellStatus)status{
    [self.superview bringSubviewToFront:self];
    [contentView startGlowingWithColor:[self getColorWithStatus:status] intensity:2];
}

-(void)cellUnTouched{
    [contentView stopGlowing];
}

-(void)setPathtTraceImageWithStatus:(GraphCellStatus)color{
    UIImage *img = [self getImageForStatus:color];
    contentView.image = img;
    contentView.alpha = 0.4;
}

-(void)removePathTraceImage{
    contentView.image = nil;
    contentView.alpha = 1.0;
}

-(void)dealloc{
    
}

-(UIColor*)getColorWithStatus:(GraphCellStatus)status{
    UIColor *backColor ;
    switch (status) {
        case red:
            backColor  = [UIColor colorWithRed:238/255.00 green:46/255.00 blue:72/255.00 alpha:1];
            break;
        case blue:
            backColor = [UIColor colorWithRed:0/255.00 green:61/255.00 blue:120/255.00 alpha:1];
            break;
        case green:
            backColor = [UIColor colorWithRed:0/255.00 green:133/255.00 blue:61/255.00 alpha:1];
            break;
        case yellow:
            backColor = [UIColor colorWithRed:255/255.00 green:185/255.00 blue:61/255.00 alpha:1];
            break;
        case orange:
            backColor = [UIColor colorWithRed:125/255.00 green:42/255.00 blue:114/255.00 alpha:1];
            break;
        default:
            backColor = [UIColor whiteColor];
            break;
    }
    return backColor;
}

-(UIImage*)getImageForStatus:(GraphCellStatus)status{
    UIImage *backColor ;
    switch (status) {
        case red:
            backColor  = [UIImage imageNamed:@"crystalBall_red.png"];
            break;
        case blue:
            backColor = [UIImage imageNamed:@"crystalBall_blue.png"];
            break;
        case green:
            backColor = [UIImage imageNamed:@"crystalBall_green.png"];
            break;
        case yellow:
            backColor = [UIImage imageNamed:@"crystalBall_yellow.png"];
            break;
        case orange:
            backColor = [UIImage imageNamed:@"crystalBall_orange.png"];
            break;
        default:
            backColor = nil;
            break;
    }
    return backColor;
}

-(void)setStatusWithGraphCell:(GraphCell*)GCell Animatation:(CellAnimationType)animationType{
    [self setStatusWithGraphCell:GCell Animatation:animationType withDelay:0.0 withCompletionBlock:nil];
}

-(void)setStatusWithGraphCell:(GraphCell*)GCell Animatation:(CellAnimationType)animationType withDelay:(NSTimeInterval)delay withCompletionBlock:(CellAnimationCompletionBlock)completionBlock{
    if(GCell.color==unOccupied){
        self.IsOccupied = NO;
    }else{
        self.IsOccupied = YES;
    }
    UIImage *backColor  = [self getImageForStatus:GCell.color];
    if(_IsOccupied && animationType==CellAnimationTypeAdded){
        [self.superview bringSubviewToFront:self];
        [self animateCellWithColor:backColor withDelay:delay withCompletionBlock:completionBlock];
    }else if (animationType==CellAnimationTypeRemoval){
        [self animateCellRemovalWithDelay:delay withCompletionBlock:completionBlock];
    }
    else{
        contentView.image = backColor;
    }
}


-(void)animateCellWithColor:(UIImage*)Color withDelay:(NSTimeInterval)delay withCompletionBlock:(CellAnimationCompletionBlock)completionBlock{
    contentView.alpha = 0.0;
    [UIView animateWithDuration:0.2 delay:delay*0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        contentView.image  = Color;
        contentView.alpha = 1.0;
        CATransform3D transform = CATransform3DMakeScale(1.4, 1.4, 1.4);
        contentView.layer.transform = transform;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 animations:^(void){
            contentView.layer.transform = CATransform3DIdentity;
        } completion:completionBlock];
    }];
}

-(void)animateCellRemovalWithDelay:(NSTimeInterval)delay withCompletionBlock:(CellAnimationCompletionBlock)completionBlock{
    [UIView animateWithDuration:0.15 delay:delay*0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        contentView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 2.5);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.15 animations:^(void){
            contentView.layer.transform = CATransform3DMakeScale(2.0, 2.0, 3);
            contentView.alpha = 0.0;
        } completion:^(BOOL finished){
            contentView.layer.transform = CATransform3DIdentity;
            contentView.image = nil;
            contentView.alpha = 1.0;
            if(completionBlock)
                completionBlock(finished);
        }];
    }];
}

@end
