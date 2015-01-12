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

#import "ProjectCellData.h"

@implementation ProjectCellData
@synthesize url = m_url;
@synthesize screenShots = m_shots;

- (id)initWithTitle:(NSString *)aTitle
            details:(NSString *)aDetails
  descriptionHeader:(NSString *)aDescriptionHeader
 descriptionBullets:(NSArray *)aDescriptionBullets
              image:(NSString *)aImage
                url:(NSString *)aURL
        screenShots:(NSArray *)aScreenShots
{
  self = [super initWithTitle:aTitle
                      details:aDetails
            descriptionHeader:aDescriptionHeader
           descriptionBullets:aDescriptionBullets
                   imageNames:[NSArray arrayWithObject:aImage]];
  if (self)
  {
    m_url = aURL;
    m_shots = [NSArray arrayWithArray:aScreenShots];
  }
  return self;
}


- (id)initWithDictionary:(NSDictionary *)aDictionary
{
  self = [super initWithDictionary:aDictionary];
  if (self)
  {
    m_url = [aDictionary objectForKey:@"URL"];
    m_shots = [NSArray arrayWithArray:[aDictionary objectForKey:@"ScreenShots"]];
  }
  return self;
}


@end
