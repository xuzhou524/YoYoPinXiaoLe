//
//  ConnectedCellsDetector.h
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "Graph.h"
#define CONNECTED_CELLS_COUNT 4
@interface ConnectedCellsDetector : NSObject
typedef void (^ResultArrayBlock)(NSArray *);
+(NSArray*)getConnectedCellsWithGraph:(Graph*)graph withCompletionBlock:(ResultArrayBlock)block;

@end
