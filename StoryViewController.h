//
//  StoryViewController.h
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>

@interface StoryViewController : UIViewController <AVSpeechSynthesizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *storyLabel;

@property (nonatomic, strong) NSString *message;

@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end
