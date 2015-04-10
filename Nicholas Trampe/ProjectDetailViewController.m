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

#import "ProjectDetailViewController.h"
#import "ScreenShotsViewController.h"
#import "DataController.h"
#import "config.h"

@interface ProjectDetailViewController ()

- (NSURL *)appScheme;
- (BOOL)isAppInstalled;

@end

@implementation ProjectDetailViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.headerView setImage:sharedDC.theme.containerBox];
  
  if (m_data.image != nil)
  {
    [self.imageView setImageFromURL:[NSURL URLWithString:m_data.image] placeHolderImage:sharedDC.theme.placeholder animation:YES];
  }
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  
  if ([(ProjectCellData *)m_data url] == nil && [[(ProjectCellData *)m_data screenShots] count] == 0)
  {
    self.imageView.center = CGPointMake(self.headerView.center.x, self.headerView.center.y);
  }
}


- (void)updateUI
{
  [super updateUI];
  
  if (self.isAppInstalled)
  {
    [self.urlButton setTitle:@"Open" forState:UIControlStateNormal];
  }
  else if ([(ProjectCellData *)m_data url] != nil)
  {
    [self.urlButton setTitle:@"View In App Store" forState:UIControlStateNormal];
  }
  else if ([[(ProjectCellData *)m_data screenShots] count] > 0)
  {
    [self.urlButton setTitle:@"Screenshots" forState:UIControlStateNormal];
  }
  else
  {
    [self.urlButton setTitle:@"" forState:UIControlStateNormal];
  }
}


- (IBAction)urlPressed:(id)sender
{
  if (self.isAppInstalled && [(ProjectCellData *)m_data url] != nil)
  {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"Open" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open App", @"View In App Store", nil];
    [sheet showInView:self.view];
  }
  else if (self.isAppInstalled)
  {
    [[UIApplication sharedApplication] openURL:self.appScheme];
  }
  else if ([(ProjectCellData *)m_data url] != nil)
  {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(ProjectCellData *)m_data url]]];
  }
  else if ([[(ProjectCellData *)m_data screenShots] count] > 0)
  {
    ScreenShotsViewController * v = [[ScreenShotsViewController alloc] initWithScreenShots:[(ProjectCellData *)m_data screenShots]];
    [self.navigationController pushViewController:v animated:YES];
  }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  switch (buttonIndex)
  {
    case 0:
      [[UIApplication sharedApplication] openURL:self.appScheme];
      break;
      
    case 1:
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(ProjectCellData *)m_data url]]];
      break;
      
    default:
      break;
  }
}


- (NSURL *)appScheme
{  
  NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", [(ProjectCellData *)m_data scheme]]];
  
  return url;
}


- (BOOL)isAppInstalled
{
  return [[UIApplication sharedApplication] canOpenURL:self.appScheme];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
