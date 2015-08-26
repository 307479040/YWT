//
//  finishion.m
//  运维通
//
//  Created by ritacc on 15/7/23.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import "finishion.h"
#import "MBProgressHUD+MJ.h"
#import "VPImageCropperViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f
#import"MBProgressHUD.h"


@interface finishion ()<CLLocationManagerDelegate,UIWebViewDelegate,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
{
    
    NSString *_accountType;
    UIImage *_receiveImage;
    MBProgressHUD *HUD;
    int btnnum;
}

@property (weak, nonatomic) IBOutlet UILabel *danhao;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *style;

@property (weak, nonatomic) IBOutlet UILabel *dri;

@property (weak, nonatomic) IBOutlet UILabel *bt;
@property (nonatomic,strong)NSString *idtt;

@property (weak, nonatomic) IBOutlet UILabel *beiz;


@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *xj1;
@property (weak, nonatomic) IBOutlet UIButton *xj2;
@property (weak, nonatomic) IBOutlet UIButton *xj3;
@property (weak, nonatomic) IBOutlet UIButton *xj4;


@property (nonatomic,strong)NSString *img1;
@property (nonatomic,strong)NSString *img2;
@property (nonatomic,strong)NSString *img3;
@property (nonatomic,strong)NSString *img4;

@property (nonatomic,strong)NSString *img1icon;
@property (nonatomic,strong)NSString *img2icon;
@property (nonatomic,strong)NSString *img3icon;
@property (nonatomic,strong)NSString *img4icon;
@end

@implementation finishion
@synthesize strTtile;
@synthesize _locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager= [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationManager.distanceFilter = 100;
    
    [_locationManager startUpdatingLocation];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        _locationManager.pausesLocationUpdatesAutomatically = NO;
    }
    [self requestaaa];
}

-(void)didClickIconImageV
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet=[[UIActionSheet alloc] initWithTitle:@"选择"
                                          delegate:self
                                 cancelButtonTitle:@"取消"
                            destructiveButtonTitle:nil
                                 otherButtonTitles:@"拍照", @"从相册中选取", nil];
        
        
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择"
                                            delegate:self
                                   cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"从相册选择", nil];
        
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
         portraitImg=[self fixOrientation:portraitImg];
        _receiveImage=portraitImg;
        [self btnupload_Click:nil];
    }];
}




- (void)btnupload_Click:(id)sender {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    NSString *orderid = [userDefaultes stringForKey:@"orderid"];
    
    [self UpdateFileImage:_receiveImage action:@"userimg" orderid:myString creatorid:myString uploadUrl:urlt];
    
    NSLog(@"完成上传图片。");
}


- (void) UpdateFileImage:(UIImage *)currentImage
                  action:(NSString *) straction
                 orderid:(NSString *) strOrderid
               creatorid:(NSString *) strCreatorid //创建人ID
               uploadUrl:(NSString *) strUploadUrl //上传路径
{
    NSData *data = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSString *hyphens = @"--";
    NSString *boundary = @"*****";
    NSString *end = @"\r\n";
    NSMutableData *myRequestData1=[NSMutableData data];
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableString *fileTitle=[[NSMutableString alloc]init];
    
    [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"file%d",1],[NSString stringWithFormat:@"image%d.png",1]];
    
    [fileTitle appendString:end];
    
    [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",end]];
    [fileTitle appendString:end];
    
    [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData1 appendData:data];
    
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *url=[NSString stringWithFormat:@"%@/API/YWT_OrderFile.ashx?action=90",strUploadUrl];
    //根据url初始化request
    
    // NSLog(@"%@",url);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", [myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    NSString * result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    
    //    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    
    NSData *data5 = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"结果：%@",dict[@"ReturnMsg"]);
    NSLog(@"结果：%@",dict[@"ReturnMsg"]);
    NSLog(@"结果：%@",dict[@"ReturnMsgIcon"]);
    
    NSString *Status=[NSString stringWithFormat:@"%@",dict[@"Status"]];
    if ([Status isEqualToString:@"0"]){
        NSString *ReturnMsg=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
        [MBProgressHUD showError:ReturnMsg];
        NSLog(@"%@",ReturnMsg);
    }
    else
    {
      
        NSString *img=[NSString stringWithFormat:@"%@/%@",urlt,dict[@"ReturnMsgIcon"]];
        NSURL *imgurl=[NSURL URLWithString:img];
        
        if (btnnum==1) {
            _img1=dict[@"ReturnMsg"];
            _img1icon=dict[@"ReturnMsgIcon"];
            UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
            [self.xj1 setBackgroundImage:imgstr forState:UIControlStateNormal];
        }
        else if (btnnum==2) {
            _img2=dict[@"ReturnMsg"];
            _img2icon=dict[@"ReturnMsgIcon"];
            UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
            [self.xj2 setBackgroundImage:imgstr forState:UIControlStateNormal];
        }
        else if (btnnum==3) {
            _img3=dict[@"ReturnMsg"];
            _img3icon=dict[@"ReturnMsgIcon"];
            UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
            [self.xj3 setBackgroundImage:imgstr forState:UIControlStateNormal];
        }
        else if (btnnum==4) {
            _img4=dict[@"ReturnMsg"];
            _img4icon=dict[@"ReturnMsgIcon"];
            UIImage *imgstr=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:imgurl]];
            [self.xj4 setBackgroundImage:imgstr forState:UIControlStateNormal];
        }
    }
    
}



-(void)requestaaa
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *mystring2=[NSString stringWithFormat:@"%@",strTtile];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/API/YWT_Order.ashx?action=getitem&q0=%@&q1=%@",urlt,mystring2,myString];
    AFHTTPRequestOperation *op=[self GETurlString:urlStr];
    NSLog(@"%@",urlStr);
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@,%d",   [NSThread mainThread],[NSThread isMainThread]);
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict2=responseObject;
        NSDictionary *dict=dict2[@"ResultObject"];
        NSLog(@"#####%@",dict);
        self.danhao.text=dict[@"OrderNo"];
        NSString *dt3=dict[@"CreateDateTime"];
        dt3=[dt3 stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        dt3=[dt3 stringByReplacingOccurrencesOfString:@")/" withString:@""];
        // NSLog(@"%@",dt3);
        NSString * timeStampString3 =dt3;
        NSTimeInterval _interval3=[timeStampString3 doubleValue] / 1000;
        NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:_interval3];
        NSDateFormatter *objDateformat3 = [[NSDateFormatter alloc] init];
        [objDateformat3 setDateFormat:@"yyyy-MM-dd"];
        self.time.text=[objDateformat3 stringFromDate: date3];
        
        [self idt:dict[@"Order_ID"]];
        
        self.style.text=dict[@"Status_Name"];
        self.bt.text=dict[@"OrderTitle"];
        if (![dict[@"OrderUsers"] isEqual:[NSNull null]]) {
            NSArray *dict3=dict[@"OrderUsers"];
            if (dict3.count>0) {
                NSDictionary *dic=[dict3 objectAtIndex:0];
                if (![dic[@"RealName"] isEqual:[NSNull null]]) {
                    NSString *dr=[NSString stringWithFormat:@"%@  %@",dic[@"RealName"],dic[@"Mobile"]];
                    self.dri.text=dr;
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络异常！"];
        return ;
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
}
- (IBAction)post:(id)sender {
    NSString *lat=[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.latitude];
    NSString *longti=[NSString stringWithFormat:@"%f",_locationManager.location.coordinate.longitude];
    
    [self tijiao2:lat :longti :@"西乡" :self.beiz.text :@""];
}
-(NSString *)idt:(NSString *)id1{
    _idtt=id1;
    return _idtt ;
}

-(void)tijiao2:(NSString *)t1:(NSString *)t2:(NSString *)t3:(NSString *)t4:(NSString *)t5{
    
    NSString *urlStr =[NSString stringWithFormat:@"%@/API/YWT_Order.ashx",urlt] ;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
    
    request.HTTPMethod = @"POST";
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //NSString *img=@"123.png";
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    NSString *dest=[NSString stringWithFormat:@"[{\"FileName\":\"%@\",\"FileIcon\":\"%@\"},{\"FileName\":\"%@\",\"FileIcon\":\"%@\"},{\"FileName\":\"%@\",\"FileIcon\":\"%@\"},{\"FileName\":\"%@\",\"FileIcon\":\"%@\"}]",_img1,_img1icon,_img2,_img2icon,_img3,_img3icon,_img4,_img4icon];
    NSString *str = [NSString stringWithFormat:@"action=saveorderflow&q0=%@&q1=90&q2=%@&q3=%@&q4=%@&q5=%@&q6=%@&q7=%@",_idtt,myString,t1,t2,t3,t4,dest];
    
    NSLog(@"%@?%@",urlt,str);
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

     
        if(data!=nil)
        {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSString *errstr2=[NSString stringWithFormat:@"%@",dict[@"Status"]];
                
                if ([errstr2 isEqualToString:@"0"]){
                    NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                    [MBProgressHUD showError:str];
                    return ;
                }else{
                    [MBProgressHUD showSuccess:@"提交成功"];
                    [[self navigationController] popViewControllerAnimated:YES];
                }
            }];

        }else{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [MBProgressHUD showError:@"网络异常请检查！"];
                return ;
            }];
        }
        
    }];
}

- (IBAction)postimg1:(id)sender {
    btnnum=1;
    [self didClickIconImageV];
    
}
- (IBAction)postimg2:(id)sender {
    btnnum=2;
    [self didClickIconImageV];
    
}
- (IBAction)postimg3:(id)sender {
    btnnum=3;
    [self didClickIconImageV];
    
}
- (IBAction)postimg4:(id)sender {
    btnnum=4;
    [self didClickIconImageV];
    
}







-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self requestaaa];
    id vc=segue.destinationViewController;
    if ([vc isKindOfClass:[finishion class]]) {
        finishion *detai=vc;
        NSString *mystring2=[NSString stringWithFormat:@"%@",_idtt];
        [detai setValue:mystring2 forKey:@"strTtile"];
        
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
