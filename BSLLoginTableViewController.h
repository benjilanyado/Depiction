//
//  BSLLoginTableViewController.h
//  Depiction
//
//  Created by Benjamin Lanyado on 07/02/2014.
//  Copyright (c) 2014 Benjamin Lanyado. All rights reserved.
//

#import <UIKit/UIKit.h>

//define a new protocol for telling another controller when we have logged in
@protocol BSLLoginTableViewControllerDelegate;

@interface BSLLoginTableViewController : UITableViewController

// need to reference the three boxes. Use IBOutlet to connec them to the storyboard
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UITextField *confirmPasswordField;

//we need a reference to the button
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

//need to record whether we are registering or logging in
@property (nonatomic) BOOL registered;

//define the property to have a reference to which object should be contacted when the work is done
@property (nonatomic, weak) id <BSLLoginTableViewControllerDelegate> delegate;

@end

// now defining our protocol - what method is it going to have?
// If the user does not login, we just show them alert, but do nothing - we keep the controller on screen
@protocol BSLLoginTableViewControllerDelegate <NSObject>

-(void)loginTableViewControllerDidLogin:(BSLLoginTableViewController *) controller;

@end
