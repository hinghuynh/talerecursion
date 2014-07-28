//
//  FinishedTableViewController.m
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "FinishedTableViewController.h"
#import "StoryViewController.h"

@interface FinishedTableViewController ()

@end

@implementation FinishedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    //    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"objectId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for(PFObject *story in objects){
                PFQuery *postQuery = [PFQuery queryWithClassName:@"Sentence"];
                [postQuery whereKey:@"story" equalTo:story];
                [postQuery findObjectsInBackgroundWithBlock:^(NSArray *sentences, NSError *error) {
                    
                    if ([sentences count] < 12){
                        
                        [array insertObject:story atIndex:[array count]];
                        NSLog(@"test %d", [array count]);
                        
                        if ([objects lastObject] == story){
                            self.messages = array;
                            NSLog(@"%d", [array count]);
                            [self.tableView reloadData];
                        }
                    }
                    
                }];
                
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showStory" sender:self];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if ([segue.identifier isEqualToString:@"showStory"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        StoryViewController *storyViewController = (StoryViewController *)segue.destinationViewController;
        storyViewController.message = self.selectedMessage;
    }
}

@end
