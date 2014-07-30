//
//  NotifyTableViewController.m
//  Tale Recursion
//
//  Created by Tyler Keating on 7/29/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.

#import "NotifyTableViewController.h"
#import "EditFriendsViewController.h"

@interface NotifyTableViewController ()

@end

@implementation NotifyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.receivingFriends = [[NSMutableArray alloc] init];
    self.currentUser = [PFUser currentUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [[UITableViewCell appearance] setTintColor:[UIColor colorWithRed:0.039 green:0.851 blue:0.882 alpha:1]];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    if ( cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        for (PFUser *buddy  in self.receivingFriends) {
            if ([buddy.objectId isEqualToString:user.objectId]) {
                [self.receivingFriends removeObject:buddy];
                break;
            }
        }
    
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.receivingFriends insertObject:user atIndex:[self.receivingFriends count]];
    }
    NSLog(@"test %d", [self.receivingFriends count]);
}


- (IBAction)pushInvites:(id)sender {
    NSLog(@"notify log %@", self.storyTitle);
    NSLog(@"Receiving friends: %@", self.receivingFriends);
    NSMutableArray *messageList = [[NSMutableArray alloc] init];
    for(PFObject *buddy in self.receivingFriends){
        [messageList insertObject:[buddy objectForKey:@"username"] atIndex:[messageList count]];
        NSLog(@"this is the array %@", messageList);
    }
    NSLog(@"this is the array %@", messageList);
    NSArray *channels = messageList;
    PFPush *push = [[PFPush alloc] init];
    // Be sure to use the plural 'setChannels'.
    [push setChannels:channels];
    NSString *pushMessage = [NSString stringWithFormat:@"%@ just started a story called '%@' and is requesting your help to finish it!!", [self.currentUser objectForKey:@"username"], self.storyTitle];
    [push setMessage:pushMessage];
    [push sendPushInBackground];
}
@end





