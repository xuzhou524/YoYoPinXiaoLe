//
//  ScoreEntity.h
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import <Foundation/Foundation.h>

@interface ScoreEntity : NSObject<NSCoding,NSCopying>
@property(nonatomic)int score;
@property(nonatomic)int numberOfConsecutiveRowCollection;
-(void)ReportScoreWithNumberOfDetectedCells:(int)numberOfDetectedCells;
-(void)ResetScore;
@end
