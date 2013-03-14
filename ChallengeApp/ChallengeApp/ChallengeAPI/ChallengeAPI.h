//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


extern NSString * const kChallengeFeedPath;
extern NSString * const kChallengeBookmarksPath;


@interface ChallengeAPI : NSObject


// This will execute the block on the UI thread and pass an array of Challenge objects.
- (void)fetchChallenges:(void (^)(NSArray *))block;
- (void)cancelFetchChallenges;

// This will execute the block on the UI thread and pass an array of the requested Challenge objects.
- (void)fetchBookmarks:(NSArray *)ids withBlock:(void (^)(NSArray *))block;
- (void)cancelFetchBookmarks;

// This will execute the block on the UI thread and pass the requested image.
- (void)fetchImage:(NSString *)imageURL withBlock:(void (^)(UIImage *))block;
- (void)cancelFetchImage;


@end
