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

#ifndef Nicholas_Trampe_config_h
#define Nicholas_Trampe_config_h

#define IS_PAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_PHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define FONT_NAME @"Futura"
#define PHONE_FONT_SIZE 16
#define PAD_FONT_SIZE 28

#define DATA_DOWNLOADED_NOTIFICATION @"DATA_DOWNLOADED_NOTIFICATION"
#define SERVER_ROOT_DIRECTORY @"http://www.nicholastrampe.com/resume/"
#define SERVER_IMAGE_DIRECTORY [SERVER_ROOT_DIRECTORY stringByAppendingString:@"images/"]
#define SERVER_DATA_FILE [SERVER_ROOT_DIRECTORY stringByAppendingString:@"data.plist"]

#endif
