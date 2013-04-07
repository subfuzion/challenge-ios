//
//  EventKitController.h
//  ChallengeApp
//
//  Created by Tenny Susanto on 4/7/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>


@interface EventKitController : NSObject

@property (strong, readonly) EKEventStore *eventStore;
@property (assign, readonly) BOOL eventAccess;
@property (assign, readonly) BOOL reminderAccess;
@property (strong) NSMutableArray *reminders;


- (void)addToCalenderWithTitle:(NSString*)title dueTime:(NSDate*)dueDate notes:(NSString*) notes;


@end
