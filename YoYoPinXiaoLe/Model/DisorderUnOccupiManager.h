//
//  DisorderUnOccupiManager.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>

@interface DisorderUnOccupiManager : NSObject
typedef void (^DisorderGenerationBlock)(NSArray *result);
+(void)generateDisorderUnOccupiedCellsIndexes:(int)count WithUnOccupiedCells:(NSArray*)UnOccupiedCells withCompletionBlock:(DisorderGenerationBlock)block;
@end
