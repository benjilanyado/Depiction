//
//  BSLMessagesTableViewController.h
//  Depiction
//
//  Created by Benjamin Lanyado on 06/02/2014.
//  Copyright (c) 2014 Benjamin Lanyado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSLMessagesTableViewController : UITableViewController

@property (nonatomic, strong) PFUser *selectedUser;

@property (nonatomic, strong) NSArray   *messages;

@end

//adding a property to store the user with whommwe are having a convo

