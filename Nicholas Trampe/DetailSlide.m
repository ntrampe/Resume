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

//#import <QuartzCore/QuartzCore.h>

#import "DetailSlide.h"
#import "DataController.h"
#import "MKNetworkKit/MKNetworkKit.h"

@interface DetailSlide (Private)

- (void)adjustFrame:(CGRect)aFrame;
- (void)addBackground;

@end

@implementation DetailSlide

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    [self setOffset:10];
  }
  return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    [self setOffset:10];
  }
  return self;
}


- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self adjustFrame:self.frame];
}


- (void)setImageURLString:(NSString *)aURLString
{
  [m_image setImageFromURL:[NSURL URLWithString:aURLString] placeHolderImage:[[[DataController sharedDataController] theme] placeholder] animation:YES];
}


- (void)setImage:(UIImage *)aImage
{
  [m_image setImage:aImage];
  
  //loading the image in the background caused deleting a thread with an uncommitted CATransaction
  //only when scrolling rapidly
  //[s.image performSelectorInBackground:@selector(setImage:) withObject:[m_images objectAtIndex:s.index]];
}


- (void)setOffset:(float)aOffset
{
  m_offset = aOffset;
  
  [self adjustFrame:self.frame];
}


- (void)addBackground
{
  //Quartz2D can make scrolling slow on older devices
  /*
   [self.layer setBorderWidth:5];
   [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
   [self.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
   [self.layer setShadowRadius:2.0];
   [self.layer setShadowOpacity:0.5];
   
   self.backgroundColor = [UIColor whiteColor];
   */
  
  if (m_bg == nil)
  {
    m_bg = [[UIImageView alloc] initWithImage:[[[DataController sharedDataController] theme] containerBox]];
    [self addSubview:m_bg];
    [self sendSubviewToBack:m_bg];
  }
  
  m_bg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  m_bg.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
  
  self.backgroundColor = [UIColor clearColor];
}


- (void)adjustFrame:(CGRect)aFrame
{
  if (m_image == nil)
  {
    m_image = [[UIImageView alloc] initWithFrame:aFrame];
    [self addSubview:m_image];
  }
  
  [self addBackground];
  
  //top, left, bottom, right
  UIEdgeInsets offset = UIEdgeInsetsMake(m_offset + 3, m_offset + 3, m_offset + 6, m_offset + 6);
  
  m_image.contentMode = UIViewContentModeScaleAspectFit;
  m_image.frame = CGRectMake(offset.left, offset.top, self.frame.size.width - offset.right*2, self.frame.size.height - offset.bottom*2);
}


@end
