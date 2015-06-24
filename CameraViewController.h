//
//  CameraViewController.h
//  beenhere
//
//  Created by YA on 2015/6/24.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "CameraAppDelegate.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>


@class ImageFilterBase;
@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
    
    // 負責協調從擷取裝置到輸出間的資料流動
    AVCaptureSession *session;
    
    // 負責即時預覽目前相機設備擷取到的畫面
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    
    // 用來連結資料的輸入埠口(影像)與輸出目標(檔案)
    AVCaptureConnection *videoConnection;
    
    // 前置鏡頭
    AVCaptureDeviceInput *frontFacingCameraDevice;
    
    // 後置鏡頭
    AVCaptureDeviceInput *backFacingCameraDevice;
    
    
}

// 相機畫面
@property (strong, nonatomic) IBOutlet UIView *showView;

// 預覽畫面
@property (strong, nonatomic) IBOutlet UIImageView *previewView;

- (IBAction)cancelButton:(id)sender;

- (IBAction)filterTest:(id)sender;




@end
