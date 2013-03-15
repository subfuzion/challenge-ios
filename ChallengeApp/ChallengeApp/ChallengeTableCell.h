//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Challenge.h"


@interface ChallengeTableCell : UITableViewCell

- (void)updateCellData:(Challenge *)challenge useOperationQueue:(NSOperationQueue *)operationQueue;

- (void)cancelUpdate;

@end