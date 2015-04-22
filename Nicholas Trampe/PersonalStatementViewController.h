//
//  PersonalStatementViewController.h
//  Nicholas Trampe
//
//  Created by Nicholas Trampe on 4/10/15.
//  Copyright (c) 2015 Nicholas Trampe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController;

@interface PersonalStatementViewController : UIViewController <UIWebViewDelegate>
{
  DataController * sharedDC;
}

@property (weak) IBOutlet UIWebView * webViewStatement;
@property (weak) IBOutlet UIImageView * imageViewBG;

@end
