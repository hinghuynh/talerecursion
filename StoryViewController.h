//
//  StoryViewController.h
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *storyLabel;

@property (nonatomic, strong) NSString *message;

@end
