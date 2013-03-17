//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


extern NSString *const kChallengeApiRoot;
extern NSString *const kChallengesRoute;
extern NSString *const kChallengeBookmarksRoute;
extern NSString *const kChallengeInfoPageRoute;
extern NSString *const kChallengeDetailPageRoute;


typedef NS_ENUM(NSUInteger, ChallengeSort) {
    
    SortByNewest,
    SortByTimeLeft,
    SortByPrize,
};


@interface ChallengeAPI : NSObject


// This will execute the block on the UI thread and pass an array of Challenge objects.
- (void)fetchChallenges:(void (^)(NSArray *))block;
- (void)fetchChallengesSorted:(ChallengeSort)sortBy withBlock:(void (^)(NSArray *))block;

- (void)cancelFetchChallenges;

// This will execute the block on the UI thread and pass an array of the requested Challenge objects.
- (void)fetchBookmarks:(NSArray *)ids withBlock:(void (^)(NSArray *))block;

- (void)cancelFetchBookmarks;

// This will execute the block on the UI thread and pass the requested image.
+ (NSOperation *)fetchImage:(NSString *)imageURL operationQueue:(NSOperationQueue *)operationQueue withBlock:(void (^)(UIImage *))block;

+ (NSURL *)urlForInfoPage;

+ (NSURL *)urlForDetailPage:(NSString *)challengeID;

+ (NSOperation *)fetchInfoPageExecute:(void (^)(NSString *))block;

+ (NSOperation *)fetchDetailPage:(NSString *)challengeID execute:(void (^)(NSString *))block;

@end
