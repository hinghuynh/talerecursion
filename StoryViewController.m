//
//  StoryViewController.m
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "StoryViewController.h"
#import "FinishedTableViewController.h"

@interface StoryViewController ()

@end

@implementation StoryViewController



- (void)viewDidLoad

{
    [super viewDidLoad];
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];

    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
  
    NSLog(@"PLEASE SHOW %@", self.message);
    self.storyLabel.text = self.message;
    });
}

- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    [self.storyLabel resignFirstResponder];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.storyLabel.text];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-AU"];
    [self.synthesizer speakUtterance:utterance];
    
    
}


@end
