//
//  DetailWebView.h
//  Nicholas Trampe
//
//  Created by Nicholas Trampe on 5/31/15.
//  Copyright (c) 2015 Nicholas Trampe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCellData.h"

@class DataController;


@interface DetailWebView : UIWebView <UIWebViewDelegate>
{
  DataController * sharedDC;
  MenuCellData * m_data;
}

- (void)loadHTMLWithData:(MenuCellData *)aData;

@end
