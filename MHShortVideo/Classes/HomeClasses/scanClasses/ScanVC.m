//
//  ScanVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "ScanVC.h"
#import <AVFoundation/AVFoundation.h>
#import "MyQrcodeVC.h"

@interface ScanVC ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic,strong)AVCaptureSession * session;//输入输出的中间桥梁
@property (nonatomic, strong) AVCaptureDevice *device;//获取摄像设备
@property (nonatomic, strong) AVCaptureDeviceInput *input;//创建输入流
@property (nonatomic, strong) AVCaptureMetadataOutput *output;//创建输出流
@property(nonatomic,assign)CGRect outPutRect;
@property (strong, nonatomic) CIDetector *detector;
@property(nonatomic,assign)BOOL canShort;//摄像头是否可用

@property(nonatomic,assign)BOOL isFirstTime;

@property (nonatomic, strong) UIImageView * scanRectView;//正方形扫描狂
@property (nonatomic, strong) UIImageView * scanLine;//扫描条
@property(nonatomic,assign)BOOL isAnimation;

@end

@implementation ScanVC
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self start_scan];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self stop_scan];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstTime = YES;
    self.canShort = NO;
    self.isAnimation = NO;
    [self commit_navBar];
    [self commit_ScanView];
}
#pragma mark - 初始化扫描框
-(void)commit_ScanView
{
    CGFloat scanWidth = Width(250);
    CGFloat topHieght = Width(210);
    //扫描框
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGSize scanSize = CGSizeMake(scanWidth, scanWidth);
    CGRect scanRect = CGRectMake((windowSize.width - scanSize.width) / 2, topHieght, scanSize.width, scanSize.height);
    scanRect = CGRectMake(scanRect.origin.y / windowSize.height, scanRect.origin.x / windowSize.width, scanRect.size.height / windowSize.height,scanRect.size.width / windowSize.width);
    
    self.outPutRect = scanRect;
    
    scanRect = CGRectMake((windowSize.width - scanSize.width) / 2, topHieght, scanSize.width, scanSize.height);
    
    self.scanRectView = [[UIImageView alloc] initWithFrame:scanRect];
    self.scanRectView.image = [UIImage imageNamed:@"scan_background"];
    self.scanRectView.contentMode = UIViewContentModeScaleAspectFill;
    self.scanRectView.clipsToBounds = YES;
    [self.view addSubview:self.scanRectView];
    
    self.scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, scanRect.size.width, 5)];
    self.scanLine.image = [UIImage imageNamed:@"scan_line"];
    self.scanLine.contentMode = UIViewContentModeScaleAspectFit;
    self.scanLine.clipsToBounds = YES;
    [self.scanRectView addSubview:self.scanLine];
    
    //我的二维码
    UIImageView * myMA = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    myMA.center = CGPointMake(Screen_WIDTH/2, Screen_HEIGTH - 60-20);
    myMA.image = [UIImage imageNamed:@"home_bgm_icon"];
    myMA.contentMode = UIViewContentModeScaleAspectFill;
    myMA.clipsToBounds = YES;
    [self.view addSubview:myMA];
    UILabel * lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(14) aligent:NSTextAlignmentCenter];
    lab.text = @"我的二维码";
    lab.frame = CGRectMake(0, 0, Width(80), 20);
    lab.center = CGPointMake(Screen_WIDTH/2, Screen_HEIGTH - 60 + 15);
    [self.view addSubview:lab];
    UIButton * mymaBtn = [UIButton buttonWithType:0];
    mymaBtn.frame = CGRectMake(0, 0, Width(80), Width(80));
    mymaBtn.center = CGPointMake(Screen_WIDTH/2, Screen_HEIGTH - 60);
    [mymaBtn addTarget:self action:@selector(jumpToMyErweima) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mymaBtn];
}
#pragma mark - 开始扫描+动画
-(void)start_scan
{
    if (_isFirstTime) {
        _isFirstTime = NO;
        [self makeSureUserAuth];
    }else{
        if (_canShort) {
            [self.session startRunning];
            //扫描动画
            [self start_scanLineAnimation];
        }
    }
}
#pragma mark - 停止扫描+动画
-(void)stop_scan
{
    if (_canShort) {
        [self.session stopRunning];
        //取消扫描动画
        [self stop_scanLineAnimation];
    }
}
-(void)start_scanLineAnimation
{
    if (!_isAnimation) {
        _isAnimation = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scanAnimation];
        });
    }
}
-(void)stop_scanLineAnimation
{
    _isAnimation = NO;
    [self.scanLine.layer removeAllAnimations];
}
-(void)scanAnimation
{
    [UIView animateWithDuration:1.0 // 动画时长
                          delay:0.0 // 动画延迟
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat // 动画过渡效果
                     animations:^{
                         //修改fream的代码写在这里
                         self.scanLine.frame =CGRectMake(0, self.scanRectView.frame.size.height-5, self.scanRectView.frame.size.width, 5);
                     }
                     completion:^(BOOL finished) {
                         self.scanLine.frame =CGRectMake(0, 5, self.scanRectView.frame.size.width, 5);
                     }];
}
#pragma mark - 检测用户权限
-(void)makeSureUserAuth
{
    [MHGetPermission getCaptureDevicePermission:^(BOOL has) {
        if (has) {
            [self buildSaoMiao];
        }else{
            [MAlertView showAlertIn:self msg:@"请在iPhone的“设置-隐私”选项中，允许****访问您的摄像头。" callBack:^(BOOL sure) {
                if (sure) {
                    //跳转到设置 该应用位置
                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
        }
    }];
}
#pragma mark - 初始化扫描设备
-(void)buildSaoMiao
{
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if (!self.input || !self.output) {
        _canShort = NO;
        return;
    }
    _canShort = YES;
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置扫码支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    self.output.rectOfInterest = self.outPutRect;
    
    [self.session startRunning];
    //开始扫描动画
    [self start_scanLineAnimation];
}
#pragma mark - 处理扫描结果
-(void)saoMiaoJieGuo:(NSString *)result
{
    [self stop_scan];
    DLog(@"%@",result);
    [MAlertView showAlertIn:self msg:result callBack:^(BOOL sure) {
        [self start_scan];
    }];
}
#pragma mark - 实现代理方法, 完成二维码扫描
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count == 0) {
        return;
    }
    
    if (metadataObjects.count > 0) {
        //停止扫描
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        //扫描得到的文本 可以拿到扫描后的文本做其他操作
        [self saoMiaoJieGuo:metadataObject.stringValue];
    }
}
#pragma mark - 相册选图
-(void)chooseFromPhotoAlbum
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [UIScrollView mh_scrollOpenAdjustment:YES];
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.allowsEditing = NO;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
            [self stop_scan];
        }];
    } else {
        //NSLog(@"不能打开相册");
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = nil;
    image = info[@"UIImagePickerControllerOriginalImage"];
    if (image) {
        [UIScrollView mh_scrollOpenAdjustment:NO];
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            [self start_scan];
        }];
        [MHLoading showloading];
        self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //这里结束loading
            [MHLoading stopLoading];
            if (features.count >=1) {
                CIQRCodeFeature *feature = [features objectAtIndex:0];
                NSString *scannedResult = feature.messageString;
                [self saoMiaoJieGuo:scannedResult];
            }else{
                [MHHUD showTips:@"照片中未识别到二维码"];
                if (![self.session isRunning]) {
                    [self.session startRunning];
                }
                //开始扫描动画
                [self start_scanLineAnimation];
            }
        });
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIScrollView mh_scrollOpenAdjustment:NO];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [self start_scan];
    }];
}
#pragma mark - 我的二维码
-(void)jumpToMyErweima
{
    MyQrcodeVC * vc = [[MyQrcodeVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    self.mhNavBar.backgroundColor = [UIColor clearColor];
    [self mh_setNavBottomlineHiden:YES];
    [self mh_setNeedBackItemWithTitle:@"扫一扫"];
    
    UIButton * btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, 0, 60, 40);
    btn.center = CGPointMake(Screen_WIDTH-60/2, K_StatusHeight + (NavHeight - K_StatusHeight)/2);
    [btn setTitle:@"相册" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = FONT(15);
    [btn addTarget:self action:@selector(chooseFromPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.mhNavBar addSubview:btn];
}

@end
