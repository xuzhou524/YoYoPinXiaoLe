//
//  ConnectCellRowsManager.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "Graph.h"
#define CONNECTED_CELLS_COUNT 4
typedef void (^DetectedResultArrayBlock)(NSArray *);
@interface ConnectCellRowsManager : NSObject
+(void)getConnectedCellsWithGraph:(Graph*)graph withVertices:(NSArray*)vertices withCompletionBlock:(DetectedResultArrayBlock)block;
@end
