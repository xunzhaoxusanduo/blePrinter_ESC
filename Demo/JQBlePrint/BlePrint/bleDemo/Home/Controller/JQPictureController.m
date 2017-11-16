//
//  JQPictureController.m
//  bleDemo
//
//  Created by wuyaju on 2017/6/27.
//  Copyright © 2017年 wuyaju. All rights reserved.
//

#import "JQPictureController.h"
#import "UIImage+Gray.h"
#import "MBProgressHUD+MJ.h"

#import <JQBlePrintSDK/JQBlePrintSDK.h>

@interface JQPictureController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, BleDeviceManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong)BleDeviceManager *bleManager;
@property (nonatomic, strong)JQESCTool *escManager;

@end

@implementation JQPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *printBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    printBtn.frame = CGRectMake(0, 0, 50, 40);
    [printBtn setTitle:@"打印" forState:UIControlStateNormal];
    [printBtn addTarget:self action:@selector(printBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:printBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    self.escManager = [JQESCTool ESCManager];
    self.bleManager = [BleDeviceManager bleManager];
    self.bleManager.delegate = self;
}

- (IBAction)camerBtnclicked:(id)sender {
    // 判断是否支持需要设置的sourceType
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate  = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                 message:@"当前设备不支持录像" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)phtotLibaryBtnClicked:(id)sender {
    // 判断是否支持需要设置的sourceType
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate  = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                 message:@"当前设备不支持录像" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (UIImage *)clicpImage:(UIImage *)image {
    if (image == nil) {
        return nil;
    }
    
    int oriWidth = image.size.width;
    int oriHeight = image.size.height;
    
    CGFloat scale = oriWidth / oriHeight;
    CGSize size = CGSizeMake(250, 250);
    
    NSInteger desWidth = size.width;
    NSInteger desHeight = size.height;
    
    if (scale >= 1.0) {
        desWidth = size.width;
        desHeight = oriHeight * desWidth / oriWidth;
    }else {
        desHeight = size.height;
        desWidth = oriWidth * desHeight / oriHeight;
    }
    
    image = [image toImageWithSize:CGSizeMake(desWidth, desHeight)];
    
    return image;
}

- (void)printBtnClicked {
    if (self.imageView.image == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                 message:@"请选择图像" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        // 判断当前是否连接蓝牙打印机
        if (![self.bleManager isConnectBle]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"未连接设备！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:done];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self.escManager esc_bitmap_mode:0 iamge:self.imageView.image];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }
}

#pragma mark - UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = nil;
        image = info[UIImagePickerControllerEditedImage];
        if (image != nil) {
            image = [image convertToGrayscale];
            self.imageView.image = [self clicpImage:image];
        }else {
            image = info[UIImagePickerControllerOriginalImage];
            image = [image convertToGrayscale];
            self.imageView.image = [self clicpImage:image];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BleDeviceManagerDelegate代理方法
/**
 *  连接外围设备失败
 */
- (void)didFailToConnectPeripheral{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"连接失败"];
}

/**
 *  和外围设备断开连接
 */
- (void)didDisconnectPeripheral{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"和设备断开连接"];
}

/**
 *  打印机状态发生变化
 */
- (void)didUpdateBlePrintStatus:(JQBlePrintStatus)blePrintStatus{
    switch (blePrintStatus) {
        case JQBlePrintStatusOk:
            [self showMessage:@"打印完成"];
            break;
        case JQBlePrintStatusNoPaper:
            [self showMessage:@"缺纸！"];
            break;
        case JQBlePrintStatusOverHeat:
            [self showMessage:@"打印头过热！"];
            break;
        case JQBlePrintStatusBatteryLow:
            [self showMessage:@"电量低！"];
            break;
        case JQBlePrintStatusPrinting:
            [self showMessage:@"正在打印中！"];
            break;
        case JQBlePrintStatusCoverOpen:
            [self showMessage:@"纸仓盖未关闭！"];
            break;
        default:
            break;
    }
}

@end
