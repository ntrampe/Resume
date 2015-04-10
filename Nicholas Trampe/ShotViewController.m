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

#import "ShotViewController.h"
#import "config.h"

@interface ShotViewController ()

@end

@implementation ShotViewController
@synthesize index = m_index;

- (id)initWithImageName:(NSString *)aImageName andIndex:(NSUInteger)aIndex
{
  self = [super initWithNibName:@"ShotViewController" bundle:[NSBundle mainBundle]];
  if (self)
  {
    m_imageName = aImageName;
    m_index = aIndex;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
//  [self.image setImage:[UIImage imageNamed:m_imageName]];
  [self.image setImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_IMAGE_DIRECTORY, m_imageName]] placeHolderImage:nil animation:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
