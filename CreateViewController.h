//
//  CreateViewController.h
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *sentenceField;
@property (strong, nonatomic) NSString *storyTitle;

- (IBAction)addSentence:(id)sender;

@end
