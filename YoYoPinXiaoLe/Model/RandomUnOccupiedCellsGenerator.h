//
//  RandomUnOccupiedCellsGenerator.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>

@interface RandomUnOccupiedCellsGenerator : NSObject
typedef void (^RandomGenerationBlock)(NSArray *result);
+(void)GenerateRandomUnOccupiedCellsIndexes:(int)count WithUnOccupiedCells:(NSArray*)UnOccupiedCells withCompletionBlock:(RandomGenerationBlock)block;
@end
