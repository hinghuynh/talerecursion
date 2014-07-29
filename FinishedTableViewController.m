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
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    //    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"objectId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {

            for(PFObject *story in objects){
                PFQuery *postQuery = [PFQuery queryWithClassName:@"Sentence"];
                [postQuery whereKey:@"story" equalTo:story];
                [postQuery findObjectsInBackgroundWithBlock:^(NSArray *sentences, NSError *error) {
                    
                    if ([sentences count] >= 12){
                        
                        [array insertObject:story atIndex:[array count]];
                        NSLog(@"test %d", [array count]);
                       
                    }
                    
                }];
                
            }
        }
    }];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        self.messages = array;
        NSLog(@"%d", [array count]);
        [self.tableView reloadData];
    });
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
    PFQuery *query = [PFQuery queryWithClassName:@"Sentence"];
    [query orderByAscending:@"createdAt"];
    [query whereKey:@"story" equalTo:self.selectedMessage];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            NSMutableArray *array = [[NSMutableArray alloc] init];
            for(PFObject *sentence in objects){
                [array insertObject:[sentence objectForKey:@"sentence"] atIndex:[array count]];
                NSLog(@"test %d", [array count]);
                
                if ([objects lastObject] == sentence) {
                    NSLog(@"test %d", [array count]);
                    NSString *joinedString = [array componentsJoinedByString:@"  "];
                    NSLog(@"test %@", joinedString);
                    self.joinedString = joinedString;
                }
            }
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showStory"]) {
        
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        StoryViewController *storyViewController = (StoryViewController *)segue.destinationViewController;
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        storyViewController.message = self.joinedString;
         });
    }
}

@end
