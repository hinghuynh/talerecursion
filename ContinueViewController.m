//
//  ContinueViewController.m
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "ContinueViewController.h"

@interface ContinueViewController ()

@end

@implementation ContinueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sentenceField.delegate = self;
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Sentence"];
    
       NSLog(@"THISDJSALKJDASLKDJASLKDJASLDK %@", self.message);
    [postQuery whereKey:@"story" equalTo:self.message];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.allSentences = objects; // Store results
            for(PFObject *sentence in objects){
                self.lastSentence = [sentence objectForKey:@"sentence"];
            }
            self.previousSentence.text = self.lastSentence;
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)addSentence:(id)sender {

    NSString *sentence = [self.sentenceField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([sentence length] == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"A text field is blank, please enter a sentence!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
//        PFObject *tale = [PFObject objectWithClassName:@"Story"];
//        [tale setObject: title forKey:@"title"];
//        [tale setObject: [PFUser currentUser] forKey:@"author"];
//        [tale saveInBackground];
        
        PFObject *sen = [PFObject objectWithClassName:@"Sentence"];
        sen[@"sentence"] = sentence;
        [sen setObject: self.message forKey:@"story"];
        [sen saveInBackground];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
@end
