//
//  BSLFriendsTableViewController.m
//  Depiction
//
//  Created by Benjamin Lanyado on 05/02/2014.
//  Copyright (c) 2014 Benjamin Lanyado. All rights reserved.
//

#import "BSLFriendsTableViewController.h"
//tell this class about the existence of the messages controller
#import "BSLMessagesTableViewController.h"

@interface BSLFriendsTableViewController ()

@end

@implementation BSLFriendsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = NSLocalizedString(@"Friends", @"A List of Friends");
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    // get a reference ti te currently logged in user - this should be nil
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        // load the users
        [self fetchUsers];

    } else {
        // show the login screen
        // hard-code login for time being - done in background so we don't block the main UI thread
        
        [PFUser logInWithUsernameInBackground:@"blanyado" password:@"steer1" block:^(PFUser *user, NSError *error) {
            
            //check if there was a problem logging in
            if (error) {
                NSLog(@"There was an error logging in!");
            } else {
                NSLog(@"You're in BABY!!!!");
                //call our method (that we've written ourself)
                [self fetchUsers];
            }
        }];
    }
}

- (void)fetchUsers {
    
    //create a query for users - convenience method instead of writing
    //[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    
    PFQuery *query = [PFUser query];
    
    /* Ensure that our user object )the person logged in is not returned by the Parse query*/
    
    // get a reference to the current user
    
    PFUser *user = [PFUser currentUser];
    
    // removes your name from the list - you don't want to message yourself!
    [query whereKey:@"username" notEqualTo: user.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // handle the error
        }
        else {
            //we now own it as we have defined it as strong
            self.friends = objects;
            //relaod the table
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
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    PFUser *user = [ self.friends objectAtIndex: indexPath.row];
    
    //assign our label to be username of the user
    cell.textLabel.text = user.username;
    
    // you don't need this as you've set it in the story board
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // getting a reference to the view controller that we will be presenting
    
    if ([segue.identifier isEqualToString:@"ShowMessages"]) {
        BSLMessagesTableViewController *messagesController = [segue destinationViewController];
        
        //state that the sender is actually of the class UITabeleViewCell (i.e that's where it has come from. Tells you you have a cell
        UITableViewCell *cell = sender;
        
        //ask the table view to give us an indexpath (section/row) for the selected cell
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        //get a reference to the PFUser object
        PFUser *user = [self.friends objectAtIndex:indexPath.row];
        
        /// we're passing through this to messgaes controller
        
        messagesController.selectedUser = user;
    }
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
