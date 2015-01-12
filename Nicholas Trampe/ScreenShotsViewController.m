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

#import "ScreenShotsViewController.h"
#import "ShotViewController.h"

@interface ScreenShotsViewController ()

@end

@implementation ScreenShotsViewController

- (id)initWithScreenShots:(NSArray *)aScreenShots
{
  self = [super initWithNibName:@"ScreenShotsViewController" bundle:[NSBundle mainBundle]];
  if (self)
  {
    m_shots = [NSArray arrayWithArray:aScreenShots];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Screenshots";
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
  
  if (m_shots.count > 0)
  {
    NSArray * initialView = [NSMutableArray arrayWithObject:[self shotAtIndex:0]];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    [self.pageController setViewControllers:initialView direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self.pageController setDataSource:self];
    
    self.pageController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60);
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
  }
  
  self.black.alpha = 0.0f;
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.png"]];
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self hideBar:YES];
}


- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
  [self hideBar:!self.navigationController.navigationBarHidden];
}


- (void)hideBar:(BOOL)isHidden afterDelay:(float)aDelay
{
  if (self.navigationController.isNavigationBarHidden == isHidden)
    return;
  
  if (aDelay == 0)
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
  
  [UIView animateWithDuration:0.4f delay:aDelay options:UIViewAnimationOptionAllowAnimatedContent animations:^
  {
    self.black.alpha = (isHidden ? 1.0f : 0.0f);
  }
   completion:^(BOOL finished)
  {
    if (aDelay > 0)
      [self.navigationController setNavigationBarHidden:isHidden animated:YES];
  }];
}


- (void)hideBar:(BOOL)isHidden
{
  [self hideBar:isHidden afterDelay:0.0f];
}


- (ShotViewController *)shotAtIndex:(NSUInteger)aIndex
{
  ShotViewController * s = [[ShotViewController alloc] initWithImageName:[m_shots objectAtIndex:aIndex] andIndex:aIndex];
  return s;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
  NSUInteger index = [(ShotViewController *)viewController index];
  
  if (index == 0)
  {
    return nil;
  }
  
  index--;
  
  return [self shotAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
  NSUInteger index = [(ShotViewController *)viewController index];
  
  index++;
  
  if (index == m_shots.count)
  {
    [self hideBar:NO afterDelay:1.0f];
    return nil;
  }
  
  return [self shotAtIndex:index];
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
  // The number of items reflected in the page indicator.
  return m_shots.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
  // The selected item reflected in the page indicator.
  return 0;
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
