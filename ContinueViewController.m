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
    self.name = [[NSString alloc] init];
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
//            PFObject *author = [last objectForKey:@"author"];
//            NSLog(@"%@", author);
//            NSString *name = [NSString stringWithFormat:@"  - %@", [author objectForKey:@"username"]];
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

        PFObject *sen = [PFObject objectWithClassName:@"Sentence"];
        sen[@"sentence"] = sentence;
        [sen setObject: self.message forKey:@"story"];
        [sen setObject:[PFUser currentUser] forKey:@"author"];
        [sen saveInBackground];
        
        
//        PFQuery *postQuery = [PFQuery queryWithClassName:@"Sentence"];
//        [postQuery whereKey:@"story" equalTo:self.message];
//        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            
//            if (!error) {
//                if ([objects count] - 12 == 0) {
//                    
//                    NSLog(@"I AM IN THE FINISHING PUSH");
//                    
//                   
//                    
//                    for (PFObject *sentence in objects) {
//                        PFObject *user = [sentence objectForKey:@"author"];
//                        [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                        self.name = [user objectForKey:@"username"];
//                        NSLog(@"%@", self.name);
//                        }];
//
//                        if ([self.channels count] == 0) {
//                            [self.channels insertObject:self.name atIndex:[self.channels count]];
//                            NSLog(@"this username should receieve message %@", self.name);
//                        }
//                        else {
//                            for (PFObject *person in self.channels) {
//                                if ([person objectForKey:@"objectId"] != [user objectForKey:@"objectId"]) {
//                                    [self.channels insertObject:self.name atIndex:[self.channels count]];
//                                    NSLog(@"this username should receieve message %@", self.name);
//                                }
//                            }
//                        }
//                    }
//                    
//                    NSLog(@"This is an array on the continue page %@", self.channels);
//                    PFPush *push = [[PFPush alloc] init];
//                    [push setChannels:self.channels];
//                    NSString *pushMessage = [NSString stringWithFormat:@" The story called '%@' has just been finished, please login in Tale Recursion to read the finished story.", self.message];
//                    [push setMessage:pushMessage];
//                    [push sendPushInBackground];
//                }
//            }
//            
//            
//        }];
        
        self.sentenceField.text = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
@end
