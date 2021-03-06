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
#import "MenuCellData.h"
#import "DetailSlideShowView.h"
#import "DetailWebView.h"

@class DataController;

@interface DetailViewController : UIViewController <DetailSlideShowViewDelegate>
{
  DataController * sharedDC;
  MenuCellData * m_data;
  UIImageView * m_textBG;
  BOOL m_firstView;
}
@property (weak) IBOutlet DetailWebView * webView;
@property (weak) IBOutlet DetailSlideShowView * show;
@property (weak) IBOutlet UIImageView * fullScreenImageView;

- (void)setCellData:(MenuCellData *)aCellData;
- (MenuCellData *)cellData;
- (void)updateUI;

@end
