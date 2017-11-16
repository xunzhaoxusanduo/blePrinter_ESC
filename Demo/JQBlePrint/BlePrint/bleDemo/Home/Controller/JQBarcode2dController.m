//
//  JQBarcode2dController.m
//  bleDemo
//
//  Created by wuyaju on 2017/6/24.
//  Copyright © 2017年 wuyaju. All rights reserved.
//

#import "JQBarcode2dController.h"
#import "ZHPickView.h"
#import "MBProgressHUD+MJ.h"
#import "JQSendFooterView.h"

#import <JQBlePrintSDK/JQBlePrintSDK.h>

@interface JQBarcode2dController () <BleDeviceManagerDelegate>

@property (nonatomic, strong) JQSendFooterView *sendFooterView;

@property (nonatomic, strong)BleDeviceManager *bleManager;
@property (nonatomic, strong)JQESCTool *escManager;

@property (nonatomic, strong)NSArray *listBarcode2dType;
@property (nonatomic, strong)NSArray *listBarcode2dVersion;
@property (nonatomic, strong)NSArray *listBarcode2dErrorCorrectionLevel;
@property (nonatomic, strong)NSArray *listBarcode2dEnlargeTimes;

@property (nonatomic, assign)NSInteger barcode2dType;
@property (nonatomic, assign)NSInteger barcode2dVersion;
@property (nonatomic, assign)NSInteger barcode2dErrorCorrectionLevel;
@property (nonatomic, assign)NSInteger barcode2dEnlargeTimes;

@end

@implementation JQBarcode2dController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码测试";
    [self initReouse];
    [self setDefault];
    [self setSendFooterView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.escManager = [JQESCTool ESCManager];
    self.bleManager = [BleDeviceManager bleManager];
    self.bleManager.delegate = self;
}

- (void)setSendFooterView {
    UINib *nib = [UINib nibWithNibName:@"JQSendFooterView" bundle:NSBundle.mainBundle];
    self.sendFooterView = [[nib instantiateWithOwner:nil options:nil] firstObject];
    self.sendFooterView.textField.placeholder = @"请输入二维码！";
    self.sendFooterView.textField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.sendFooterView.sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendFooterView.defaultBtn addTarget:self action:@selector(defaultBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView =self.sendFooterView;
}

- (void)initReouse {
    self.listBarcode2dType = [NSArray arrayWithObjects:@"QRCODE", @"PDF417", @"DATAMATRIX", nil];
    NSMutableArray *arrayVersion = [NSMutableArray arrayWithCapacity:21];
    for (int i = 0; i < 21; i++) {
        arrayVersion[i] = [NSString stringWithFormat:@"%d", i];
    }
    self.listBarcode2dVersion = arrayVersion;
    self.listBarcode2dErrorCorrectionLevel = [NSArray arrayWithObjects:@"0", @"1", @"2",  @"3", @"4", nil];
    self.listBarcode2dEnlargeTimes = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
}

- (void)defaultValue {
    self.barcode2dType = 33;
    self.barcode2dVersion = 3;
    self.barcode2dErrorCorrectionLevel = 2;
    self.barcode2dEnlargeTimes = 3;
}

- (void)setDefault {
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didEditRowAtIndexPath:indexPath subTitle:self.listBarcode2dType.firstObject];
    }
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self tableView:self.tableView didEditRowAtIndexPath:indexPath subTitle:self.listBarcode2dVersion[3]];
    }
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self tableView:self.tableView didEditRowAtIndexPath:indexPath subTitle:self.listBarcode2dErrorCorrectionLevel[2]];
    }
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [self tableView:self.tableView didEditRowAtIndexPath:indexPath subTitle:self.listBarcode2dEnlargeTimes[1]];
    }
    
    [self defaultValue];
}

- (void)showMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didEditRowAtIndexPath:(NSIndexPath *)indexPath subTitle:(NSString *)subTitle {
    //选取某个cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = subTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:self.listBarcode2dType];
                [pickView showPickView:self.view];
                pickView.block = ^(NSString *selectedStr) {
                    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self tableView:tableView didEditRowAtIndexPath:selectIndexPath subTitle:selectedStr];
                    if ([selectedStr isEqualToString:@"QRCODE"]) {
                        self.barcode2dType = 3;
                    }else if ([selectedStr isEqualToString:@"PDF417"]) {
                        self.barcode2dType = 0;
                    }else if ([selectedStr isEqualToString:@"DATAMATRIX"]) {
                        self.barcode2dType = 2;
                    }
                };
                break;
            }
            case 1:{
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:self.listBarcode2dVersion];
                [pickView showPickView:self.view];
                pickView.block = ^(NSString *selectedStr) {
                    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    [self tableView:tableView didEditRowAtIndexPath:selectIndexPath subTitle:selectedStr];
                    self.barcode2dVersion = [self.listBarcode2dVersion indexOfObject:selectedStr];
                };
                break;
            }
            case 2:{
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:self.listBarcode2dErrorCorrectionLevel];
                [pickView showPickView:self.view];
                pickView.block = ^(NSString *selectedStr) {
                    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                    [self tableView:tableView didEditRowAtIndexPath:selectIndexPath subTitle:selectedStr];
                    self.barcode2dErrorCorrectionLevel = [self.listBarcode2dErrorCorrectionLevel indexOfObject:selectedStr];
                };
                break;
            }
            case 3:{
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:self.listBarcode2dEnlargeTimes];
                [pickView showPickView:self.view];
                pickView.block = ^(NSString *selectedStr) {
                    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                    [self tableView:tableView didEditRowAtIndexPath:selectIndexPath subTitle:selectedStr];
                    self.barcode2dEnlargeTimes = [self.listBarcode2dEnlargeTimes indexOfObject:selectedStr] + 1;
                };
                break;
            }
            default:
                break;
        }
    }
}

- (void)print {
    if (![self.escManager esc_reset]) return;
    
    {
        Byte cmd[] = {0x1D, 0x77, (Byte)self.barcode2dEnlargeTimes};
        [self.bleManager writeCmd:cmd cmdLenth:sizeof(cmd)];
    }
    
    {
        if (self.barcode2dType == 44) {
            Byte cmd[] = {(Byte)self.barcode2dVersion, (Byte)self.barcode2dErrorCorrectionLevel};
            [self.bleManager writeCmd:cmd cmdLenth:sizeof(cmd)];
        }
    }
    
    [self.escManager esc_print_barcode_2d:self.barcode2dType content:self.sendFooterView.textField.text];
    [self.escManager esc_print_text:@"\r\n"];
}

- (void)sendBtnClicked:(UIButton *)sender {
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
            [self print];
        }
    } fail:^{
        [self showMessage:@"未读取到打印机状态！"];
    }];
}
- (void)defaultBtnClicked:(id)sender {
    [self setDefault];
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
