//
//  OverlayViewController.h
//  Yebab
//
//  Created by Virendra on 24/07/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CameraImageDelegate ;
@interface OverlayViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImagePickerController *imagePicker ;
    UIView *customButtonView ;
    BOOL load ;
    BOOL Album ;
    
    id<CameraImageDelegate>delegate ;
    UIImage *image ;
    NSURL *imagePath ;
    NSData *imageData ;
    NSString *fileNames ;
}
@property (nonatomic,retain)UIImage *image ;
@property (nonatomic,retain) NSURL *imagePath ;
@property (nonatomic,retain) NSData *imageData ;
@property (nonatomic,retain) NSString *fileNames ;

@property(nonatomic,retain)id<CameraImageDelegate>delegate ;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,retain)IBOutlet UIView *customButtonView ;
@end

@protocol CameraImageDelegate
- (void)secondViewControllerDidFinish:(OverlayViewController*)overlayViewController;
@end
