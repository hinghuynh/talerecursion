//
//  CreateViewController.m
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import "CreateViewController.h"
#import "NotifyTableViewController.h"

@interface CreateViewController ()


@end

@implementation CreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.titleField.delegate = self;
    self.sentenceField.delegate = self;
    self.currentUser = [PFUser currentUser];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)addSentence:(id)sender {
    self.title = [self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *sentence = [self.sentenceField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([sentence length] == 0 || [self.title length] == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"A text field is blank, please enter a title or sentence!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        PFObject *tale = [PFObject objectWithClassName:@"Story"];
        [tale setObject: self.title forKey:@"title"];
        [tale setObject: [PFUser currentUser] forKey:@"author"];
        [tale saveInBackground];
        
        PFObject *sen = [PFObject objectWithClassName:@"Sentence"];
        sen[@"sentence"] = sentence;
        [sen setObject: tale forKey:@"story"];
        [sen setObject:[PFUser currentUser] forKey:@"author"];
        [sen saveInBackground];
        [self performSegueWithIdentifier:@"showFriends" sender:nil];
        
        self.titleField.text  = nil;
        self.sentenceField.text = nil;

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFriends"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        NotifyTableViewController *viewController = (NotifyTableViewController *)segue.destinationViewController;
        viewController.storyTitle = self.title;
        NSLog(@"title log %@", self.title);
        NSLog(@"Im here");
    }
}

@end
