//
//  PersistentStore.m
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import "PersistentStore.h"

@implementation PersistentStore
+ (NSMutableString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *basePath = ([paths count] > 0) ? [NSMutableString stringWithString:[paths objectAtIndex:0]] : nil;
    return basePath;
}
+(NSString*)filePath
{
    return [[self applicationDocumentsDirectory ] stringByAppendingPathComponent:@"LastGame"];
}
+(void)persistGame:(GameEntity *)game
{
    //NSDictionary *Data = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:game.graph,[NSNumber numberWithInt:game.score], nil] forKeys:[NSArray arrayWithObjects:@"graph",@"score", nil]];
   // [[NSUserDefaults standardUserDefaults] setObject:Data forKey:LAST_GAME_KEY];
   // [[NSUserDefaults standardUserDefaults] synchronize];
    [NSKeyedArchiver archiveRootObject:game toFile:[self filePath]];
    
}
+(GameEntity*)getLastGame
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
}
@end
