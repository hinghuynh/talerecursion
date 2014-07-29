//
//  CreateViewController.m
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()


@end

@implementation CreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleField.delegate = self;
    self.sentenceField.delegate = self;
    self.currentUser = [PFUser currentUser];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (IBAction)addSentence:(id)sender {
    NSString *title = [self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *sentence = [self.sentenceField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([sentence length] == 0 || [title length] == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"A text field is blank, please enter a title or sentence!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        PFObject *tale = [PFObject objectWithClassName:@"Story"];
        [tale setObject: title forKey:@"title"];
        [tale setObject: [PFUser currentUser] forKey:@"author"];
        [tale saveInBackground];
        
        PFObject *sen = [PFObject objectWithClassName:@"Sentence"];
        sen[@"sentence"] = sentence;
        [sen setObject: tale forKey:@"story"];
        [sen setObject:[PFUser currentUser] forKey:@"author"];
        [sen saveInBackground];

    }
}
@end
