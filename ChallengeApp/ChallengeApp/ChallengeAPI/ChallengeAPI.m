//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ChallengeAPI.h"
#import "Challenge.h"

#define DEBUGAPI 0

#if DEBUGAPI
NSString *const kChallengeApiRoot = @"http://challenge-api.subfuzion.c9.io";
#else
NSString *const kChallengeApiRoot = @"http://challengeapi-7312.onmodulus.net";
#endif

// API routes
NSString *const kChallengesRoute = @"/challenges";
NSString *const kChallengeBookmarksRoute = @"/bookmarks";
NSString *const kChallengeInfoPageRoute = @"/info";


@implementation ChallengeAPI {
    NSOperationQueue *_fetchChallengesOperationQueue;
    NSOperationQueue *_fetchBookmarksOperationQueue;

}

+ (NSURL *)challengeUrlForRoute:(NSString *)route {
    NSURL *rootUrl = [NSURL URLWithString:kChallengeApiRoot];
    NSLog(@"CHALLENGE URL: %@", [NSURL URLWithString:route relativeToURL:rootUrl]);
    return [NSURL URLWithString:route relativeToURL:rootUrl];
}

+ (NSURL *)challengeUrlForQueryParameter:(NSString *)route queryParameterKey:(NSString *)key queryParameterValue:(NSString *)value {
    NSURL *rootUrl = [NSURL URLWithString:kChallengeApiRoot];
    NSString *routeWithQuery = [NSString stringWithFormat:@"%@?=%@", key, value];
    NSLog(@"CHALLENGE URL: %@", routeWithQuery);
    return [NSURL URLWithString:routeWithQuery relativeToURL:rootUrl];
}


- (void)fetchChallenges:(void (^)(NSArray *))block {
    [self fetchChallengesSorted:SortByNewest withBlock:block];
}

- (void)fetchChallengesSorted:(ChallengeSort)sortBy withBlock:(void (^)(NSArray *))block {
    if (!_fetchChallengesOperationQueue) {
        _fetchChallengesOperationQueue = [[NSOperationQueue alloc] init];
        _fetchChallengesOperationQueue.name = @"Challenge Feed Operation Queue";
    }
    
    [_fetchChallengesOperationQueue addOperationWithBlock:^(void) {
        NSString *route = [NSString stringWithFormat:@"%@?sort=%d", kChallengesRoute, sortBy];
        NSURL *url = [ChallengeAPI challengeUrlForRoute:route];

        NSData *data = [NSData dataWithContentsOfURL:url];
        NSArray *challenges = data
            ? [self parseFeedResponseData:data]
            : [[NSArray alloc] init];

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

    NSURL *url = [ChallengeAPI challengeUrlForRoute:kChallengeBookmarksRoute];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
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

+ (NSURL *)urlForInfoPage {
    return [ChallengeAPI challengeUrlForRoute:kChallengeInfoPageRoute];
}

+ (NSURL *)urlForDetailPage:(NSString *)challengeID {
    NSURL *url = [NSURL URLWithString:kChallengeApiRoot];
    url = [NSURL URLWithString:kChallengesRoute relativeToURL:url];
    url = [url URLByAppendingPathComponent:challengeID];
    NSLog(@"DETAIL URL: %@", url.absoluteURL);
    return url;
}

+ (NSOperation *)fetchInfoPageExecute:(void (^)(NSString *))block {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *fetchOp = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = fetchOp;

    [fetchOp addExecutionBlock:^{
        NSURL *url = [ChallengeAPI urlForInfoPage];
        NSString *page = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            if (!weakOp.isCancelled) {
                block(page);
            }
        }];
    }];

    [queue addOperation:fetchOp];
    return fetchOp;
}

+ (NSOperation *)fetchDetailPage:(NSString *)challengeID execute:(void (^)(NSString *))block {
    if (!challengeID) return nil;

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *fetchOp = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = fetchOp;
    
    [fetchOp addExecutionBlock:^{
        NSURL *url = [ChallengeAPI urlForDetailPage:challengeID];
        NSString *page = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            if (!weakOp.isCancelled) {
                block(page);
            }
        }];
    }];
    
    [queue addOperation:fetchOp];
    return fetchOp;
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
