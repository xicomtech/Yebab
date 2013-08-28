//
//  Connections.h
//  HighMagazine
//
//  Created by Sudhanshu Srivastava on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "Globals.h"

@protocol ConnectionsDelegate
//-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data selected:(int)selected;

@optional
-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data selected:(int)selected;
-(void)likeHappinessResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message;
-(void)shareHappinessResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message;
-(void)postCommentHappinessResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message;
-(void)supportCauseResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message;

-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message;
-(void)didRecieveFeatured:(BOOL)isSuccess withData:(id)data;
-(void)didRecieveImage:(int)tag withData:(id)data;
-(void)didUploadDataSize:(float)uploadedData totalDataSize:(float)totalData;
/*
 *  Author:     Sudhanshu Srivastava
 *  Purpose:    To handle response for following actions
 *              1. Like
 *              2. Flag
 *              3. Comment
 *  Date Created:   23 August 2012
 */

@optional
-(void)videoDeleted:(BOOL)isSuccess message:(NSString*)msgStr;
-(void)likeDidRecievedResponse:(BOOL)isSuccess withData:(id)data andMessage:(NSString*)message;;
-(void)flagDidRecievedResponse:(BOOL)isSuccess withData:(id)data;
-(void)commentDidRecievedResponse:(BOOL)isSuccess withData:(id)data;
-(void)addTagDidRecievedResponse:(BOOL)isSuccess withData:(id)data;
@end

@interface Connections : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
    NSURLConnection *connection;
    id<ConnectionsDelegate> delegate;
    NSMutableData *responseData;
    NSString *requestType;
    NSString *_imageName;
    MBProgressHUD *_activityIndicator;
    BOOL dismissLoader;
    int imageTag, selectedSegment;
}
@property (nonatomic, retain, readwrite) NSURLConnection *connection;
@property(nonatomic, retain)id<ConnectionsDelegate> delegate;
@property(nonatomic, retain)NSMutableData *responseData;
@property(nonatomic, retain)NSString *imageName;
@property (nonatomic, retain) NSString *requestType;

@property (nonatomic)  int imageTag, selectedSegment;


- (NSData*)createFormData:(NSDictionary*)myDictionary withBoundary:(NSString*)myBounds;
-(void)sendRequestWithPath:(NSString*)path andParameters:(NSDictionary*)params showLoader:(BOOL)isLoading methodName:(NSString*)methodName;
-(void)sendRequestWithPath:(NSString*)path andParameters:(NSDictionary*)params showLoader:(BOOL)isLoading;
- (void)loadImage:(NSString*)imagePath;
+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (void)dismissGlobalHUD;
-(void)cancelConnection;    //  25Oct2012 Sudhanshu Srivastava
-(NSDictionary *)sendHttpRequest:(NSString *)url postParameter:(NSDictionary *)postParameter;

@end

/*
@protocol ConnectionsDelegate
-(void)connectionDidRecievedResponse:(BOOL)isSuccess withData:(id)data;
@end
*/