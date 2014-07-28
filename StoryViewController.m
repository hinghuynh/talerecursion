//
//  StoryViewController.m
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()

@end

@implementation StoryViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PLEASE SHOW %@", self.message);
    self.storyLabel.text = self.message;
}


@end
