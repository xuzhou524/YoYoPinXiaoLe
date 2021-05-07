//
//  FastestPathFinder.h
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "MSize.h"
#import "MJDijkstra.h"
@interface FastestPathFinder : NSObject
typedef void (^FastestPathFinderBlock) (NSArray *path );
+(void)findFastestPathWithOccupiedCells:(NSArray*)OccupiedCells withSize:(MSize*)Size withStart:(NSNumber*)start WithEnd:(NSNumber*)end WithCompletionBlock:(FastestPathFinderBlock)block;
@end
