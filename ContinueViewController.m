//
//  ContinueViewController.m
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import "ContinueViewController.h"

@interface ContinueViewController ()

@end

@implementation ContinueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.channels = [[NSMutableArray alloc] init];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    self.sentenceField.delegate = self;
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Sentence"];
    
    [postQuery whereKey:@"story" equalTo:self.message];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.allSentences = objects; // Store results
          
            PFObject *last = [objects firstObject];
             self.lastSentence = [last objectForKey:@"sentence"];
            PFObject *author = last[@"author"];
            NSLog(@"%@", author);
            
            [author fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                NSString *name = [NSString stringWithFormat:@"  - %@%@", [[author[@"username"]substringToIndex:1] uppercaseString],[author[@"username"] substringFromIndex:1]];
                self.previousSentence.text = [self.lastSentence stringByAppendingString:name];
            }];
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

        PFObject *sen = [PFObject objectWithClassName:@"Sentence"];
        sen[@"sentence"] = sentence;
        [sen setObject: self.message forKey:@"story"];
        [sen setObject:[PFUser currentUser] forKey:@"author"];
        [sen saveInBackground];
        
        
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Sentence"];
        [postQuery whereKey:@"story" equalTo:self.message];
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                if ([objects count] == @12) {
                    for (NSString *sentence  in objects) {
                        
                        [self.channels insertObject:sentence atIndex:[self.channels count]];
                        
                    }
                    
                    PFPush *push = [[PFPush alloc] init];
                    [push setChannels:self.channels];
                    NSString *pushMessage = [NSString stringWithFormat:@" The story called '%@' has just been finished, please login in Tale Recursion to read the finished story.", self.message];
                    [push setMessage:pushMessage];
                    [push sendPushInBackground];
                }
            }
            
            
            
        }];
        
        self.sentenceField.text = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
@end
