//
//  NTTheme.h
//  Nicholas Trampe
//
//  Created by Nicholas Trampe on 1/13/15.
//  Copyright (c) 2015 Nicholas Trampe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTTheme : NSObject
{
  NSString * m_name;
  NSDictionary * m_theme;
}

- (id)initWithThemeName:(NSString *)aThemeName;

- (NSString *)textColorString;
- (UIColor *)textColor;
- (UIColor *)navigationBarColor;
- (NSArray *)buttonColors;
- (UIColor *)backgroundColor;
- (UIImage *)containerBox;
- (UIImage *)placeholder;

@end
