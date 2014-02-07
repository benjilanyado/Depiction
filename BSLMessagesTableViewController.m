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

//import our category to resize the image taken
#import "UIImage+Resize.h"

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
            
            
            //keeping a reference to the array of returned messages
            //create a mutable copy of the array since we want to add sent messages to it
            self.messages = [objects mutableCopy];
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

#pragma mark - Actions

- (IBAction)cameraPressed:(id)sender {
    
    
    NSLog(@"camera pressed");
    
    // initialise a new instance of UIImagePickerController
    // alloc allocates some memory for this new object
    // init sets it up for use
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    
    //ensure that we are capturing the new image with a camera
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // the camera will go away and do some work for us
    // this may take some time, and the user may even cancel it
    // we want to be the one who is infromed whtn the user does somethng (takes pic/cancels)
    /// WE (messagescontroler) HAVE THE LOGIC - YOU DO THE WORK AND LET US KNOW
    // THEREFORE WE SET IT'S DELEGATE (who to report back to) as US
    // WE'VE GOT THE LOGIC, NOW GO DO SOMETHING
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
    
} // end of camera pressed method


-(void)sendMessageWithImage:(UIImage *)image {
    
    //create a new instance of PFObject that corresponds to the correct class in Parse
    PFObject *newMessage = [PFObject objectWithClassName:@"Message"];
    
    //set the sender as the current user
    newMessage[@"sender"] = [PFUser currentUser];
    
    //set the recipient
    newMessage[@"recipient"] = self.selectedUser;
    
    // setting ACL (Access Control List) on object - sets who can and can't see it
    PFACL *messageACL = [PFACL ACL];
    
    // set public read access to NO
    [messageACL setPublicReadAccess:NO];
    
    // set READ access
    [messageACL setReadAccess:YES forUser:self.selectedUser];
    
    // make sure the WE can set information on this message (ie an IMAGE!)
    [messageACL setWriteAccess:YES forUser:[PFUser currentUser]];
    
    // assign these rules that we have created to our new message object
    newMessage.ACL = messageACL;
    
    //resize the image taken (and give it to use via the image argument of this method
    //becuase it's too large to upload to Parse (for our use-case
    
    // create a size (widht and height) to pass to category method
    CGSize size = CGSizeMake(640, 1138);
    
    //use the size we have just created
    UIImage *resizedImage = [image resizedImage:size];
    
    //compressing the image - converting from bitmap to jpg - much smaller in size
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.6);
    
    //initialise a new file object using this binary data
    //this will upload the data to Parse
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    
    //asign the file to the message object
    newMessage[@"image"] = imageFile;
    
    //WE"VE MADE THE MESSAGE, WE'VE GOT THE FILE, NOW WE NEED TO ATTACH THE TWO
    
    //save the message to parse. Pasrse SDK handles rthe uploading of the image for us
    // we give it a block to execute when it finishes/fails
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        //check that upload was successful
        if (error)
        {
            //create an alert to tell the user ther is a problem
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Couldn't show a message at this time", @"Shown when uplaoding") delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles: nil];
            
            //put the alert on the screen
            [alertView show];
        } else {
            
            NSLog(@"Message sent!");
            
            //append new message to mutable array
            [self.messages addObject:newMessage];
            NSInteger row = [self.messages count] -1 ;
            
            // get a reference to the row that we are inserting into the table
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            
            //tell the table view to insert a new row at the index path that we have created
            
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            // animate scroll to bottom            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionBottom animated:YES];
        };
    }];
    
    
    
    
    
}

#pragma mark - UIImagePickerControllerDelegate


// these are the two delegate methods that we will use to detect if the user has done something
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info; {
    
    // info is a dictionary with a set of keys and associated objects
    //i.e. we ask the dictionary for the imahe sna it returns the UIImange instance
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // call out method we added above to send the image to Parse
    [self sendMessageWithImage:image];
    
    NSLog(@"Taken an image");
    
    NSLog(@"apple");
    
    //this illustrates blcoks (callbacks) and how they can be used to execute code after something has happened
    //this will read apple >> orange >> banana in the console log.
    //the caret (^) is used to define the block (callback) - a chunk of code that can be treated as an object - it's an argument on a method
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"banana");
    }];
    
    NSLog(@"orange");
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker; {
    
    NSLog(@"Cancelled");
    
}







@end
