//
//  BSLMessagesTableViewController.h
//  Depiction
//
//  Created by Benjamin Lanyado on 06/02/2014.
//  Copyright (c) 2014 Benjamin Lanyado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSLMessagesTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/// storres who we are having a converstaion with
@property (nonatomic, strong) PFUser *selectedUser;

// add a property to store our messages
@property (nonatomic, strong) NSMutableArray   *messages;

@end

//adding a property to store the user with whommwe are having a convo

