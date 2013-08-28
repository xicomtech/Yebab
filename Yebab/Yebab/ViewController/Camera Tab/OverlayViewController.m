//
//  OverlayViewController.m
//  Yebab
//
//  Created by Virendra on 24/07/13.
//  Copyright (c) 2013 utkarsh goel. All rights reserved.
//

#import "OverlayViewController.h"

@interface OverlayViewController ()

@end

@implementation OverlayViewController
@synthesize  customButtonView ,delegate,image,imagePath,imageData,fileNames;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412
    
if (!load) {
            if (!Album) {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    imagePicker  = [[UIImagePickerController alloc] init];
                    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = YES;
                    imagePicker.delegate = self;
                    imagePicker.cameraViewTransform =CGAffineTransformScale(imagePicker.cameraViewTransform,
                                                                CAMERA_TRANSFORM_X,
                                                                CAMERA_TRANSFORM_Y);
                    imagePicker.showsCameraControls = NO;
                    imagePicker.navigationBarHidden = YES;
        
                    imagePicker.wantsFullScreenLayout = YES;
                    
                    //changes done on 1 Feb 2013//
                    CGRect screenBounds = [[UIScreen mainScreen] bounds];
                    CGFloat screenScale = [[UIScreen mainScreen] scale];
                    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
                    NSLog(@"width:%f ,height:%f",screenSize.width,screenSize.height);
                    
                    if(screenSize.height > 480)
                    {
                        if(self.view.frame.size.height > 480)
                        {
                    customButtonView.frame=CGRectMake(0,480, customButtonView.frame.size.width, customButtonView.frame.size.height);
                        }
                        else{
                            customButtonView.frame=CGRectMake(0,400, customButtonView.frame.size.width, customButtonView.frame.size.height);
                        }
                    }
                    else{
                         customButtonView.frame=CGRectMake(0,400, customButtonView.frame.size.width, customButtonView.frame.size.height);
                    }
                    imagePicker.cameraOverlayView = customButtonView;
        
                    [self presentViewController:imagePicker animated:YES completion:nil];
                    
                    
                    load =YES;
                }
            }else{
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    picker.allowsEditing = YES;
                    picker.delegate = self;
                    [self.navigationController presentViewController:picker animated:YES completion:nil];
                        load=YES ;
                
            }
}
else{
        [self.navigationController dismissModalViewControllerAnimated:YES ];
        
}
}



-(IBAction)openAlbum:(id)sender{
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
////        imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        imagePicker.allowsEditing = YES;
//        imagePicker.delegate = self;
//        [self dismissModalViewControllerAnimated:YES];
//    }
    Album=YES ;
    load=NO;
    
    [self removeView];
    //[self backBtnClick:nil];
    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        picker.allowsEditing = YES;
//        picker.delegate = self;
//        [self.navigationController presentViewController:picker animated:YES completion:nil];
//    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    load=YES;
    Album=NO;
    
	[picker dismissModalViewControllerAnimated:YES];
    
    NSLog(@"info = %@",info);
    
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:@"public.image"])	
	{
        image=[[UIImage alloc]init];
		image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
       		
        fileNames = [[NSString alloc] init];
        
        if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
            fileNames = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            
            fileNames = [self getFileName:fileNames];
            NSLog(@"info = %@",fileNames);
            
           imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
           imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0);
            
        }
    }
  [delegate secondViewControllerDidFinish:self];
}

-(NSString *)getFileName:(NSString *)fileName
{
	NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
	NSString *suffix = [temp lastObject];
	
	temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
	
	NSString *name = [temp lastObject];
	
	name = [name stringByAppendingFormat:@".%@",suffix];
	return name;
}

-(IBAction)startCamera:(id)sender
{
    [imagePicker takePicture];
    
//	UIImagePickerController *camera = [[UIImagePickerController alloc] init];
//	camera.delegate = self;
//	camera.allowsEditing = YES;
//	
//	//检查摄像头是否支持摄像机模式
//	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//	{
//		camera.sourceType = UIImagePickerControllerSourceTypeCamera;
//		camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//	}
//	else
//	{
//		NSLog(@"Camera not exist");
//		return;
//	}
//    
//   	[self presentModalViewController:camera animated:YES];
}




//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    NSLog(@"%@ selected",image);
////    self.imgView.image = image;
//    //    addButton.titleLabel.text=@"";
//    [self dismissModalViewControllerAnimated:YES];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClick:(id)sender{
 //   [imagePicker dismissModalViewControllerAnimated:YES];
//    [self imagePickerControllerDidCancel:imagePicker];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissModalViewControllerAnimated:YES ];
}
-(void)removeView{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissModalViewControllerAnimated:YES ];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    Album=NO;
    [self.navigationController dismissModalViewControllerAnimated:YES ];
}

@end
