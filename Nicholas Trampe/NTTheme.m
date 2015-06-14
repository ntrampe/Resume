//
//  NTTheme.m
//  Nicholas Trampe
//
//  Created by Nicholas Trampe on 1/13/15.
//  Copyright (c) 2015 Nicholas Trampe. All rights reserved.
//

#import "NTTheme.h"

@interface NTTheme (Private)

- (UIColor *)colorFromString:(NSString *)aString;
- (NSString *)pathForThemeFile:(NSString *)aFile;

@end

@implementation NTTheme

- (id)initWithThemeName:(NSString *)aThemeName
{
  self = [super init];
  if (self)
  {
    m_name = aThemeName;
    NSString * themePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"themes/%@/theme", aThemeName] ofType:@"plist"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:themePath];
    m_theme = [NSMutableDictionary dictionaryWithDictionary:dict];
  }
  return self;
}


- (NSString *)textColorString
{
  return [m_theme objectForKey:@"Text Color"];
}


- (UIColor *)textColor
{
  NSString * c = [self textColorString];
  if (c != nil)
    return [self colorFromString:c];
  return [UIColor blackColor];
}


- (UIColor *)navigationBarColor
{
  NSString * c = [m_theme objectForKey:@"Navigation Bar Color"];
  if (c != nil)
    return [self colorFromString:c];
  return [UIColor blackColor];
}


- (NSArray *)buttonColors
{
  NSMutableArray * res = [NSMutableArray array];
  NSArray * strings = [m_theme objectForKey:@"Button Colors"];
  
  if (strings != nil)
  {
    for (NSString * s in strings)
    {
      [res addObject:[self colorFromString:s]];
    }
  }
  else
  {
    for (int i = 0; i < 4; i++)
    {
      [res addObject:[UIColor blackColor]];
    }
  }
  
  return res;
}


- (UIColor *)backgroundColor
{
  NSString * c = [m_theme objectForKey:@"Background Color"];
  
  if (c != nil)
    return [self colorFromString:c];
  
  return [UIColor colorWithPatternImage:[UIImage imageNamed:[self pathForThemeFile:@"bg_texture.png"]]];
  
  //return [UIColor blackColor];
}


- (UIImage *)containerBox
{
  return [[UIImage imageNamed:[self pathForThemeFile:@"containerbox.png"]] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
}


- (UIImage *)placeholder
{
  return [UIImage imageNamed:[self pathForThemeFile:@"placeholder.png"]];
}


- (UIColor *)colorFromString:(NSString *)aString
{
  NSArray * components = [aString componentsSeparatedByString:@", "];
  return [UIColor colorWithRed:[[components objectAtIndex:0] floatValue] / 255.0f
                         green:[[components objectAtIndex:1] floatValue] / 255.0f
                          blue:[[components objectAtIndex:2] floatValue] / 255.0f
                         alpha:1.0f];
}


- (NSString *)pathForThemeFile:(NSString *)aFile
{
  return [NSString stringWithFormat:@"themes/%@/%@", m_name, aFile];
}


@end
