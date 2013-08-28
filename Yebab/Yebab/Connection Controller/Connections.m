//
//  Connections.m
//  HighMagazine
//
//  Created by xicom on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Connections.h"
#import "JSON.h"
//#import "TokenGenerator.h"
#import "commonFunction.h"

NSString *USER_ID;
int selectedSegment;

@interface Connections(HM)
-(void)saveImage;
@end 


@implementation Connections
@synthesize connection;
@synthesize delegate;
@synthesize responseData;
@synthesize imageName=_imageName;
@synthesize requestType;
@synthesize  selectedSegment;
@synthesize imageTag;

-(id)init
{
	if (self=[super init]) {
        self.responseData = [[NSMutableData alloc] init];
	}
	return self;
}
-(void)sendRequestWithPath:(NSString*)path andParameters:(NSDictionary*)params showLoader:(BOOL)isLoading{
    if (isLoading) {
        //NSLog(@"showLoader");
        [Connections showGlobalProgressHUDWithTitle:@"Loading..."];
    }else {
        //NSLog(@"don't show loader");
    }
    //NSLog(@"params: %@",params);
    requestType = path;
    dismissLoader = isLoading;
    NSLog(@"host url: %@",HOST_URL);
    NSLog(@"path:%@",path);
    
    NSString *urlPath = [HOST_URL stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:urlPath];
//    NSURL *url = [NSURL URLWithString:@"http://demo.xicom.us/defindme/www/webservices/users/test_photo/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:800];
    

    NSMutableDictionary *mutable_params = [NSMutableDictionary dictionaryWithDictionary:params];
    
    
    NSString *myBounds = @"1234";
    NSData *myPostData = [self createFormData:mutable_params withBoundary:myBounds];
    [request setHTTPMethod: @"POST"];
    NSString *myContent = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", myBounds];
    [request setValue:myContent forHTTPHeaderField:@"Content-type"];	
    [request setHTTPBody:myPostData];

    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setValue:[NSString stringWithFormat:@"%d",[myPostData length]] forHTTPHeaderField:@"Content-Length"];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];   
}



-(void)sendRequestWithPath:(NSString*)path andParameters:(NSDictionary*)params showLoader:(BOOL)isLoading methodName:(NSString*)methodName
{
    if (isLoading)
        {
            [Connections showGlobalProgressHUDWithTitle:@"Loading..."];
            }
    
    requestType = path;
    dismissLoader = isLoading;
    
//    NSString *urlPath = [kBaseURL stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSLog(@"***********************************************");
    NSLog(@"URL :%@",url);
    NSLog(@"Request Parameters : %@",params);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:800];
    
    if ([path rangeOfString:@"get_group_list_data_2.json"].location != NSNotFound) {
        requestType = @"FEATURED";
        }
    
    NSMutableDictionary *mutable_params = [NSMutableDictionary dictionaryWithDictionary:params];
//    NSString *token = [[TokenGenerator sharedController] getApiTokenForMethod:path withParamsDictionary:nil];
//    [mutable_params setObject:token forKey:@"token"];
//    [mutable_params setObject:TIME_STAMP forKey:@"timestamp"];
    
    NSString *myBounds = @"1234";
    NSData *myPostData = [self createFormData:mutable_params withBoundary:myBounds];
    [request setHTTPMethod: @"POST"];
    NSString *myContent = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", myBounds];
    [request setValue:myContent forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:myPostData];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setValue:[NSString stringWithFormat:@"%d",[myPostData length]] forHTTPHeaderField:@"Content-Length"];
 //   connection = (NSConnection*)[[NSConnection alloc] initWithRequest:request delegate:self];
     connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
    
    
    
}



/*
 Download and cache image for the article
 */
-(void)loadImage:(NSString*)imagePath{
    requestType = @"CACHEIMAGE";
    dismissLoader = NO;
    self.imageName = [imagePath lastPathComponent];
    NSURL *url = [NSURL URLWithString:imagePath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)saveImage{
    //NSLog(@"saveImage");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheImgDir = [documentDir stringByAppendingPathComponent:@"ArticleImages"];
    if (![fileManager fileExistsAtPath:cacheImgDir]) {
        [fileManager createDirectoryAtPath:cacheImgDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if (![fileManager fileExistsAtPath:[cacheImgDir stringByAppendingPathComponent:self.imageName]]) {
        [fileManager createFileAtPath:[cacheImgDir stringByAppendingPathComponent:self.imageName] contents:self.responseData attributes:nil];
    }     
}

// To create form data from the dictionary.
- (NSData*)createFormData:(NSDictionary*)myDictionary withBoundary:(NSString*)myBounds {
    
    //NSMutableData *myReturn = [[[NSMutableData alloc] initWithCapacity:10] autorelease];// ARC
    NSMutableData *myReturn = [[NSMutableData alloc] initWithCapacity:10];
    NSArray *formKeys = [myDictionary allKeys];
    for (int i = 0; i < [formKeys count]; i++) {
        if ([[formKeys objectAtIndex:i] hasSuffix:@"file"]) {
            NSData *imageData = UIImageJPEGRepresentation([myDictionary objectForKey:[formKeys objectAtIndex:i]], 90);
            [myReturn appendData:[[NSString stringWithFormat:@"--%@\r\n", myBounds] dataUsingEncoding:NSUTF8StringEncoding]];
            [myReturn appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"image\"; filename=\"%@.jpg\"\r\n",USER_ID]dataUsingEncoding:NSUTF8StringEncoding]];
            [myReturn appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

            [myReturn appendData:[NSData dataWithData:imageData]];
            [myReturn appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [myReturn appendData:[[NSString stringWithFormat:@"--%@--\n",myBounds] dataUsingEncoding:NSASCIIStringEncoding]];
        }
        else if ([[formKeys objectAtIndex:i] hasSuffix:@"video"])
        {
            NSURL *videoURL = [NSURL fileURLWithPath:[myDictionary objectForKey:[formKeys objectAtIndex:i]]];

            NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
            [myReturn appendData:[[NSString stringWithFormat:@"--%@\r\n", myBounds] dataUsingEncoding:NSUTF8StringEncoding]];
            [myReturn appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"video\"; filename=\"%@.MOV\"\r\n",USER_ID]dataUsingEncoding:NSUTF8StringEncoding]];
                            
            [myReturn appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                            
            [myReturn appendData:[NSData dataWithData:videoData]];
            [myReturn appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [myReturn appendData:[[NSString stringWithFormat:@"--%@--\n",myBounds] dataUsingEncoding:NSASCIIStringEncoding]];
        }
        else
        {
            [myReturn appendData:[[NSString stringWithFormat:@"--%@\n",myBounds] dataUsingEncoding:NSASCIIStringEncoding]]; 
            [myReturn appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\n\n%@\n",[formKeys objectAtIndex:i],[myDictionary valueForKey:[formKeys objectAtIndex:i]]] dataUsingEncoding:NSASCIIStringEncoding]];
            [myReturn appendData:[[NSString stringWithFormat:@"--%@--\n",myBounds] dataUsingEncoding:NSASCIIStringEncoding]];
        }        
    }    
    return myReturn;
}
+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = @"Please Wait";
    hud.detailsLabelText = title;
    return hud;
}

+ (void)dismissGlobalHUD {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

//  25Oct2012 Sudhanshu Srivastava
-(void)cancelConnection{
    [connection cancel];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [Connections dismissGlobalHUD];
    NSLog(@"error: %@", [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);    
    
    NSString *fileExtension = [[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey] pathExtension];
    NSArray *imgExtensions = [NSArray arrayWithObjects:@"png", @"jpg", @"jpeg", @"gif", nil];
    BOOL showAlert = ([imgExtensions containsObject:fileExtension] || [requestType isEqualToString:@"users/get_apns_badge_count.json"])?NO:YES;
    if (showAlert) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failure!" message:@"There was an error while connecting to server. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
/*
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection; 
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

// Deprecated authentication delegates.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
*/
#pragma mark -
#pragma mark NSURLConnectionDataDelegate
/*
-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
}
*/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
    
}
/*
- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request{

}
 */
- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    if ([(id)self.delegate respondsToSelector:@selector(didUploadDataSize:totalDataSize:)]) {
        float progress = [[NSNumber numberWithInteger:totalBytesWritten] floatValue];
        float total = [[NSNumber numberWithInteger: totalBytesExpectedToWrite] floatValue];
        [self.delegate didUploadDataSize:progress totalDataSize:total];
    }
}
/*
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
}
*/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (dismissLoader) {
        [Connections dismissGlobalHUD];
    }
    
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
   // NSString * newString = [responseString substringWithRange:NSMakeRange(4783, 10)];

    NSLog(@"respnseString: %@",responseString);
    if ([requestType isEqualToString:@"CACHEIMAGE"]) {
        [self.delegate didRecieveImage:self.imageTag withData:self.responseData];
    }else{
        NSError *error;
        NSDictionary *responseDic; 
        int iOSVersion = [[[UIDevice currentDevice] systemVersion] intValue];
        if (iOSVersion >= 5.0) {
            responseDic = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
            if (error !=nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:[error debugDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
        }else{
            NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
            SBJSON *parser = [[SBJSON alloc]init];
            responseDic = [parser objectWithString:responseString error:&error];
        }
        if (responseDic == nil) {
            [Connections dismissGlobalHUD];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if ([[responseDic objectForKey:@"isSuccess"] intValue]) {
            if ([requestType isEqualToString:LIKE] || [requestType isEqualToString:UNLIKE]) {
                [self.delegate likeDidRecievedResponse:YES withData:[responseDic objectForKey:@"data"] andMessage:[responseDic objectForKey:@"message"]];
            }else{
                [self.delegate connectionDidRecievedResponse:YES withData:[responseDic objectForKey:@"data"] andMessage:[responseDic objectForKey:@"message"]];
            }
        }else{
            if ([requestType isEqualToString:LIKE] || [requestType isEqualToString:UNLIKE]) {
                [self.delegate likeDidRecievedResponse:NO withData:[responseDic objectForKey:@"data"] andMessage:[responseDic objectForKey:@"message"]];
            }else{
                
                // First, get all the keys in the response
                
                NSArray *responseKeys = [responseDic allKeys];
                
                // Now see if the array contains the key you are looking for
                
                BOOL isErrorResponse = [responseKeys containsObject:@"data"];
                if (isErrorResponse) {
                    [self.delegate connectionDidRecievedResponse:NO withData:[responseDic objectForKey:@"data"] andMessage:[responseDic objectForKey:@"message"]];
                }
                else {
                    [self.delegate connectionDidRecievedResponse:NO withData:responseDic andMessage:nil];
                }

                
            }
        }
    } 
}
/*
 *@sendHttpRequest
 * @argument:
 *		url: Url of the server.
 *		postParameter: parameters of the url.
 *
 * Sending HTTP request to server
 * return type NSDictionary.
 */

-(NSDictionary *)sendHttpRequest:(NSString *)url postParameter:(NSDictionary *)postParameter{
	
	NSDictionary *info = [[NSDictionary alloc]init];
	
    NSString *post = [postParameter objectForKey:@"postData"];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding ];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *method = [postParameter objectForKey:@"method"];
    
    if (method == NULL ||[method isEqualToString:@"GET"]) {
        url =[NSString stringWithFormat:@"%@%@",url,post];
        [request setURL:[NSURL URLWithString:url]];
    }
    else {
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:method];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        if ([[postParameter objectForKey:@"httpHeader"] isEqualToString:@"json"]) {
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        else {
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
        
        [request setHTTPBody:postData];
    }
    // Parsing Json response
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // NSString *json_string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode] == 200 || httpResponse == NULL) {
        info = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
    }
    
	return info;
	
}


@end
