//
//  GameEntity.m
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import "GameEntity.h"

@implementation GameEntity
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.graph = [aDecoder decodeObjectForKey:@"graph"];
        self.score =[aDecoder decodeObjectForKey:@"score"];
        self.nextCellsToAdd = [aDecoder decodeObjectForKey:@"NextCellsToAdd"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.graph forKey:@"graph"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.nextCellsToAdd forKey:@"NextCellsToAdd"];
}
-(id)copyWithZone:(NSZone *)zone
{
    GameEntity *copy = [[GameEntity alloc] init];
    if(copy)
    {
        [copy setGraph:[self.graph copyWithZone:zone]];
        [copy setScore:[self.score copyWithZone:zone]];
        NSMutableArray *CopyArray = [NSMutableArray array];
        for(GraphCell *cell in _nextCellsToAdd)
        {
            GraphCell *copyGCell = [cell copyWithZone:zone];
            [CopyArray addObject:copyGCell];
        }
        [copy setNextCellsToAdd:CopyArray];
    }
    return copy;
}

@end
