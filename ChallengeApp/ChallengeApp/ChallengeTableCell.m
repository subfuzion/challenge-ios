//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ChallengeTableCell.h"


@implementation ChallengeTableCell {


}

+ (id)cellWithChallenge:(Challenge *)challenge {
	return [[self alloc] initWithChallenge:challenge];
}

- (id)initWithChallenge:(Challenge *)challenge {
	self = [super init];
	if (self) {
		[self updateCellData:challenge];
	}

	return self;
}

- (void)updateCellData:(Challenge *)challenge {
	if (challenge == nil) return;

	[self fetchImageAsync:challenge.imageURL];
	self.titleLabel.text = challenge.title;

}

- (void)fetchImageAsync:(NSString *)imageURLPath {
	if (imageURLPath == nil) return;

	// TODO: use operation queue
	NSURL *imageURL = [[NSURL alloc] initWithString:imageURLPath];
	UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
	//self.contentMode = UIViewContentModeCenter;
	//self.imageView.clipsToBounds = YES;
	self.imageView.image = image;
}

@end