//
//  EditTableViewController.h
//  Nicholas Trampe
//
//  Created by Nicholas Trampe on 1/13/15.
//  Copyright (c) 2015 Nicholas Trampe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController;

@interface EditTableViewController : UITableViewController
{
  DataController * sharedDC;
}

@end
