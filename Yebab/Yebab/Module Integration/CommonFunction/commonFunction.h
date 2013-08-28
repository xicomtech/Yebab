//
//  commonFunction.h
//  shareHappiness
//
//  Created by Xicom on 12/02/13.
//  Copyright (c) 2013 Xicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreMedia/CoreMedia.h>
#import "DMTwitter.h"
#import "Globals.h"
//#import "MTStatusBarOverlay.h"
#import "Connections.h"

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>


@protocol LoginDelegate
@optional
-(void)validateUserAccount:(NSDictionary*)user;
@end


@interface commonFunction : NSObject<ConnectionsDelegate,/*MTStatusBarOverlayDelegate,*/UIAlertViewDelegate>{
    id<LoginDelegate> delegate;
    FBRequest *request;
   // MTStatusBarOverlay *overlay;
    NSString *mediaType;
}
@property(nonatomic, retain)id<LoginDelegate> delegate;
+ (commonFunction*)commonFun;
- (void)fbLogin;
+ (NSString *) readableCurrentLoginStatus:(DMOTwitterLoginStatus) cstatus;
- (void)twitterLogin:(UIViewController *)controller;
+(BOOL)isValidString:(NSString *)text;
+(BOOL)validateEmail:(NSString *)email;
//+(BOOL) validateUrl:(NSString *)candidate;
+(BOOL)isValidUsername:(NSString *)text;
+(NSDictionary*)formatUserDic:(NSDictionary*)userDic;

+(void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString*)message andDelegate:(id)object;
@end
