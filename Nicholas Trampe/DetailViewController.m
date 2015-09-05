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
#import "DataController.h"
#import "DetailViewController.h"
#import "config.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  sharedDC = [DataController sharedDataController];
  
//  self.textView.editable = NO;
//  self.textView.selectable = YES;
//  self.textView.backgroundColor = [UIColor clearColor];
//  self.textView.textColor = sharedDC.theme.textColor;
  
  m_textBG = [[UIImageView alloc] initWithImage:[sharedDC.theme containerBox]];
  [self.view addSubview:m_textBG];
  [self.view sendSubviewToBack:m_textBG];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  self.view.backgroundColor = sharedDC.theme.backgroundColor;
  
  self.show.delegate = self;
  
  m_firstView = YES;
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self updateUI];
  
  if (m_firstView)
  {
    for (UIView * child in self.view.subviews)
    {
      child.hidden = YES;
    }
  }
  
  if (self.show != nil)
  {
    self.show.clipsToBounds = NO;
  }
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (m_data.image == nil)
  {
    //the text view fram has been resized
    //this forces all of the text to be rendered
    //self.textView.scrollEnabled = NO;
    //self.textView.scrollEnabled = YES;
  }
  
  if (self.show != nil)
  {
    [self.show performSelector:@selector(scheduleUpdates) withObject:nil afterDelay:(m_firstView ? 0.8f : 0.2f)];
  }
  
  if (m_firstView)
  {
    if (m_data.imageNames.count > 0)
    {
      NSMutableArray * images = [NSMutableArray array];
      
      for (NSString * s in m_data.imageNames)
      {
        [images addObject:s];
      }
      
      [self.show setImages:images];
    }
    else
    {
      UIImageView * lBg = [[UIImageView alloc] initWithImage:[sharedDC.theme containerBox]];
      lBg.frame = CGRectMake(20, self.show.frame.origin.y, self.view.frame.size.width - 20 - 20, self.show.frame.size.height - 20);
      [self.view addSubview:lBg];
      
      UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, lBg.frame.size.width - 10 - 10, lBg.frame.size.height - 10 - 10)];
      [l setNumberOfLines:4];
      [l setText:m_data.title];
      [l setTextAlignment:NSTextAlignmentCenter];
      [l setTextColor:sharedDC.theme.textColor];
      [l setFont:[UIFont fontWithName:FONT_NAME size:(IS_PAD ? PAD_FONT_SIZE : PHONE_FONT_SIZE)*2]];
      [lBg addSubview:l];
    }
    
    m_textBG.frame = CGRectMake(self.webView.frame.origin.x - 10, self.webView.frame.origin.y - 10, self.webView.frame.size.width + 20, self.webView.frame.size.height + 20);
    
    for (UIView * child in self.view.subviews)
    {
      BOOL above = (child.center.y < self.view.frame.size.height / 2.0f);
      
      child.center = CGPointMake(child.center.x, child.center.y + (self.view.frame.size.height)*(above ? -1 : 1));
      child.hidden = NO;
      
      [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.5f options:UIViewAnimationOptionAllowAnimatedContent animations:^
       {
         child.center = CGPointMake(child.center.x, child.center.y + (self.view.frame.size.height)*(above ? 1 : -1));
       }
                       completion:^(BOOL finished)
       {
         
       }];
    }
    
    m_firstView = NO;
  }
}


- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  if (self.show != nil)
  {
    self.show.clipsToBounds = YES;
    [self.show stopUpdates];
  }
}


- (void)setCellData:(MenuCellData *)aCellData
{
  m_data = aCellData;
}


- (MenuCellData *)cellData
{
  return m_data;
}


- (void)updateUI
{
  if (m_data == NULL)
    return;
  
  if (m_data.title != nil)
    self.title = m_data.title;
  
  [self.webView loadHTMLWithData:m_data];
}


- (void)detailSlideShowView:(DetailSlideShowView *)sender didDisplayImage:(UIImage *)aImage
{
  [self.fullScreenImageView setImage:aImage];
  
  [UIView animateWithDuration:0.2f animations:^
  {
    self.fullScreenImageView.alpha = 1.0f;
  }];
}


- (void)detailSlideShowViewDidDismissImage:(DetailSlideShowView *)sender
{
  [UIView animateWithDuration:0.2f animations:^{
    self.fullScreenImageView.alpha = 0.0f;
  }];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
