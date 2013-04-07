//
//  EventKitController.m
//  ChallengeApp
//
//  Created by Tenny Susanto on 4/7/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import "EventKitController.h"
#define kRemindersCalendarTitle @"Challenge.gov reminders"



@implementation EventKitController

- (id) init {
    self = [super init];
    

    
    if (self) {
        _eventStore = [[EKEventStore alloc] init];
        [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) { _eventAccess = YES;
            } else {
                NSLog(@"Event access not granted: %@", error);
            } }];
        
        [_eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            if (granted) { _reminderAccess = YES;
            } else {
                NSLog(@"Reminder access not granted: %@",
                      error); }
        }]; }
    
    return self;
}

- (void) addReminderWithTitle:(NSString*) title dueTime:(NSDate*) dueDate notes:(NSString*) notes{
    if (!_reminderAccess) {
        NSLog(@"No reminder acccess!"); return;
    }
    
    
    //1.Create a reminder
    EKReminder *reminder = [EKReminder
                            reminderWithEventStore: self.eventStore];
    //2.Set title
    reminder.title = title;
    
    //3. Set the calendar
    reminder.calendar = [self calendarForReminders];
    

        
    //reminder.notes
    reminder.notes = notes;
    
    //4. Extract the NSDateComponents from the dueDate
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dueDateComponents = [calendar components:unitFlags fromDate:dueDate];
    
    //5. Set the due date
    reminder.dueDateComponents = dueDateComponents;
    
    //6. Save the reminder
    NSError *err;
    BOOL success = [self.eventStore
                    saveReminder:reminder commit:YES error:&err];
    if (!success) {
        NSLog(@"There was an error saving the reminder %@", err);
    }
        
    
}

- (EKCalendar*) calendarForReminders {
    //1
    for (EKCalendar *calendar in [self.eventStore
                                  calendarsForEntityType:EKEntityTypeReminder]) {
        if ([calendar.title isEqualToString:kRemindersCalendarTitle]) {
            return calendar; }
    }
    
    //2
    EKCalendar *remindersCalendar = [EKCalendar
                                     calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
    
    remindersCalendar.title = kRemindersCalendarTitle;
    
    remindersCalendar.source = self.eventStore.defaultCalendarForNewReminders.source;
    
    NSError *err;
    
    BOOL success = [self.eventStore
                    saveCalendar:remindersCalendar commit:YES error:&err];
    if (!success) {
        NSLog(@"There was an error creating the reminders calendar");
              return nil;
    }
    
    return remindersCalendar;
    
}


- (void) addToCalenderWithTitle:(NSString*)title dueTime:(NSDate*)dueDate notes:(NSString*) notes{
    
    NSLog(@"checking calender called");
    
    NSPredicate *predicate = [self.eventStore
                              predicateForRemindersInCalendars: @[[self calendarForReminders]]];
    
    
    [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders){
        
        self.reminders = [reminders mutableCopy];
        
        NSPredicate *titlePredicate = [NSPredicate
                                       predicateWithFormat:@"title matches %@",
                                       title];
        
        reminders = [reminders filteredArrayUsingPredicate:titlePredicate];
    
        if (reminders.count == 0){
            
            [self addReminderWithTitle: title
                            dueTime: dueDate
                              notes: notes];
            
            NSLog(@"Added");
            
        }
        else {
            NSLog(@"Already exists");
        }
    }];


}



@end
