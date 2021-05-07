//
//  ConnectedCellRowsDetector.h
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "Graph.h"
#define CONNECTED_CELLS_COUNT 4
typedef void (^DetectedResultArrayBlock)(NSArray *);
@interface ConnectedCellRowsDetector : NSObject
+(void)getConnectedCellsWithGraph:(Graph*)graph withVertices:(NSArray*)vertices withCompletionBlock:(DetectedResultArrayBlock)block;
@end
