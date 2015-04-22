//
//  PersonalStatementViewController.m
//  Nicholas Trampe
//
//  Created by Nicholas Trampe on 4/10/15.
//  Copyright (c) 2015 Nicholas Trampe. All rights reserved.
//

#import "PersonalStatementViewController.h"
#import "config.h"
#import "DataController.h"

@interface PersonalStatementViewController ()

@end

@implementation PersonalStatementViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.title = @"Info";
  
  sharedDC = [DataController sharedDataController];
  
  self.webViewStatement.delegate = self;
  self.webViewStatement.backgroundColor = [UIColor clearColor];
  
  self.view.backgroundColor = sharedDC.theme.backgroundColor;
  
  [self.imageViewBG setImage:[sharedDC.theme containerBox]];
  
  MKNetworkEngine* engine = [[MKNetworkEngine alloc] initWithHostName:nil];
  MKNetworkOperation* operation = [engine operationWithURLString:sharedDC.information];
  
  if (operation != nil)
  {
    [engine enqueueOperation:operation];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
//       self.textViewStatement.text = completedOperation.responseString;
       [self.webViewStatement loadHTMLString:completedOperation.responseString baseURL:nil];
     }
                       errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     { 
       DLog(@"%@", [error localizedDescription]);
     }];
  }
  else
  {
    
  }
  
//  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@black.pdf", SERVER_ROOT_DIRECTORY]]];
//  [self.webViewStatement loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{  
  if (![request.URL.relativeString isEqualToString:@"about:blank"] && ![request.URL.relativeString containsString:@"youtube"])
  {
    [[UIApplication sharedApplication] openURL:request.URL];
    
    return NO;
  }
  
  return YES;
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
