//
//  BSLMessagesTableViewController.m
//  Depiction
//
//  Created by Benjamin Lanyado on 06/02/2014.
//  Copyright (c) 2014 Benjamin Lanyado. All rights reserved.
//

#import "BSLMessagesTableViewController.h"
// import category for loding images asynchronosouly
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface BSLMessagesTableViewController ()

@end

@implementation BSLMessagesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //set the titel fo the view to be the username of the selected user
    
    self.title = self.selectedUser.username;
    
    //go and get the messages from Parse (see below)
    
    [self fetchMessages];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)fetchMessages {
    
    
    
    /* get all messages where I am rhe sender and selectedUser is the receipient, or vice versa  */
    
    // 1st query: Get all messages where I am the sender and 'selectedUser' is the recipient
    PFQuery *senderQuery = [PFQuery queryWithClassName:@"Message"];
    
    // making sure that the sender field in Parse is our user
    [senderQuery whereKey:@"sender" equalTo:[PFUser currentUser]];
    
    //making sure that the recipent is the selected user
    [senderQuery whereKey:@"recipient" equalTo:self.selectedUser];
    
    // 2nd query: Get all messages where 'selectedUser' is the sneder, and I am the recipient
    
    //NOW THE ABOVE IN REVERSE
    
    PFQuery *recipientQuery = [PFQuery queryWithClassName:@"Message"];
    
    [recipientQuery whereKey:@"sender" equalTo:self.selectedUser];
    
    [recipientQuery whereKey:@"recipient" equalTo:[PFUser currentUser]];

    //ensure that our message object includes the sender
    
    PFQuery *superQuery = [PFQuery orQueryWithSubqueries:@[senderQuery,recipientQuery]];
    
    [superQuery includeKey:@"sender"];
    
    [superQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //handle it
        } else {
            self.messages = objects;
            
            //reload table view
            [self.tableView reloadData];
        }
    }];
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = @"message"; (this was here as filler before we asign)
    
    // now we're going to match up what we've done in the storyboard
    // we're 'casting' - the (UIImageView *) bit - it to an object of a different class
    //first ref to the image
    UIImageView *imageView = (UIImageView *)[cell viewWithTag: 1];
    
    //now ref to the label
    UILabel *label = (UILabel *)[cell viewWithTag: 2];
    
    //label.text = @"HI BENJ U R NICE"; dummy text
    
    // Get a reference to the message object being displayed
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    
    // Getting a reference to the sender of the message (sender is a property in our object on parse
    PFUser *sender = message[@"sender"];
    
    //populating the label
    label.text = sender.username;
    
    //now getting a reference to the imagefile nb "message" is the object, imagefile is a field on it
    PFFile *imageFile  = message[@"image"];
    
    //extracting url from image
    NSString *urlString = imageFile.url;
    
    //convert the string to a URL
    NSURL *url =[NSURL URLWithString:urlString];
    
    // set the image with the image stored at the url
    [imageView setImageWithURL:url];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
