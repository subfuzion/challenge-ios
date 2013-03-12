//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Challenge : NSObject

@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSString *mongoID;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *poster;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *imageURL;
@property(nonatomic, copy) NSString *summary;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *supporters;
@property(nonatomic, copy) NSString *prizeMoney;
@property(nonatomic, copy) NSString *submissionPeriodStartDate;
@property(nonatomic, copy) NSString *submissionPeriodEndDate;
@property(nonatomic, copy) NSString *winnersAnnouncedDate;
@property(nonatomic, copy) NSArray *categories;


+ (id)challengeWithData:(NSDictionary *)data;

- (id)initWithData:(NSDictionary *)data;


@end