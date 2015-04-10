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

#import "DataController.h"
#import "config.h"

@interface DataController (Private) 

- (void)initController;

- (NSString *)filePath;
- (NSString *)themePath;
- (NSString *)documentsPath;

- (UIColor *)colorFromString:(NSString *)aString;

@end

@implementation DataController
@synthesize data = m_data;
@synthesize theme = m_theme;

#pragma mark -
#pragma mark Init


- (id)init
{
  self = [super init];
  if (self)
  {
    [self initController];
  }
  
  return self;
}


- (void)initController
{
  //load the data when the app starts
  [self loadData];
  
  self.networkEngine = [[MKNetworkEngine alloc] init];
  [self.networkEngine useCache];
  [self.networkEngine emptyCache];
  [UIImageView setDefaultEngine:self.networkEngine];
}


#pragma mark -
#pragma mark Private


- (NSString *)filePath
{
  if ([[NSFileManager defaultManager] fileExistsAtPath:self.documentsPath])
  {
    return self.documentsPath;
  }
  
  return [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
}


- (NSString *)themePath
{
  return [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
}


- (NSString *)documentsPath
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
  
  return documentsPath;
}


#pragma mark -
#pragma mark Data Getters


- (NSString *)name
{
  return [self.data objectForKey:@"Name"];
}


- (NSString *)picture
{
  return [NSString stringWithFormat:@"%@%@", SERVER_IMAGE_DIRECTORY, [self.data objectForKey:@"Picture"]];
}


- (NSArray *)projects
{
  return [self.data objectForKey:@"Projects"];
}


- (NSArray *)educationalBackgrounds
{
  return [self.data objectForKey:@"Educational Background"];
}


- (NSArray *)professionalBackgrounds
{
  return [self.data objectForKey:@"Professional Background"];
}


- (NSArray *)technicalSkills
{
  return [self.data objectForKey:@"Technical Skills"];
}


- (NSArray *)interests
{
  return [self.data objectForKey:@"Interests"];
}


#pragma mark -
#pragma mark Theme Getters


- (void)loadTheme:(NSString *)aThemeName
{
  m_theme = [[NTTheme alloc] initWithThemeName:aThemeName];
}


+ (BOOL)hasInternetAccess
{
  struct sockaddr_in zeroAddress;
  bzero(&zeroAddress, sizeof(zeroAddress));
  zeroAddress.sin_len = sizeof(zeroAddress);
  zeroAddress.sin_family = AF_INET;
  SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
  SCNetworkReachabilityFlags flags = 0;
  BOOL reachable = SCNetworkReachabilityGetFlags(reachability, &flags);
  CFRelease(reachability);
  return reachable && (flags & kSCNetworkFlagsReachable);
}


+ (BOOL)canReachData
{
  NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:SERVER_DATA_FILE]];
  NSURLResponse* response = nil;
  NSInteger httpStatus = -1;
  
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
  
  httpStatus = [((NSHTTPURLResponse *)response) statusCode];
  
  return (httpStatus != 404);
}


- (void)downloadData
{
  if (![DataController hasInternetAccess])
  {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You do not have internet access!\nIn order to download current information, you need to be connected to the internet." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    
    return;
  }
  
  if (![DataController canReachData])
  {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"The server isn't reachable at the moment.\nYou may not have current information." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    
    return;
  }
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:self.documentsPath])
  {
    [[NSFileManager defaultManager] removeItemAtPath:self.documentsPath error:nil];
  }
  
  MKNetworkEngine* engine = [[MKNetworkEngine alloc] initWithHostName:nil];
  MKNetworkOperation* operation = [engine operationWithURLString:SERVER_DATA_FILE];
  [operation addDownloadStream:[NSOutputStream outputStreamToFileAtPath:self.documentsPath
                                                          append:YES]];
  
  [engine enqueueOperation:operation];
  
  [operation onDownloadProgressChanged:^(double progress)
  {
    DLog(@"%.2f", progress*100.0);
  }];
  
  [operation addCompletionHandler:^(MKNetworkOperation *completedOperation)
  {
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DATA_DOWNLOADED_NOTIFICATION object:[NSData dataWithContentsOfFile:self.documentsPath]];
  }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
  { 
    DLog(@"%@", [error localizedDescription]);
  }];
}


#pragma mark -
#pragma mark Data Functions


- (void)loadData
{
  NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];
  m_data = [NSMutableDictionary dictionaryWithDictionary:dict];
  
  [self loadTheme:@"Default"];
}


#pragma mark -
#pragma mark Singleton


static DataController *sharedDataController = nil;


+ (DataController *)sharedDataController
{ 
	@synchronized(self) 
	{ 
		if (sharedDataController == nil) 
		{ 
			sharedDataController = [[self alloc] init]; 
		} 
	} 
  
	return sharedDataController; 
} 


+ (id)allocWithZone:(NSZone *)zone 
{ 
	@synchronized(self) 
	{ 
		if (sharedDataController == nil) 
		{ 
			sharedDataController = [super allocWithZone:zone]; 
			return sharedDataController; 
		} 
	} 
  
	return nil; 
}


@end
