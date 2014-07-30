//
//  NotifyTableViewController.h
//  Tale Recursion
//
//  Created by Tyler Keating on 7/29/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NotifyTableViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *receivingFriends;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSString *storyTitle;

- (IBAction)pushInvites:(id)sender;

@end
