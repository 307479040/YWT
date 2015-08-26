//
//  orderViewController.m
//  送哪儿
//
//  Created by apple on 15/4/27.
//  Copyright (c) 2015年 Tony. All rights reserved.
//
#import "MBProgressHUD+MJ.h"
#import "orderViewController.h"



@interface orderViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)reg;

//新的数据
@property (weak, nonatomic) IBOutlet UITextField *biaoti;
@property (weak, nonatomic) IBOutlet UITextField *lx;

@property (weak, nonatomic) IBOutlet UITextView *gzrw;

@property (weak, nonatomic) IBOutlet UITextField *gzsc;
@property (weak, nonatomic) IBOutlet UITextField *khjc;
@property (weak, nonatomic) IBOutlet UITextField *lxr;
@property (weak, nonatomic) IBOutlet UITextField *lxdh;
@property (weak, nonatomic) IBOutlet UITextField *dz;
@property (weak, nonatomic) IBOutlet UITextField *bz;

@property (weak, nonatomic) IBOutlet UIButton *stybtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *foods;

@property(nonatomic,copy)NSDictionary *result;


@end

@implementation orderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *mygh = [userDefaultes stringForKey:@"detaaddr"];
    NSString *iphone=[userDefaultes stringForKey:@"iphone"];
    self.lxdh.text=iphone;
    self.dz.text=mygh;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    for (int component = 0; component < self.foods.count; component++) {
        [self pickerView:nil didSelectRow:0 inComponent:component];
    }
    
 self.scrollview.contentSize=CGSizeMake(320, 1000);
    self.navigationController.navigationBar.hidden=NO;
[self tapBackground];

    
}

- (IBAction)fghZ:(id)sender {
    self.stybtn.hidden=YES;
    self.pickerView.hidden=YES;

}


- (IBAction)selcetsty:(id)sender {
    self.pickerView.hidden=NO;
    self.stybtn.hidden=NO;
    
}

- (NSArray *)foods
{
    if (_foods == nil) {
        
        _foods = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"styname" ofType:@"plist"]];
    }
    return _foods;
}

#pragma mark - 数据源方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.foods.count;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *subfoods = self.foods[component];
    return subfoods.count;
}

#pragma mark - 代理方法

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.foods[component][row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.lx.text = self.foods[component][row];
    }
}



- (IBAction)reg {
    
    NSString *sty=[[NSString alloc]init];
    if ([self.lx.text isEqualToString:@"业务运维"]) {
        sty=@"BusinessOperations";
    } else if ([self.lx.text isEqualToString:@"网络设备"]) {
        sty=@"NetworkEquipment";
    }else if ([self.lx.text isEqualToString:@"操作系统"]) {
        sty=@"OperatingSystem";
    }else if ([self.lx.text isEqualToString:@"服务器设备"]) {
        sty=@"ServerEquipment";
    }
    
    [self postJSON:self.biaoti.text:sty:self.gzrw.text:self.dz.text:self.gzsc.text:self.lxr.text:self.lxdh.text:self.khjc.text:self.bz.text:@"orderfile":@"12345.png"];
    


}

- (void)postJSON:(NSString *)text1:(NSString *)text2:(NSString *)text3:(NSString *)text4:(NSString *)text5:(NSString *)text6:(NSString *)text7:(NSString *)text8:(NSString *)text9:(NSString *)text10:(NSString *)text11{
    @try
    {
        NSString *strurl=[NSString stringWithFormat:@"%@/api/YWT_Order.ashx",urlt];
    NSURL *url = [NSURL URLWithString:strurl];
    
    // 2. Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
    
    request.HTTPMethod = @"POST";
    
 
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"myidt"];
    
    
    NSString *dstr=[NSString stringWithFormat:@"{\"OrderMain\":{\"OrderTitle\":\"%@\",\"OrderType\":\"%@\", \"OrderTask\":\"%@\", \"Task_Address\":\"%@\", \"TaskTimeLen\":\"%@\", \"ContactMan\":\"%@\", \"ContactMobile\":\"%@\", \"CustomerShort\":\"%@\", \"Remark\":\"%@\"},\"OrderFile\":[{\"FileType\":\"%@\",\"FileName\":\"%@\"}]}",text1,text2,text3,text4,text5,text6,text7,text8,text9,text10,text11];
//,\"OrderFile\":[{\"FileType\":\"%@\", \"FileName\":\"%@\", \"CreateDateTime\":\"%@\"]}
    // ? 数据体
    NSString *str = [NSString stringWithFormat:@"action=addinternal&q0=%@&q1=%@",dstr,myString];
    // 将字符串转换成数据
    NSLog(@"%@?%@",url,str);
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    // 把字典转换成二进制数据流, 序列化
    
    
    // 3. Connection
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
             NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
        if (!data==nil) {
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSString *errstr2=[NSString stringWithFormat:@"%@",dict[@"Status"]];
                
                if ([errstr2 isEqualToString:@"0"]){
                    NSString *str=[NSString stringWithFormat:@"%@",dict[@"ReturnMsg"]];
                    
                    [MBProgressHUD showError:str];
                    
                    return ;
                    
                    
                }else{
                    [MBProgressHUD showSuccess:@"下单成功！"];
                  [self performSegueWithIdentifier:@"order" sender:nil];
                    
                    
                }
                
            }];

        
    }else{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [MBProgressHUD showError:@"网络异常请检查！"];
            return ;
        }];
    }
     
     
        
    }];
        
    }@catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
}


-(void)tapBackground
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [self.view addGestureRecognizer:tap];//添加手势到View中
}

-(void)tapOnce
{
    
    [self.biaoti resignFirstResponder];
    [self.lx resignFirstResponder];
    [self.gzrw resignFirstResponder];
    [self.gzsc resignFirstResponder];
    [self.khjc resignFirstResponder];
    [self.lxr resignFirstResponder];
    [self.lxdh resignFirstResponder];
    [self.dz resignFirstResponder];
    [self.bz resignFirstResponder];

}

- (IBAction)selectImg_Click:(id)sender{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet=[[UIActionSheet alloc] initWithTitle:@"选择"
                                          delegate:self
                                 cancelButtonTitle:nil
                            destructiveButtonTitle:@"取消"
                                 otherButtonTitles:@"拍照上传",@"本地上传", nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择"
                                            delegate:self
                                   cancelButtonTitle:nil
                              destructiveButtonTitle:@"取消"
                                   otherButtonTitles:@"本地上传", nil];
        
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}
- (void)btnupload_Click{
    /*
     action:(NSString *) straction
     orderid:(NSString *) strOrderid
     creatorid:(NSString *) strCreatorid //创建人ID
     uploadUrl:(NSString *) strUploadUrl //上传路径
     
     */
  
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
       
        [self UpdateFileImage:self.imageView.image  action:@"" orderid:@"" creatorid:@"" uploadUrl:urlt];
        NSLog(@"完成上传图片。");
    }];
 

}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate=self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        //[imagePickerController release];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.imageView setImage:image];
    self.imageView.tag = 100;
    NSLog(@"setImage:savedImage");
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}



- (NSDictionary *) UpdateFileImage:(UIImage *)currentImage
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
    
    NSString *url=[NSString stringWithFormat:@"%@/API/HDL_UPFile.ashx?from=ios&action=%@&q0=%@&q1=%@"
                   ,strUploadUrl,straction,strOrderid,strCreatorid];
    //根据url初始化request
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:3];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
 //  NSDictionary * result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    
NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    
    NSData *data5 = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data5 options:NSJSONReadingMutableLeaves error:nil];
    _result=dict;
    NSString *dfg=[dict objectForKey:@"ReturnMsg"];
  //  NSString *dfg2=[dict objectForKey:@"ReturnType"];
    
    
//    if ([_time.text isEqualToString:@""]) {
//
//        NSDate *newDate =[NSDate date];
//        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[newDate timeIntervalSince1970]];
//        NSLog(@"timeSp:%@",timeSp); //时间戳的值
//        NSString *timet1= [NSString stringWithFormat:@"\\/Date(%@)\\/",timeSp];
//        
//        NSString *timet2= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time2];
//          [self postJSON:@0:@0:@0:self.addr1.text :self.contact.text :self.tel.text:timet1:self.addr2.text :self.contact2.text :self.tel2.text :timet2:self.Remark.text:@1:dfg];
//        
//    }else if ([_shdate.text isEqualToString:@""]) {
//    
//        NSDate *newDate =[NSDate date];
//        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[newDate timeIntervalSince1970]];
//        NSLog(@"timeSp:%@",timeSp); //时间戳的值
//        NSString *timet2= [NSString stringWithFormat:@"\\/Date(%@)\\/",timeSp];
//        NSString *timet1= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time1];
//          [self postJSON:@0:@0:@0:self.addr1.text :self.contact.text :self.tel.text:timet1:self.addr2.text :self.contact2.text :self.tel2.text :timet2:self.Remark.text:@1:dfg];
//        
//    }else{
//
//        NSString *timet1= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time1];
//        NSString *timet2= [NSString stringWithFormat:@"\\/Date(%@)\\/",_time2];
//       [self postJSON:@0:@0:@0:self.addr1.text :self.contact.text :self.tel.text:timet1:self.addr2.text :self.contact2.text :self.tel2.text :timet2:self.Remark.text:@1:dfg];
//        
//        
//    }
//    
    
  
    return _result;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //  isFullScreen = !isFullScreen;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    CGPoint imagePoint = self.imageView.frame.origin;
    //touchPoint.x ，touchPoint.y 就是触点的坐标
    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
    
    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageView.frame.size.width >=touchPoint.x && imagePoint.y <= touchPoint.y && imagePoint.y+self.imageView.frame.size.height >= touchPoint.y)
    {
        // 设置图片放大动画
        [UIView beginAnimations:nil context:nil];
        // 动画时间
        [UIView setAnimationDuration:1];
        /*
         if (isFullScreen) {
         // 放大尺寸
         
         self.imageView.frame = CGRectMake(0, 0, 320, 480);
         }
         else {
         // 缩小尺寸
         self.imageView.frame = CGRectMake(50, 65, 90, 115);
         }
         */
        // commit动画
        [UIView commitAnimations];
    }
    
}




@end
