//
//  NotifyTableViewController.m
//  Tale Recursion
//
//  Created by Tyler Keating on 7/29/14.

#import "NotifyTableViewController.h"
#import "EditFriendsViewController.h"

@interface NotifyTableViewController ()

@end

@implementation NotifyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.checker = @"unchecked";
    
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
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ( cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.receivingFriends removeObject:[user objectForKey:@"username"]];
        self.checker = @"unchecked";
        NSLog(@"test %d", [self.receivingFriends count]);
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.receivingFriends insertObject:[user objectForKey:@"username"] atIndex:[self.receivingFriends count]];
        self.checker = @"checked";
        NSLog(@"test %d", [self.receivingFriends count]);
        NSLog(@"%@", [self.receivingFriends firstObject]);
    }
}


- (IBAction)pushInvites:(id)sender {
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
    [push setMessage:@"The Giants won against the Mets 2-3."];
    [push sendPushInBackground];
}
@end





