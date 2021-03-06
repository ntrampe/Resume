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

typedef NS_OPTIONS(NSUInteger, ProjectStatus)
{
  ProjectAppStoreAvailable      = (1 << 0), 
  ProjectInstallAvailable       = (1 << 1), 
  ProjectGitHubAvailable        = (1 << 2), 
  ProjectScreenshotsAvailable   = (1 << 3) 
};


@interface ProjectCellData : MenuCellData
{
  NSString * m_url;
  NSString * m_scheme;
  NSString * m_github;
  NSArray * m_shots;
}
@property (strong, nonatomic) NSString * url, * scheme, * github;
@property (strong, nonatomic) NSArray * screenShots;

- (id)initWithTitle:(NSString *)aTitle
            details:(NSString *)aDetails
  descriptionHeader:(NSString *)aDescriptionHeader
 descriptionBullets:(NSArray *)aDescriptionBullets
              image:(NSString *)aImage
                url:(NSString *)aURL
             scheme:(NSString *)aScheme
             github:(NSString *)aGithub
        screenShots:(NSArray *)aScreenShots;


- (NSURL *)appScheme;
- (BOOL)isAppInstalled;

- (ProjectStatus)status;

@end
