//
//  BSLFriendsTableViewController.h
//  Depiction
//
//  Created by Benjamin Lanyado on 05/02/2014.
//  Copyright (c) 2014 Benjamin Lanyado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLLoginTableViewController.h"

//stating that we contaitn the delegate methids defined in LoginTableVIewController

@interface BSLFriendsTableViewController : UITableViewController <BSLLoginTableViewControllerDelegate>

@property (nonatomic, strong) NSArray *friends;

@end
