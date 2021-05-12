//
//  ScoreEntity.h
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

#import <Foundation/Foundation.h>

@interface ScoreEntity : NSObject<NSCoding,NSCopying>
@property(nonatomic)NSInteger score;
@property(nonatomic)NSInteger numberOfConsecutiveRowCollection;
-(void)ReportScoreWithNumberOfDetectedCells:(NSInteger)numberOfDetectedCells;
-(void)ResetScore;
@end
