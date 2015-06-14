/*
 * Copyright (c) 2014 Nicholas Trampe
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

#import "MenuViewController.h"
#import "DataController.h"
#import "config.h"

@interface MenuViewController (Private)

- (void)downloadDataHandler;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  sharedDC = [DataController sharedDataController];
  
  m_data = [NSMutableArray array];
  
  m_details = nil;
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.view.backgroundColor = sharedDC.theme.backgroundColor;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDataHandler) name:DATA_DOWNLOADED_NOTIFICATION object:nil];
  
  [self refreshData];
}


- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  m_details = nil;
}


- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
}


- (void)downloadDataHandler
{
  [m_data removeAllObjects];
  
  [self refreshData];
  
  [self.tableView reloadData];
  
  if (m_details != nil)
  {
    for (MenuCellData* data in m_data)
    {
      if ([data.title isEqualToString:m_details.cellData.title])
      {
        [m_details setCellData:data];
        break;
      }
    }
    
    [m_details updateUI];
  }
}


- (void)refreshData
{
  NSAssert(YES, @"Menu View Controller - You must override refreshData!");
}


- (void)addData:(MenuCellData *)aData
{
  if (aData == NULL)
    return;
  
  [m_data addObject:aData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return m_data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
  
  MenuCellData * data = [m_data objectAtIndex:indexPath.row];
  
  cell.backgroundColor = [UIColor clearColor];
  
  if (indexPath.row % 2 == 0)
  {
    cell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.15f];
  }
  
  cell.textLabel.numberOfLines = 4;
  cell.textLabel.text = data.title;
  cell.textLabel.backgroundColor = [UIColor clearColor];
  cell.textLabel.textColor = sharedDC.theme.textColor;
  cell.detailTextLabel.numberOfLines = 2;
  cell.detailTextLabel.text = data.details;
  cell.detailTextLabel.backgroundColor = [UIColor clearColor];
  cell.detailTextLabel.textColor = sharedDC.theme.textColor;
  
  [cell.textLabel setFont:[UIFont fontWithName:FONT_NAME size:(IS_PAD ? PAD_FONT_SIZE : PHONE_FONT_SIZE)]];
  [cell.detailTextLabel setFont:[UIFont fontWithName:FONT_NAME size:(IS_PAD ? PAD_FONT_SIZE - 8 : PHONE_FONT_SIZE - 4)]];
  [cell.imageView setImage:sharedDC.theme.placeholder];
  
  if (data.image != nil)
  {
//    cell.imageView.image = [UIImage imageNamed:data.image];
    
    [cell.imageView setImageFromURL:[NSURL URLWithString:data.image] placeHolderImage:sharedDC.theme.placeholder animation:YES];
  }
  else
  {
    cell.imageView.image = nil;
  }
  
  return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return (IS_PAD ? 132 : 88);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  NSIndexPath *path = [self.tableView indexPathForSelectedRow];
  
  m_details = (DetailViewController *)[segue destinationViewController];
  
  [m_details setCellData:[m_data objectAtIndex:path.row]];
}

@end
