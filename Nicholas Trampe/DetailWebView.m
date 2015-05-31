//
//  DetailWebView.m
//  Nicholas Trampe
//
//  Created by Nicholas Trampe on 5/31/15.
//  Copyright (c) 2015 Nicholas Trampe. All rights reserved.
//

#import "DetailWebView.h"
#import "DataController.h"
#import "ProjectDetailViewController.h"
#import "config.h"

@interface DetailWebView (Private) 

- (void)commonInit;
- (UIViewController*)viewController;

@end

@implementation DetailWebView


- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  
  if (self)
  {
    [self commonInit];
  }
  
  return self;
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self)
  {
    [self commonInit];
  }
  
  return self;
}


- (void)loadHTMLWithData:(MenuCellData *)aData
{
  if (aData == NULL)
    return;
  
  NSString * result = @"";
  
  for (int i = 0; i < aData.bullets.count; i++)
  {
    result = [result stringByAppendingString:[NSString stringWithFormat:@"\u2022 %@%@",
                                              [aData.bullets objectAtIndex:i],
                                              (i == aData.bullets.count-1 ? @"" : @"</br></br>")]];
  }
  
  //  [self.textView setFont:[UIFont fontWithName:FONT_NAME size:(IS_PAD ? PAD_FONT_SIZE : PHONE_FONT_SIZE)]];
  
  if (aData.header != nil)
  {
    result = [NSString stringWithFormat:@"%@%@%@", aData.header, (aData.bullets.count != 0 ? @"</br></br>" : @""), result];
  }
  
  result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
  
  result = [NSString stringWithFormat:@"<html> \n"
                                       "<head> \n"
                                       "<style type=\"text/css\"> \n"
                                       "body {font-family: \"%@\"; font-size: %d}\n"
                                       "a:link{text-decoration: none; color: #0074D9;}"
                                       "a:visited{text-decoration: none; color: #0074D9;}"
                                       "a:hover{text-decoration: none; color: #0074D9;}"
                                       "a:active{text-decoration: none; color: #0074D9;}"
                                       "</style> \n"
                                       "</head> \n"
                                       "<body><div id='text'>%@</div></body> \n"
                                       "</html>",
                                       FONT_NAME,
                                       (IS_PAD ? PAD_FONT_SIZE : PHONE_FONT_SIZE),
                                       result];
  
  
  [self loadHTMLString:result baseURL:nil];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{ 
  NSString * url = request.URL.relativeString;
  
  if ([url isEqualToString:@"about:blank"] ||
      [url containsString:@"youtube"])
  {
    return YES;
  }
  
  if ([url hasPrefix:@"project://"])
  {
    NSString * prjName = [[url stringByReplacingOccurrencesOfString:@"project://" withString:@""] stringByRemovingPercentEncoding];
    NSLog(@"%@", prjName);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ProjectDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProjectDetailViewController"];
    NSDictionary * dict = [sharedDC dataForTitle:prjName];
    ProjectCellData * dat = [[ProjectCellData alloc] initWithDictionary:dict];
    [vc setCellData:dat];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [[[self viewController] navigationController] pushViewController:vc animated:YES];
  }
  else if ([url hasPrefix:@"data://"])
  {
    NSString * prjName = [[url stringByReplacingOccurrencesOfString:@"data://" withString:@""] stringByRemovingPercentEncoding];
    NSLog(@"%@", prjName);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSDictionary * dict = [sharedDC dataForTitle:prjName];
    MenuCellData * dat = [[MenuCellData alloc] initWithDictionary:dict];
    [vc setCellData:dat];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [[[self viewController] navigationController] pushViewController:vc animated:YES];
  }
  
  return NO;
}


- (void)commonInit
{
  sharedDC = [DataController sharedDataController];
  self.delegate = self;
}


- (UIViewController*)viewController
{
  for (UIView* next = [self superview]; next; next = next.superview)
  {
    UIResponder* nextResponder = [next nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
      return (UIViewController*)nextResponder;
    }
  }
  
  return nil;
}

@end
