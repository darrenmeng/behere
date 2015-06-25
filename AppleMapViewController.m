//
//  AppleMapViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/6/22.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "AppleMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PinDAO.h"

@interface AppleMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocation *currentLocation;
    BOOL isFirstLocationReceived;
    
    //必須先#import <CoreLocation/CoreLocation.h>才能使用CLLocationManager類別
    CLLocationManager *locationManager;
}


@property (weak, nonatomic) IBOutlet MKMapView *appleMapView;

@end

@implementation AppleMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.appleMapView.delegate = self;
    
    locationManager = [CLLocationManager new];
    
    // iOS8之後的改變，取得使用者對位置服務的授權
    // 在info.plist也要加入相對內容，參考Kent講義p.30
    // 檢查locationManager是否實作或繼承了requestAlwaysAuthorization方法
    // respondsToSelector的功能是去找CLLocationManager裡是否有此方法requestAlwaysAuthorization
    // iOS8之後才有requestAlwaysAuthorization方法
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //使用者活動的種類
    locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    
    //讓本身(ViewController)用protocol來接收回報的位置
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];//開始更新位置
    
    //下面這行是Kent沒有用的，
    //在其他程式中，如果沒有加這行，就不會出現代表使用者現在位置的藍點
    self.appleMapView.ShowsUserLocation = YES;
    
    PinDAO *pinDAO = [[PinDAO alloc] init];
    NSMutableArray *rows = [pinDAO getAllPin];
    NSLog(@"rows= %@", rows);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPinButtonAction:(id)sender {
    MKPointAnnotation *newAnnotation = [MKPointAnnotation new];
    newAnnotation.coordinate = currentLocation.coordinate;
    newAnnotation.title = @"I'm here";
    newAnnotation.subtitle = @"change me";
    
    [self.appleMapView addAnnotation:newAnnotation];
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    NSLog(@"%@", mapView.userLocation);
    
    // 表示不自訂藍點
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    // 叫mapView去佇列中拿名字叫newPin的AnnotationView
    MKAnnotationView *reuseAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"newPin"];
    
    
    // 如果佇列中沒有叫newPin的AnnotationView，就會得到nil
    // 那就創建叫newPin的AnnotationView
    // 這個AnnotationView是要給annotation用的
    if (reuseAnnotationView == nil) {
        reuseAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"newPin"];
    } else{
        // 如果AnnotationView不是nil，那就設定reuseAnnotationView的annotation是annotation
        // 這個方法是給annotation，然後回傳AnnotationView
        reuseAnnotationView.annotation = annotation;
    }
    
    reuseAnnotationView.draggable = false;
    reuseAnnotationView.canShowCallout = true;
    reuseAnnotationView.image = [UIImage imageNamed:@"pointRed.png"];
    
    // 在泡泡的左邊增加按鈕，預計秀相簿或完整訊息
    // 如果不自訂按鈕的型式，那只要寫底下這行就可以了
    // UIButton *leftCalloutButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    CGRect buttonRect = CGRectMake(0, 0, 100, 100);
    UIButton *leftCalloutButton = [[UIButton alloc] initWithFrame:buttonRect];
    [leftCalloutButton setImage:[UIImage imageNamed:@"pointRed.png"] forState:UIControlStateNormal];
    reuseAnnotationView.leftCalloutAccessoryView = leftCalloutButton;
    [leftCalloutButton addTarget:self action:@selector(doSomething) forControlEvents:UIControlEventTouchUpInside];
    
    //在泡泡的右邊增加按鈕，預計放導航功能
    //    UIImageView *rightCalloutImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointRed.png"]];
    //    rightCalloutImageView.userInteractionEnabled = true;
    //    reuseAnnotationView.rightCalloutAccessoryView = rightCalloutImageView;
    
    return reuseAnnotationView;
}

// 要#import <CoreLocation/CoreLocation.h>及加上<CLLocationManagerDelegate>，才能用這個方法
// 當iOS更新使用者位置，會進到這個方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    // 因為iOS的延遲，可能會丟出多個座標
    currentLocation = [locations lastObject];
    
    // 因為只要第一次更新位置時，執行一些動作，所以設定一個變數來控制
    if (isFirstLocationReceived == NO) {
        
        // 將地圖的region設定一個變數，這樣後面用這個變數就好，比較簡短，
        // 例如，不用寫self.myMapView.region.center = ...
        // 必須 #import <MapKit/MapKit.h>，才能使用MKCoordinateRegion類別
        MKCoordinateRegion region = self.appleMapView.region;
        
        //MapView在storyboard要拉好constraint，不然app一開始執行時，使用者的位置會跑掉，其實不是使用者跑掉，而是地圖偏掉了
        region.center = currentLocation.coordinate;
        region.span.latitudeDelta = 0.01;
        region.span.longitudeDelta = 0.01;
        isFirstLocationReceived = YES;
        [self.appleMapView setRegion:region animated:YES];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
