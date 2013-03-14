//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Challenge.h"


@implementation Challenge

+ (id)challengeWithData:(NSDictionary *)data {
	return [[self alloc] initWithData:(NSData *)data];
}

- (id)initWithData:(NSDictionary *)data {
	self = [super init];
	if (self) {
		self.mongoID = [data objectForKey:@"_id"];
		self.title = [data objectForKey:@"title"];
		self.poster = [data objectForKey:@"poster"];
		self.url = [data objectForKey:@"url"];
		self.imageURL = [data objectForKey:@"image_url"];
		self.summary = [data objectForKey:@"summary"];
		self.status = [data objectForKey:@"status"];
		self.supporters = [data objectForKey:@"supporters"];
		self.prizeMoney = [data objectForKey:@"prize_money"];
		self.submissionPeriodStartDate = [data objectForKey:@"submission_period_start_date"];
		self.submissionPeriodEndDate = [data objectForKey:@"submission_period_end_date"];
		self.winnersAnnouncedDate = [data objectForKey:@"winners_announced_date"];

		// TODO
		//self.categories = [data objectForKey:@"categories"];

	}

	return self;
}

@end