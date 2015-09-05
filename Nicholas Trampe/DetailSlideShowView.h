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

#import <UIKit/UIKit.h>

@class DetailSlideShowView;

@protocol DetailSlideShowViewDelegate <NSObject>
@optional
- (void)detailSlideShowView:(DetailSlideShowView *)sender didDisplayImage:(UIImage *)aImage;
- (void)detailSlideShowViewDidDismissImage:(DetailSlideShowView *)sender;

@end

@interface DetailSlideShowView : UIView
{
  NSMutableArray * m_slides; //Detail Slides
  NSMutableArray * m_images; //UIImages
  NSTimer * m_timer;
  
  float m_velocity;
  float m_size;
  BOOL m_dragged;
}
@property (weak) id<DetailSlideShowViewDelegate> delegate;

- (id)initWithImages:(NSArray *)aImages frame:(CGRect)aFrame;

- (void)setImages:(NSArray *)aImages;

- (void)scheduleUpdates;
- (void)stopUpdates;
- (void)update;

@end
