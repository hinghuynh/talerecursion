//
//  LoginViewController.h
//  TaleRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)login:(id)sender;

@end
