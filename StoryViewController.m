//
//  StoryViewController.m
//  TailRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import "StoryViewController.h"
#import "FinishedTableViewController.h"

@interface StoryViewController ()

@end

@implementation StoryViewController

BOOL speechPaused = 0;



- (void)viewDidLoad

{
    [super viewDidLoad];
    
    // --------- SETTING THE BACKGROUND IMAGE -------------
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"final-story-background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    // ------------------ END -----------------------------
    
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    speechPaused = NO;
    self.synthesizer.delegate = self;

    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
  
    NSLog(@"PLEASE SHOW %@", self.message);
    self.storyLabel.text = self.message;
    });
}

- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    [self.storyLabel resignFirstResponder];
    if (speechPaused == NO) {
        [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.synthesizer continueSpeaking];
        speechPaused = YES;
    } else {
        [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        speechPaused = NO;
        [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    if (self.synthesizer.speaking == NO) {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.storyLabel.text];
        [utterance setRate:0.14];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-AU"];
        [self.synthesizer speakUtterance:utterance];
    }
}
-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    speechPaused = NO;
    NSLog(@"Playback finished");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
