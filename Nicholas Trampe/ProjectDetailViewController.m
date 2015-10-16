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

- (NSString *)buttonTitleForStatus:(ProjectStatus)aStatus;
- (void)performActionForStatus:(ProjectStatus)aStatus;
- (void)goToScreenshots;

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
  
  [self.urlButton.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
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
  
  NSUInteger status = [(ProjectCellData *)m_data status];
  
  [self.urlButton setTitle:[self buttonTitleForStatus:status] forState:UIControlStateNormal];
}


- (IBAction)urlPressed:(id)sender
{
  NSUInteger status = [(ProjectCellData *)m_data status];
  
  [self performActionForStatus:status];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
  
  for (NSUInteger i = 0; i <= 4; i++)
  {
    if ([title isEqualToString:[self buttonTitleForStatus:(1 << i)]])
    {
      [self performActionForStatus:(1 << i)];
      break;
    }
  }
}


- (NSString *)buttonTitleForStatus:(ProjectStatus)aStatus
{
  NSString * title = @"";
  
  if (aStatus != 0)
  {
    if ((aStatus & (aStatus-1)) == 0) // one bit set or power of 2
    {
      switch (aStatus)
      {
        case ProjectAppStoreAvailable:
          title = @"View In App Store";
          break;
          
        case ProjectInstallAvailable:
          title = @"Launch App";
          break;
          
        case ProjectGitHubAvailable:
          title = @"View In GitHub";
          break;
          
        case ProjectScreenshotsAvailable:
          title = @"Screenshots";
          break;
          
        default:
          break;
      }
    }
    else
    {
      title = @"Open";
    }
  }
  
  return title;
}


- (void)performActionForStatus:(ProjectStatus)aStatus
{
  if ((aStatus & (aStatus-1)) != 0) //more than one bit set
  {
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"Open" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (aStatus & ProjectInstallAvailable)
    {
      [sheet addButtonWithTitle:[self buttonTitleForStatus:ProjectInstallAvailable]];
    }
    
    if (aStatus & ProjectAppStoreAvailable)
    {
      [sheet addButtonWithTitle:[self buttonTitleForStatus:ProjectAppStoreAvailable]];
    }
    
    if (aStatus & ProjectGitHubAvailable)
    {
      [sheet addButtonWithTitle:[self buttonTitleForStatus:ProjectGitHubAvailable]];
    }
    
    if (aStatus & ProjectScreenshotsAvailable)
    {
      [sheet addButtonWithTitle:[self buttonTitleForStatus:ProjectScreenshotsAvailable]];
    }
    
    [sheet showInView:self.view];
  }
  else
  {
    switch (aStatus)
    {
      case ProjectAppStoreAvailable:
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(ProjectCellData *)m_data url]]];
        break;
        
      case ProjectInstallAvailable:
        [[UIApplication sharedApplication] openURL:[(ProjectCellData *)m_data appScheme]];
        break;
        
      case ProjectGitHubAvailable:
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(ProjectCellData *)m_data github]]];
        break;
        
      case ProjectScreenshotsAvailable:
        [self goToScreenshots];
        break;
        
      default:
        break;
    }
  }
}


- (void)goToScreenshots
{
  ScreenShotsViewController * v = [[ScreenShotsViewController alloc] initWithScreenShots:[(ProjectCellData *)m_data screenShots]];
  [self.navigationController pushViewController:v animated:YES];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
