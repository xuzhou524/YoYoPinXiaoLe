//
//  RandomUnOccupiedCellsGenerator.m
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import "RandomUnOccupiedCellsGenerator.h"

@implementation RandomUnOccupiedCellsGenerator
+(void)GenerateRandomUnOccupiedCellsIndexes:(int)count WithUnOccupiedCells:(NSArray *)UnOccupiedCells withCompletionBlock:(RandomGenerationBlock)block
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
    
    
        int Iterations = count;
        
        if(count>UnOccupiedCells.count)
        {
            dispatch_async(dispatch_get_main_queue(), ^(void){
            
                block([NSArray array]);
                
            
            });
            //return ;
        }
        
        NSMutableArray *result = [NSMutableArray array];
        for(int i=0;i<Iterations;i++)
        {
            int randomIndex = arc4random_uniform(UnOccupiedCells.count);
            NSNumber *RandomNo = [UnOccupiedCells objectAtIndex:randomIndex];
            
            BOOL AlreadyThere = [result containsObject:RandomNo];
            
            if(AlreadyThere==NO)
            {
                [result addObject:RandomNo];
                
            }else
            {
                Iterations++;
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            block(result);
            
        });
    
    });
    
    
    
    
}
@end
