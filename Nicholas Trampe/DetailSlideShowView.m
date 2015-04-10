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

#import "DetailSlideShowView.h"
#import "DetailSlide.h"

@interface DetailSlideShowView (Private)

- (void)addDistance:(float)aDistance;

@end

@implementation DetailSlideShowView

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    m_slides = [NSMutableArray array];
    
    m_velocity = 0;
  }
  return self;
}

- (id)initWithImages:(NSArray *)aImages frame:(CGRect)aFrame
{
  self = [super initWithFrame:aFrame];
  if (self)
  {
    m_slides = [NSMutableArray array];
    
    m_velocity = 0;
    
    [self setImages:aImages];
  }
  return self;
}


- (void)setImages:(NSArray *)aImages
{
  m_images = [NSMutableArray arrayWithArray:aImages];
  m_size = self.frame.size.height;
  
  int nSlides = 0;
  float dist = 0;
  
  while (dist < self.frame.size.width + m_size*4 && nSlides < m_images.count)
  {
    dist += m_size;
    nSlides++;
  }
  
  for (int i = 0; i < nSlides; i++)
  {
    DetailSlide * s = [[DetailSlide alloc] initWithFrame:CGRectMake((m_images.count == 1 ? (self.frame.size.width - m_size) / 2.0f : 0) + m_size*i, 0, m_size, m_size)];
    [s setImageURLString:[m_images objectAtIndex:i]];
    s.index = i;
    [self addSubview:s];
    [m_slides addObject:s];
  }
  
  self.userInteractionEnabled = (m_images.count > 1);
}


- (void)scheduleUpdates
{
  if (m_timer != nil || m_images.count <= 1)
    return;
  
  m_timer = [NSTimer scheduledTimerWithTimeInterval:0.003f
                                   target:self
                                 selector:@selector(update)
                                 userInfo:nil
                                  repeats:YES];
}


- (void)stopUpdates
{
  if (m_timer != nil)
  {
    if ([m_timer isValid])
    {
      [m_timer invalidate];
      m_timer = nil;
    }
  }
  
  m_velocity = 0.0f;
}


- (void)update
{
  float vel = -0.2;
  float damping = MAX(fabsf(m_velocity + vel) / 100.0f, 0.01);
  
  if (m_velocity < vel - damping)
  {
    m_velocity += damping;
  }
  else if (m_velocity > vel + damping)
  {
    m_velocity -= damping;
  }
  
  [self addDistance:m_velocity];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self stopUpdates];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch * touch =     [touches anyObject];
  float location =      [touch locationInView:touch.view].x;
  float prevLocation =  [touch previousLocationInView:touch.view].x;
  float dist = location - prevLocation;
  
  m_velocity = dist*0.2;
  
  [self addDistance:dist];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self scheduleUpdates];
}


- (void)addDistance:(float)aDistance
{
  //ignore small distances
  if (fabsf(aDistance) < 0.1)
    return;
  
  BOOL load;
  
  for (DetailSlide * s in m_slides)
  {
    s.center = CGPointMake(s.center.x + aDistance, s.center.y);
    load = YES;
    
    if (s.center.x < - m_size && aDistance < 0)
    {
      s.center = CGPointMake(s.center.x + m_size*(m_slides.count), s.center.y);
      
      s.index = s.index + (int)m_slides.count;
      
      if (s.index >= m_images.count)
      {
        s.index = s.index - (int)m_images.count;
      }
    }
    else if (s.center.x > self.frame.size.width + m_size && aDistance > 0)
    {
      s.center = CGPointMake(s.center.x - m_size*(m_slides.count), s.center.y);
      
      s.index = s.index - (int)m_slides.count;
      
      if (s.index < 0)
      {
        s.index = (int)m_images.count + s.index;
      }
    }
    else
    {
      load = NO;
    }
    
    if (load)
    {
      [s setImageURLString:[m_images objectAtIndex:s.index]];
    }
  }
}


@end
