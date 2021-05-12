//
//  GraphCell.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MSize.h"
typedef enum {
    red,
    blue,
    green,
    yellow,
    orange,
    unOccupied
} GraphCellStatus;
@interface GraphCell : NSObject<NSCoding,NSCopying>

@property(nonatomic,assign)GraphCellStatus color;
@property(nonatomic,assign)int x;
@property(nonatomic,assign)int y;
@property(nonatomic,assign)int index;
@property(nonatomic,assign)BOOL temporarilyUnoccupied;
-(id)initWithColor:(GraphCellStatus)color;
-(UIColor*)GetUIColor;
-(CGPoint)getPointWithSize:(MSize*)size;
-(void)copySelftoGCell:(GraphCell*)CopyGCell;
@end
