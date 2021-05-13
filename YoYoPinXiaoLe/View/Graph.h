//
//  Graph.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "MSize.h"
#import "GraphCell.h"
@interface Graph : NSObject<NSCoding,NSCopying>{
    
}

@property(nonatomic,retain)MSize *size;
-(id)initWithSize:(MSize*)size;
-(void)AddGraphCell:(GraphCell*)cell;
-(GraphCell*)getGraphCellWithIndex:(int)index;
-(void)UpdateGraphCellAtIndex:(int)index WithCell:(GraphCell*)cell;
-(void)UpdateGraphCellAtX:(int)x AndY:(int)Y WithCell:(GraphCell*)cell;
-(void)ExchangeCellAtIndex:(int)FromIndex WithCellAtIndex:(int)ToIndex;
-(GraphCell*)getGraphCellWithX:(int)x withY:(int)y;
-(NSArray*)getOcuupiedCells;
-(NSArray*)getUnOccupiedCells;
-(int)getIndexOfGraphCell:(GraphCell*)GCell;
-(void)resetGraph;
-(int)indexWithX:(int)x AndY:(int)y;
@end
