//
//  CameraViewController.m
//  beenhere
//
//  Created by YA on 2015/6/24.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "CameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraViewController () {
    ALAssetsLibrary *imageLibrary; //讀取照片
    NSMutableArray *imageArray; //儲存取出的照片
}

@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIButton *pickFromAlbum;
@property (strong, nonatomic) IBOutlet UIButton *flashButton;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView =
        [[UIAlertView alloc] initWithTitle:@"Error!"
                                   message:@"Device has no camera."
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles: nil];
        [myAlertView show];
    }
    
    // 前後鏡頭設定，初始化協調器session
    session = [AVCaptureSession new];
    
    // 設定未來擷取的畫面品質(最高品質)，其它的參數通常用在錄影，例如VGA品質 AVCaptureSessionPreset 640x480
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        
        // 如果相機有前置與後置鏡頭，要後置鏡頭
        if ([device position] == AVCaptureDevicePositionBack) {
            
            // 將後置鏡頭設定為session資料來源
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            [session addInput:input];
            
            // 設定session的輸出端為StillImage(靜態圖片)，格式為JPEG
            AVCaptureStillImageOutput *output = [AVCaptureStillImageOutput new];
            NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
            [output setOutputSettings:outputSettings];
            [session addOutput:output];
            
            // 運用layer的方式將鏡頭目前看到的影像即時顯示到view元件上
            captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
            captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.showView.layer addSublayer:captureVideoPreviewLayer];
            
            // 儲存後置鏡頭資料
            backFacingCameraDevice = input;
        }
        if ([device position] == AVCaptureDevicePositionFront) {
            
            // 儲存前鏡頭資料
            frontFacingCameraDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        }
    }
    
    
    // —————————— 一次取得相本中所有照片 START ——————————
    // 非同步(使用另一執行緒)讀取照片
    imageLibrary = [[ALAssetsLibrary alloc] init];
    
    // 取得相簿照片，使用參數:ALAssetsGroupSavedPhotos取出所有照片
    [imageLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        if (group != nil) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result,NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    [tempArray addObject:result];
                }
            }];
            
            // 保存結果
            imageArray = [tempArray copy];
            //NSLog(@"取出照片共 %ld 張",(unsigned long)[imageArray count]);
        }
        // 讀取照片失敗
    } failureBlock:^(NSError *error) {
    }];
    // —————————— 一次取得相本中所有照片 END ——————————
    
    // 讀取原始照片並轉換為UIImage格式
    CIImage *inputImg = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"%@"]];
    
    // 將圖片套用黑白濾鏡
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setDefaults];
    [filter setValue:inputImg forKey:kCIInputImageKey];
    [filter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor"];
    
    // 取得套用濾鏡後的效果
    CIImage *outputImg = [filter outputImage];
    
    // 將照片轉為UIImage格式
    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *image = [UIImage imageWithCGImage:[context createCGImage:outputImg fromRect:outputImg.extent]];
    
    // 存檔
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}
    
// 設定即時預覽呈現的位置坐標與大小，勿放在viewDidLoad中(抓到的frame大小為0會造成預覽無法顯示)
- (void)viewDidAppear:(BOOL)animated {
        
        // 需放在UI畫面出現之後，才能正確抓到view元件的bounds資料
        captureVideoPreviewLayer.frame = self.showView.bounds;
        [session startRunning];
    }
    
    - (void)viewDidDisappear:(BOOL)animated {
        [super viewDidDisappear:animated];
        [session stopRunning];
    }
    
    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }
    
// 照相按鈕
- (IBAction)takeButton:(id)sender {
    
    // 取得靜態圖片前必須在session中找出擷取裝置的輸出口為video的connection
    for (AVCaptureConnection *connection in ((AVCaptureStillImageOutput *)session.outputs[0]).connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (connection) {
            break;
        }
    }
        
    // 拍照會聽到快門聲，若順利從connection取得資料就會進入completionHandler區段
    [session.outputs[0] captureStillImageAsynchronouslyFromConnection: videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyCIFFDictionary, NULL);
        
        if (exifAttachments) {
            
            // 解析相片的exif資訊程式寫在下方
            NSDictionary *dictExif = (__bridge NSDictionary *)exifAttachments;
            
            for (NSString *key in dictExif) {
                NSLog(@"%@: %@", key, [dictExif valueForKey:key]);
            }
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation: imageSampleBuffer];
        
        // 將圖片顯示在預覽的UIImage元件上
        self.previewView.image = [[UIImage alloc] initWithData:imageData];
        
        // 圖片存檔
        UIImageWriteToSavedPhotosAlbum(self.previewView.image, nil, nil, nil);
    }];
}
    
    // 實作前後鏡頭平滑完成轉換的method，避免切換過程中形成資料斷斷續續的狀況
    -(void)cameraPositionChanged {
        static BOOL isPositionFront;
        
        // 修改前先呼叫beginConfiguration
        [session beginConfiguration];
        
        // 將現有的input刪除
        [session removeInput:session.inputs[0]];
        
        if (isPositionFront) {
            [session addInput:backFacingCameraDevice];
        } else {
            [session addInput:frontFacingCameraDevice];
        }
        
        // 確認以上所有修改
        [session commitConfiguration];
        isPositionFront = !isPositionFront;
    }
    
- (IBAction)cameraChangeButton:(id)sender {
    [self cameraPositionChanged];
}
    
/*
 // —————————— 調整相機參數 START ——————————
 -(void)cameraSetting {
 AVCaptureDevice *camera = [session.inputs[0] device];
 
 // 修改相機屬性前先鎖定
 [camera lockForConfiguration:nil];
 
 // 設定測光位置位於螢幕中央，左上角為(0, 0) 右下角為(1, 1)
 if ([camera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
 CGPoint exposurePoint = CGPointMake(0.5f, 0.5f);
 [camera setExposurePointOfInterest:exposurePoint];
 [camera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
 }
 
 // 設定螢幕中央對焦點並採取連續對焦模式，左上角為(0, 0) 右下角為(1, 1)
 if ([camera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
 CGPoint autofocusPoint = CGPointMake(0.5f, 0.5f);
 [camera setFocusPointOfInterest:autofocusPoint];
 [camera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
 }
 
 // 設定對焦距離0.0為最短距離，1.0為無限遠(預設值)
 [camera setFocusModeLockedWithLensPosition:0.0 completionHandler:nil];
 
 // 設定快門1/30秒與ISO 200
 [camera setExposureModeCustomWithDuration:CMTimeMake(1, 30) ISO:200 completionHandler:nil];
 
 // 修改完解除鎖定
 [camera unlockForConfiguration];
 }
 // —————————— 調整相機參數 END ——————————
 */

// —————————— 從相本中挑一張相片 START ——————————
- (IBAction)pickPhotoAction:(id)sender {
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    //photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

// 相機開啟後使用者可選擇拍照或取消，若使用者按下拍照鈕拍一張相片
// imagePickerController:didFinishPickingMediaWithInfo方法被呼叫，照片透過參數info傳進來
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 取得使用者拍攝的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.previewView.image = image;
    
    // 存檔
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    // 關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}
// —————————— 從相本中挑一張相片 END ——————————


- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
//- (IBAction)filterTest:(id)sender {
//    [self cameraSetting];
//}
    
-(BOOL)shouldAutorotate {
    [self handleRotate];
    
    return YES;
}

-(void)handleRotate {
    [UIView animateWithDuration:0.0 animations:^{
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationLandscapeLeft:
                self.showView.transform = CGAffineTransformMakeRotation(M_PI_2 * 3);
                break;
            case UIDeviceOrientationLandscapeRight:
                self.showView.transform = CGAffineTransformMakeRotation(M_PI_2 * 1);
                break;
            case UIDeviceOrientationPortrait:
                self.showView.transform = CGAffineTransformMakeRotation(M_PI_2 * 0);
                break;
                // UpsideDown這邊不使用因為會跑位
                //            case UIDeviceOrientationPortraitUpsideDown:
                //                self.showView.transform = CGAffineTransformMakeRotation(M_PI_2 * 2);
                //                break;
                
            default:
                break;
        }
        self.showView.frame = self.view.bounds;
    }];
}

// 隱藏StatusBar
-(BOOL)prefersStatusBarHidden {
    return YES;
}
    
/*
 // Tap Gesture Recognizer
 - (IBAction)handleTap:(UITapGestureRecognizer *)sender {
 for (int i=0; i<sender.numberOfTouches; i++) {
 CGPoint touchPoint = [sender locationOfTouch:i inView:sender.view];
 NSLog(@"第%d根手指位置為%@", (i+1), NSStringFromCGPoint(touchPoint));
 }
 }
 */
    
- (IBAction)flashButtonPressed:(id)sender {
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"flash.png"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"noflash.png"] forState:UIControlStateSelected];
        [sender setSelected:YES];
    }
}
    
-(UIImage *)filterWithImage:(UIImage *)image index:(NSInteger)index
{
    // 創建基於 GPU 的 CIContext 對象
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciSourceImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter;
    switch (index) {
        case 0:
            
            break;
        case 1:
            filter = [CIFilter filterWithName:@"CIColorControls"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(1.1) forKey:kCIInputSaturationKey];
            [filter setValue:@(1.1) forKey:kCIInputContrastKey];
            [filter setValue:@(0.0) forKey:kCIInputBrightnessKey];
            break;
        case 2:
            filter = [CIFilter filterWithName:@"CIHueAdjust"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(0.5) forKey:kCIInputAngleKey];
            break;
        case 3:
            filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 4:
            filter = [CIFilter filterWithName:@"CIGammaAdjust"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(0.75) forKey:@"inputPower"];
            break;
        case 5:
            filter = [CIFilter filterWithName:@"CILinearToSRGBToneCurve"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 6:
            filter = [CIFilter filterWithName:@"CISRGBToneCurveToLinear"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 7:
            filter = [CIFilter filterWithName:@"CIVibrance"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(2.5) forKey:@"inputAmount"];
            break;
        case 8:
            filter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 9:
            filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 10:
            filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 11:
            filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            break;
        case 12:
            filter = [CIFilter filterWithName:@"CIVignette"];
            [filter setValue:ciSourceImage forKey:kCIInputImageKey];
            [filter setValue:@(1.9) forKey:kCIInputRadiusKey];
            [filter setValue:@(1.4) forKey:kCIInputIntensityKey];
            break;
            
        default:
            break;
    }
    
    // 得到過濾後的圖片
    CIImage *outputImage = [filter outputImage];
    
    // 轉換圖片
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    // 釋放 C 對象
    CGImageRelease(cgImage);
    
    return newImage;
}
    
@end
