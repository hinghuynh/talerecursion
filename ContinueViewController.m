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
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"final-background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    self.sentenceField.delegate = self;
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Sentence"];
    
    [postQuery whereKey:@"story" equalTo:self.message];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.allSentences = objects; // Store results
            for(PFObject *sentence in objects){
                self.lastSentence = [sentence objectForKey:@"sentence"];
            }
            PFObject *last = [objects lastObject];
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
        
//        PFObject *tale = [PFObject objectWithClassName:@"Story"];
//        [tale setObject: title forKey:@"title"];
//        [tale setObject: [PFUser currentUser] forKey:@"author"];
//        [tale saveInBackground];
        
        PFObject *sen = [PFObject objectWithClassName:@"Sentence"];
        sen[@"sentence"] = sentence;
        [sen setObject: self.message forKey:@"story"];
        [sen setObject:[PFUser currentUser] forKey:@"author"];
        [sen saveInBackground];
        
        self.sentenceField.text = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
@end
