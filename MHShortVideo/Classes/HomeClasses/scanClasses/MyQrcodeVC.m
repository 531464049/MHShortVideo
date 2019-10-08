//
//  MyQrcodeVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/10.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MyQrcodeVC.h"
#import <CoreImage/CoreImage.h>

@interface MyQrcodeVC ()

@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,strong)UIImageView * myQrcodeImage;

@end

@implementation MyQrcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
    
    self.myQrcodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(250), Width(250))];
    self.myQrcodeImage.center = CGPointMake(Screen_WIDTH/2, Screen_HEIGTH/2);
    self.myQrcodeImage.contentMode = UIViewContentModeScaleAspectFill;
    self.myQrcodeImage.clipsToBounds = YES;
    [self.view addSubview:self.myQrcodeImage];
    
    [self creatCIQRCodeImage];
}
#pragma mark - 生成二维码
-(void)creatCIQRCodeImage
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认设置
    [filter setDefaults];
    // 3. 给过滤器添加数据
    NSString *dataString = @"二狗的二维码";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    UIImage * qrImage = [self creatNonInterpolatedUIImageFormCIImage:outputImage withSize:250];
    self.myQrcodeImage.image = qrImage;
}
- (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - 保存到相册
-(void)saveMyQrcodeToAlbum
{
    if (self.myQrcodeImage.image) {
            UIImageWriteToSavedPhotosAlbum(self.myQrcodeImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    DLog(@"%@",msg);
}
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    [self mh_setNavBottomlineHiden:YES];
    [self mh_setNeedBackItemWithTitle:@"我的二维码"];
    
    self.rightBtn = [UIButton buttonWithType:0];
    self.rightBtn.frame = CGRectMake(0, 0, 60, 40);
    self.rightBtn.center = CGPointMake(Screen_WIDTH-60/2, K_StatusHeight + (NavHeight - K_StatusHeight)/2);
    [self.rightBtn setTitle:@"保存" forState:0];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.rightBtn.titleLabel.font = FONT(15);
    [self.rightBtn addTarget:self action:@selector(saveMyQrcodeToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.mhNavBar addSubview:self.rightBtn];
}
-(void)mh_navBackItem_click
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
