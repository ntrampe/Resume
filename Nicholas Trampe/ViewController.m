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

#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"
#import "MenuViewController.h"
#import "DataController.h"
#import "config.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  sharedDC = [DataController sharedDataController];
  
  [self setNavigationBarTitleColor:sharedDC.theme.textColor];
  self.navigationController.navigationBar.barTintColor = sharedDC.theme.navigationBarColor;
  self.view.backgroundColor = sharedDC.theme.backgroundColor;
  
  int count = 0;
  
  for (id child in self.view.subviews)
  {
    if ([child isKindOfClass:[UIButton class]])
    {
      [[(UIButton *)child titleLabel] setFont:[UIFont fontWithName:FONT_NAME size:(IS_PAD ? PAD_FONT_SIZE + 6 : PHONE_FONT_SIZE + 4)]];
      [[(UIButton *)child layer] setBorderWidth:(IS_PAD ? 5 : 3)];
      [[(UIButton *)child layer] setBorderColor:[[UIColor whiteColor] CGColor]];
      [(UIButton *)child setBackgroundColor:sharedDC.theme.buttonColors[count]];
      [(UIButton *)child setTag:count];
      [(UIButton *)child setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      count++;
    }
  }
  
  [self.slide setOffset:(self.view.frame.size.height > 480 ? 20 : 10)];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDataHandler) name:DATA_DOWNLOADED_NOTIFICATION object:nil];
  
  m_first = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self hide];
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self show];
}


- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  m_first = NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([sender isKindOfClass:[UIButton class]])
  {
    NSInteger tag = [(UIButton *)sender tag];
    if (tag >= 0 && tag < sharedDC.theme.buttonColors.count)
    {
      //const CGFloat* rgb = CGColorGetComponents([[m_colors objectAtIndex:tag] CGColor]);
      //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:0.5];
      
      sharedDC.color = [sharedDC.theme.buttonColors objectAtIndex:tag];
    }
  }
}


- (IBAction)refreshPressed:(id)sender
{
  [sharedDC downloadData];
}


- (void)hide
{
  for (UIView * child in self.view.subviews)
  {
    if ([child isKindOfClass:[UIButton class]])
    {
      child.hidden = YES;
    }
  }
  
  self.slide.hidden = YES;
}


- (void)show
{
  float total = (m_first ? 0.5 : 0.0f);
  
  for (UIView * child in self.view.subviews)
  {
    if ([child isKindOfClass:[UIButton class]])
    {
      child.center = CGPointMake(child.center.x - self.view.frame.size.width, child.center.y);
      child.hidden = NO;
      child.alpha = 1.0f;
      
      [UIView animateWithDuration:0.6f delay:total usingSpringWithDamping:0.8f initialSpringVelocity:0.2f options:UIViewAnimationOptionAllowAnimatedContent animations:^
       {
         child.center = CGPointMake(child.center.x + self.view.frame.size.width, child.center.y);
       }
                       completion:^(BOOL finished)
       {
         
       }];
      
      total += 0.1f;
    }
  }
  
  self.slide.center = CGPointMake(self.slide.center.x, self.slide.center.y - self.slide.frame.size.height * 2);
  self.slide.hidden = NO;
  
  [UIView animateWithDuration:1.0f delay:(m_first ? 0.5 : 0.0f) usingSpringWithDamping:0.8f initialSpringVelocity:0.2f options:UIViewAnimationOptionAllowAnimatedContent animations:^
   {
     self.slide.center = CGPointMake(self.slide.center.x, self.slide.center.y + self.slide.frame.size.height * 2);
   }
                   completion:^(BOOL finished)
   {
     m_first = NO;
   }];
}


- (void)downloadDataHandler
{
  [self.slide setImageURLString:sharedDC.picture];
  self.title = sharedDC.name;
}


- (void)setNavigationBarTitleColor:(UIColor *)aColor
{
  [self.navigationController.navigationBar setTitleTextAttributes:
   [NSDictionary dictionaryWithObjectsAndKeys:
    [UIFont fontWithName:FONT_NAME size:PHONE_FONT_SIZE], NSFontAttributeName,
    aColor, NSForegroundColorAttributeName, nil]];
  
  [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
   [NSDictionary dictionaryWithObjectsAndKeys:
    [UIFont fontWithName:FONT_NAME size:PHONE_FONT_SIZE], NSFontAttributeName,
    aColor, NSForegroundColorAttributeName, nil]
    forState:UIControlStateNormal];
  
  self.navigationController.navigationBar.tintColor = aColor;
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
