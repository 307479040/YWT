//
//  mapViewController.m
//  送哪儿
//
//  Created by apple on 15/4/28.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import "mapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "hjnANNINOTION.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MBProgressHUD+MJ.h"
#import <AMapSearchKit/AMapSearchAPI.h>


#define RUNTIME 1000*5
@interface mapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    AMapSearchAPI *_search;
    
    CLGeocoder *_geocoder;
    
}
@property (weak, nonatomic) IBOutlet UITextField *searchfield;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
@property (weak, nonatomic) IBOutlet UILabel *headlabel;
@property (nonatomic,strong)NSArray *tgs;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *viewback;
@property (weak, nonatomic) IBOutlet UIButton *que;

@end

@implementation mapViewController
@synthesize _locationManager;
@synthesize _saveLocations;


- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchfield.delegate=self;
    self.mapView.delegate = self;
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager= [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        _locationManager.distanceFilter = 100;
        
        [_locationManager startUpdatingLocation];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            
            [_locationManager requestWhenInUseAuthorization];
        
        _locationManager.pausesLocationUpdatesAutomatically = NO;
    }
    self.mapView.userTrackingMode=MKUserTrackingModeFollowWithHeading;
    self.mapView.delegate = self;
    _geocoder=[[CLGeocoder alloc]init];
        _search = [[AMapSearchAPI alloc] initWithSearchKey:@"84b236dd100187d3b2f86f878bbf1b33" Delegate:self];

    self.tabBarController.tabBar.hidden=YES;
    self.tableview.rowHeight=70;
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
}

- (IBAction)text:(id)sender {
    self.viewback.hidden=NO;
    //构造AMapInputTipsSearchRequest对象，keywords为必选项，city为可选项
    AMapInputTipsSearchRequest *tipsRequest= [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.searchType = AMapSearchType_InputTips;
    tipsRequest.keywords =self.searchfield.text;
    //  tipsRequest.city = @[@"北京"];
    
    //发起输入提示搜索
    [_search AMapInputTipsSearch: tipsRequest];
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
 //   NSString *strCount = [NSString stringWithFormat:@"count: %d", response.count];
  NSMutableArray *result =[NSMutableArray array] ;
    
    for (AMapTip *p in response.tips) {
        NSString *name = [NSString stringWithFormat:@"%@",p.name];
         NSString *diqu = [NSString stringWithFormat:@"%@",p.district];
        NSMutableArray *dictArray =@{
                                          @"name" :name,
                                          @"diqu" :diqu,

                                          };
        [result addObject:dictArray];
    }
 
     NSLog(@"-%@",result);
 [self result:result];
 [self.tableview reloadData];
}

- (IBAction)d:(id)sender {
[self.searchfield resignFirstResponder];
}



-(NSArray *)result:(NSArray *)addr{

    _tgs=addr;
    _mapView.userInteractionEnabled=NO;
    return _tgs;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _tgs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    static NSString *ID = @"tg";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.imageView.image=[UIImage imageNamed:@"qsd"];
    cell.textLabel.text=[_tgs objectAtIndex:indexPath.row][@"name"];
     cell.detailTextLabel.text=dict2[@"diqu"];

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dict2=[_tgs objectAtIndex:indexPath.row];
    NSString *addr11=[NSString stringWithFormat:@"%@",dict2[@"name"]];
     NSString *addr12=[NSString stringWithFormat:@"%@",dict2[@"diqu"]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *addr=[NSString stringWithFormat:@"%@",addr12];
    NSString *addr2=[NSString stringWithFormat:@"%@",addr11];
    NSString *toaladdr=[NSString stringWithFormat:@"%@%@",addr12,addr11];
    [userDefaults setObject:toaladdr forKey:@"detaaddr"];
    [userDefaults setObject:addr forKey:@"detaaddr1"];
    [userDefaults setObject:addr2 forKey:@"detaaddr2"];
    [userDefaults synchronize];
    [[self navigationController] popViewControllerAnimated:YES];
 
  
}

- (IBAction)cehuanbtn:(id)sender {
    self.viewback.hidden=YES;
}



- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [mapView removeAnnotations:self.mapView.annotations];
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    CLLocation *current=[[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    
    [self.geocoder reverseGeocodeLocation:current completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *firstPlaceMark=[placemarks firstObject];
        NSDictionary *dict=firstPlaceMark.addressDictionary;
        if([firstPlaceMark.name isEqualToString:@""]){
            self.dizhi.text=@"加载中...";
        }else{
            
            self.dizhi.text=@"加载中...";
            self.dizhi.text=@"加载中...";
            if ([[NSString stringWithFormat:@"%@",dict[@"State"]] isEqualToString:@"(null)"]) {
                self.headlabel.text=@"";
            }else{
                self.headlabel.text=[NSString stringWithFormat:@"%@%@%@",dict[@"State"],dict[@"City"],dict[@"SubLocality"]];
            }
            
            if ([[NSString stringWithFormat:@"%@",dict[@"Street"]] isEqualToString:@"(null)"]) {
                self.dizhi.text=@"";
            }else{
                self.dizhi.text=[NSString stringWithFormat:@"%@",dict[@"Street"]];
            }
        }
    }];
    

}

- (IBAction)queding:(id)sender {
    if ([self.dizhi.text isEqualToString:@"(null)"])
    {
       [MBProgressHUD showError:@"地址选择错误！"];
        return;
    }else if ([self.dizhi.text isEqualToString:@"加载中..."])
    {
        [MBProgressHUD showError:@"地址选择错误！"];
        return;
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
          NSString *addr=[NSString stringWithFormat:@"%@",self.headlabel.text];
    NSString *addr2=[NSString stringWithFormat:@"%@",self.dizhi.text];
        NSString *toaladdr=[NSString stringWithFormat:@"%@%@",self.headlabel.text,self.dizhi.text];
    [userDefaults setObject:toaladdr forKey:@"detaaddr"];
         [userDefaults setObject:addr forKey:@"detaaddr1"];
         [userDefaults setObject:addr2 forKey:@"detaaddr2"];
    [userDefaults synchronize];

    [[self navigationController] popViewControllerAnimated:YES];
    }

}


#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        
        CLLocation *current=[[CLLocation alloc] initWithLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude];
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
        
        NSLog(@"%00f,%@,%@",meters,current,before);
        
    }];
}


- (void)addLineFrom:(CLPlacemark *)fromPm to:(CLPlacemark *)toPm
{
    // 1.添加2个大头针
    hjnANNINOTION *fromAnno = [[hjnANNINOTION alloc] init];
    fromAnno.coordinate = fromPm.location.coordinate;
    fromAnno.title = fromPm.name;
    [self.mapView addAnnotation:fromAnno];
    
    hjnANNINOTION *toAnno = [[hjnANNINOTION alloc] init];
    toAnno.coordinate = toPm.location.coordinate;
    toAnno.title = toPm.name;
    [self.mapView addAnnotation:toAnno];
    
    // 2.查找路线
    
    // 方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    // 设置起点
    MKPlacemark *sourcePm = [[MKPlacemark alloc] initWithPlacemark:fromPm];
    request.source = [[MKMapItem alloc] initWithPlacemark:sourcePm];
    
    // 设置终点
    MKPlacemark *destinationPm = [[MKPlacemark alloc] initWithPlacemark:toPm];
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationPm];
    
    // 方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 计算路线
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSLog(@"总共%d条路线", response.routes.count);
        
        // 遍历所有的路线
        for (MKRoute *route in response.routes) {
            // 添加路线遮盖
            [self.mapView addOverlay:route.polyline];
        }
    }];
}

#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    return renderer;
}


-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce
{
    [self.searchfield resignFirstResponder];


}


@end
