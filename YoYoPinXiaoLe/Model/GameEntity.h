//
//  GameEntity.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>
#import "Graph.h"
#import "ScoreEntity.h"
@interface GameEntity : NSObject<NSCoding,NSCopying>
@property(nonatomic,retain)Graph *graph;
@property(nonatomic,retain)ScoreEntity *score;
@property(nonatomic,retain)NSMutableArray *nextCellsToAdd;
@end
