//
//  EditTableViewController.m
//  Nicholas Trampe
//
//  Created by Nicholas Trampe on 1/13/15.
//  Copyright (c) 2015 Nicholas Trampe. All rights reserved.
//

#import "EditTableViewController.h"
#import "DataController.h"

@interface EditTableViewController ()

@end

@implementation EditTableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  sharedDC = [DataController sharedDataController];
  
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EditTableCell"];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section)
  {
    case 0:
      return sharedDC.themeNames.count;
      break;
      
    case 1:
      return 2;
      break;
      
    default:
      return 5;
      break;
  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTableCell" forIndexPath:indexPath];
  
  switch (indexPath.section)
  {
    case 0:
      cell.textLabel.text = [sharedDC.themeNames objectAtIndex:indexPath.row];
      
      if (indexPath.row == sharedDC.themeNumberLoaded)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
      else
        cell.accessoryType = UITableViewCellAccessoryNone;
      break;
      
    default:
      cell.textLabel.text = @"";
      cell.accessoryType = UITableViewCellAccessoryNone;
      break;
  }
  
  return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section)
  {
    case 0:
      return @"Theme:";
      break;
      
    case 1:
      return @"Profile:";
      break;
      
    default:
      return @"Section:";
      break;
  }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section)
  {
    case 0:
      return NO;
      break;
      
    default:
      return YES;
      break;
  }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section)
  {
    case 0:
      [sharedDC loadTheme:[sharedDC.themeNames objectAtIndex:indexPath.row]];
      break;
      
    default:
      
      break;
  }
  [self.tableView reloadData];
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
