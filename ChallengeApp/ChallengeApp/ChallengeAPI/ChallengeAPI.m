//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ChallengeAPI.h"
#import "Challenge.h"

// routes for debugging
// NSString * const kChallengeFeedPath = @"http://challenge-api.subfuzion.c9.io/feed";
// NSString * const kChallengeBookmarksPath = @"http://challenge-api.subfuzion.c9.io/bookmarks";

// production routes
NSString *const kChallengeFeedPath = @"http://challengeapi-7312.onmodulus.net/feed";
NSString *const kChallengeBookmarksPath = @"http://challengeapi-7312.onmodulus.net/bookmarks";


@implementation ChallengeAPI {
    NSOperationQueue *_fetchChallengesOperationQueue;
    NSOperationQueue *_fetchBookmarksOperationQueue;
}

- (void)fetchChallenges:(void (^)(NSArray *))block {
    if (!_fetchChallengesOperationQueue) {
        _fetchChallengesOperationQueue = [[NSOperationQueue alloc] init];
        _fetchChallengesOperationQueue.name = @"Challenge Feed Operation Queue";
    }

    [_fetchChallengesOperationQueue addOperationWithBlock:^(void) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kChallengeFeedPath]];
        NSArray *challenges = [self parseFeedResponseData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            block(challenges);
        }];
    }];
}

- (void)cancelFetchChallenges {
    if (_fetchChallengesOperationQueue) {
        [_fetchChallengesOperationQueue cancelAllOperations];
    }
}

- (void)fetchBookmarks:(NSArray *)ids withBlock:(void (^)(NSArray *))block {
    if (!_fetchBookmarksOperationQueue) {
        _fetchBookmarksOperationQueue = [[NSOperationQueue alloc] init];
        _fetchBookmarksOperationQueue.name = @"Challenge Bookmarks Operation Queue";
    }

    NSDictionary *map = [[NSDictionary alloc] initWithObjectsAndKeys:
            ids, @"ids",
            nil];

    if (![NSJSONSerialization isValidJSONObject:map]) {
        // todo
    }

    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:map options:0 error:&error];
    // todo: handle error


    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kChallengeBookmarksPath]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];

    [NSURLConnection sendAsynchronousRequest:request queue:_fetchBookmarksOperationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSArray *challenges = [self parseFeedResponseData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            block(challenges);
        }];
    }];
}

- (void)cancelFetchBookmarks {
    if (_fetchBookmarksOperationQueue) {
        [_fetchBookmarksOperationQueue cancelAllOperations];
    }
}

+ (NSOperation *)fetchImage:(NSString *)imageURL operationQueue:(NSOperationQueue *)operationQueue withBlock:(void (^)(UIImage *))block {
    if (!imageURL) return nil;
    if (!operationQueue) return nil;

    NSBlockOperation *fetchImageOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = fetchImageOperation;
    [fetchImageOperation addExecutionBlock:^(void) {
        NSURL *url = [[NSURL alloc] initWithString:imageURL];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            if (!weakOp.isCancelled) {
                block(image);
            }
        }];
    }];

    // queue the operation
    [operationQueue addOperation:fetchImageOperation];

    return fetchImageOperation;
}

- (NSArray *)parseFeedResponseData:(NSData *)responseData {
    NSMutableArray *challenges = [[NSMutableArray alloc] init];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization
            JSONObjectWithData:responseData
                       options:(NSJSONReadingOptions) kNilOptions
                         error:&error];

    NSArray *items = [json objectForKey:@"challenges"];

    for (NSDictionary *item in items) {
        Challenge *challenge = [Challenge challengeWithData:item];
        [challenges addObject:challenge];
    }

    return challenges;
}


@end
