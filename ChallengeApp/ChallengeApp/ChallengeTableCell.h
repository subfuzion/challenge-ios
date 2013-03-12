//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Challenge.h"


@interface ChallengeTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;



+ (id)cellWithChallenge:(Challenge *)challenge;

- (id)initWithChallenge:(Challenge *)challenge;

- (void)updateCellData:(Challenge *)challenge;

@end