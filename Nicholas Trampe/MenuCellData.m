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

#import "MenuCellData.h"
#import "config.h"

@implementation MenuCellData
@synthesize title = m_title, details = m_details, header = m_header, bullets = m_bullets;
@synthesize imageNames = m_imageNames;

- (id)initWithTitle:(NSString *)aTitle
            details:(NSString *)aDetails
  descriptionHeader:(NSString *)aDescriptionHeader
 descriptionBullets:(NSArray *)aDescriptionBullets
         imageNames:(NSArray *)aImageNames
{
  self = [super init];
  if (self)
  {
    m_title = aTitle;
    m_details = aDetails;
    m_header = aDescriptionHeader;
    m_bullets = [NSArray arrayWithArray:aDescriptionBullets];
    
    NSMutableArray * images = [NSMutableArray array];
    
    for (NSString * s in aImageNames)
    {
      [images addObject:[NSString stringWithFormat:@"%@%@", SERVER_IMAGE_FOLDER, s]];
    }
    
    m_imageNames = [NSArray arrayWithArray:images];
  }
  return self;
}


- (id)initWithDictionary:(NSDictionary *)aDictionary
{
  NSArray * images = [aDictionary objectForKey:@"Images"];
  
  if (images == nil)
  {
    if ([aDictionary objectForKey:@"Image"] != nil)
    {
      images = [NSArray arrayWithObject:[aDictionary objectForKey:@"Image"]];
    }
  }
  
  return [self initWithTitle:[aDictionary objectForKey:@"Title"]
                     details:[aDictionary objectForKey:@"Details"]
           descriptionHeader:[aDictionary objectForKey:@"Description Header"]
          descriptionBullets:[aDictionary objectForKey:@"Description Bullets"]
                  imageNames:images];
}


- (NSString *)image
{
  if (m_imageNames != nil)
    if (m_imageNames.count > 0)
      return [m_imageNames objectAtIndex:0];
  
  return nil;
}


- (void)setImagesWithFolderName:(NSString *)aFolder
{
  if (aFolder == nil)
    return;
  
  NSString * imagesDir = [[NSBundle mainBundle] pathForResource:aFolder ofType:nil];
  NSArray * contents = [[NSFileManager defaultManager]
                        contentsOfDirectoryAtPath:imagesDir error:nil];
  
  NSMutableArray * ary = [NSMutableArray array];
  
  for (NSString * img in contents)
  {
    [ary addObject:[NSString stringWithFormat:@"%@/%@/%@", SERVER_IMAGE_FOLDER, aFolder, img]];
  }
  
  m_imageNames = [NSArray arrayWithArray:ary];
}


@end
