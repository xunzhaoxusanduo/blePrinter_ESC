//
//  MainViewController.m
//  collectionView
//
//  Created by Lansum Stuff on 16/3/29.
//  Copyright © 2016年 Lansum Stuff. All rights reserved.
//

#import "MainViewController.h"
#import "BleDeviceManagerViewController.h"
#import "MBProgressHUD+MJ.h"
#import "JQTextTestController.h"
#import "JQBarcode1dController.h"
#import "JQPrintTool.h"

#import "data.h"

#import <JQBlePrintSDK/JQBlePrintSDK.h>

typedef NS_ENUM(NSInteger, JQPrintTestMode) {
    JQPrintTestModeNone,
    JQPrintTestModePrinting,
    JQPrintTestModeMovie,
    JQPrintTestModeWaybill,
    JQPrintTestModeQRCode,
};

#define ScrenWidth self.view.bounds.size.width

@interface MainViewController () <BleDeviceManagerDelegate>

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIBarButtonItem *addBleItem;
@property (nonatomic, strong)UIBarButtonItem *connectedItem;

@property (nonatomic, strong)BleDeviceManager *bleManager;
@property (nonatomic, strong)JQESCTool *escManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bluetooh Printer";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    
    self.bleManager = [BleDeviceManager bleManager];
    self.bleManager.delegate = self;
    
    self.escManager = [JQESCTool ESCManager];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.bleManager isConnectBle]) {
        self.navigationItem.rightBarButtonItem = self.connectedItem;
    }else{
        self.navigationItem.rightBarButtonItem = self.addBleItem;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.bleManager.delegate = self;
}

#pragma mark - 私有方法
// 进入蓝牙设备管理界面
- (void)connectBle{
    BleDeviceManagerViewController *bleMgr = [[BleDeviceManagerViewController alloc] init];
    [self.navigationController pushViewController:bleMgr animated:YES];
}

- (void)showMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithObjects:@"电影票", @"电子运单", @"二维码", nil];
    }
    
    return _dataArray;
}

- (UIBarButtonItem *)connectedItem{
    if (_addBleItem == nil) {
        UIButton *rightBtn = [[UIButton alloc] init];
        rightBtn.bounds = CGRectMake(0, 0, 35, 35);
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"print.png"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(connectBle) forControlEvents:UIControlEventTouchUpInside];
        _addBleItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }
    
    return _addBleItem;
}

- (UIBarButtonItem *)addBleItem{
    if (_connectedItem == nil) {
        _connectedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(connectBle)];
    }
    
    return _connectedItem;
}

#pragma mark - BleDeviceManagerDelegate代理方法
/**
 *  连接到外围设备
 */
- (void)didConnectPeripheral{
    self.navigationItem.rightBarButtonItem = self.connectedItem;
}

/**
 *  连接外围设备失败
 */
- (void)didFailToConnectPeripheral{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"连接失败"];
    self.navigationItem.rightBarButtonItem = self.addBleItem;
}

/**
 *  和外围设备断开连接
 */
- (void)didDisconnectPeripheral{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"和设备断开连接"];
    self.navigationItem.rightBarButtonItem = self.addBleItem;
}

/**
 *  蓝牙作为中心设备状态发生变化
 */
- (void)didUpdatecentralManagerState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnsupported:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"设备不支持蓝牙功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            break;
        }
        case CBCentralManagerStateUnauthorized:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"蓝牙功能未授权，请到设置中开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            break;
        }
        case CBCentralManagerStatePoweredOff:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"蓝牙未开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            break;
        }
        default:
            break;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 判断当前是否连接蓝牙打印机
    if (self.bleManager.discoveredPeripheral.state != CBPeripheralStateConnected) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"未连接设备！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:done];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        return;
    }
    
    NSString *text = cell.textLabel.text;
    if ([text isEqualToString:@"打印文字"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printTextDemo];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }else if ([text isEqualToString:@"打印图片"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printPicture];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }else if ([text isEqualToString:@"打印一维条码"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printBarcode1d];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }else if ([text isEqualToString:@"打印二维条码"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printBarcode2d];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }else if ([text isEqualToString:@"打印曲线"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printCurve];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }else if ([text isEqualToString:@"打印表格"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printTable];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }else if ([text isEqualToString:@"控制命令"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printControlCommand];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }else if ([text isEqualToString:@"打印餐饮账单"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printCateringBills];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }else if ([text isEqualToString:@"打印巡查结果"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printPatrolResult];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }else if ([text isEqualToString:@"打印货品清单"]) {
        // 打印之前读取打印机状态，根据打印机状态决定下一步操作
        [self.bleManager readBlePrintStatus:3.0 success:^(JQBlePrintStatus blePrintStatus) {
            if (blePrintStatus == JQBlePrintStatusNoError) {
                [self printGoodsList];
            }
        } fail:^{
            [self showMessage:@"未读取到打印机状态！"];
        }];
    }
}

// 通过
/**
 * 打印文本模板
 **/
- (Boolean)printTextDemo {
    [self.escManager esc_print_text:@"打印文本效果展示：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_align:0];
    [self.escManager esc_print_text:@"左对齐效果演示abc123：\n"];

    [self.escManager esc_reset];
    [self.escManager esc_align:1];
    [self.escManager esc_print_text:@"居中对齐效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_align:2];
    [self.escManager esc_print_text:@"右对齐效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_bold:YES];
    [self.escManager esc_print_text:@"加粗效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_underline:2];
    [self.escManager esc_print_text:@"下划线效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_print_text:@"同行不同高效果演示：1倍"];
    
    [self.escManager esc_character_size:22];
    [self.escManager esc_print_text:@"2倍"];
    
    [self.escManager esc_character_size:33];
    [self.escManager esc_print_text:@"3倍"];
    
    [self.escManager esc_character_size:44];
    [self.escManager esc_print_text:@"4倍\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_print_text:@"放大1倍效果演示abc123：\n"];
    
    [self.escManager esc_character_size:22];
    [self.escManager esc_print_text:@"放大2倍效果演示abc123：\n"];
    
    [self.escManager esc_character_size:33];
    [self.escManager esc_print_text:@"放大3倍效果演示abc123：\n"];
    
    [self.escManager esc_character_size:44];
    [self.escManager esc_print_text:@"放大4倍效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_font:0];
    [self.escManager esc_print_text:@"字体A效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_font:1];
    [self.escManager esc_print_text:@"字体B效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_rotate:1];
    [self.escManager esc_print_text:@"顺时针旋转90°效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_rotate:2];
    [self.escManager esc_print_text:@"顺时针旋转180°效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_rotate:3];
    [self.escManager esc_print_text:@"顺时针旋转270°效果演示abc123：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_black_white_reverse:YES];
    [self.escManager esc_print_text:@"黑白反显效果演示abc123：\n\n\n\n"];
    [self.escManager esc_reset];
    
    return YES;
}

/**
 * 打印图片
 **/
- (Boolean)printPicture {
    [self.escManager esc_align:2];
    [self.escManager esc_bitmap_mode:0 iamge:[UIImage imageNamed:@"draw_freehand160160.bmp"]];
    return [self.escManager esc_print_text:@"\r\n"];
}

/**
 * 打印一维条码
 **/
- (Boolean)printBarcode1d {
    [self.escManager esc_print_text:@"\r\n"];
    [self.escManager esc_barcode_1d:0 HRI_font:0 width:0 height:50 type:0 content:@"123456789012"];
    return [self.escManager esc_print_text:@"\r\n"];
}

/**
 * 打印二维条码
 **/
- (Boolean)printBarcode2d {
     [self.escManager esc_print_text:@"\r\n"];
    [self.escManager esc_print_barcode_2d:0 content:@"123456789"];
    return [self.escManager esc_print_text:@"\r\n"];
}

/**
 * 打印曲线
 **/
- (Boolean)printCurve {
    [self.escManager esc_align:0];
    [self.escManager esc_bitmap_mode:0 iamge:[UIImage imageNamed:@"draw_freehand160160.bmp"]];
    return [self.escManager esc_print_text:@"\r\n"];
}

// 通过
/**
 * 打印表格
 **/
- (Boolean)printTable {
    NSString *s1 =  @"┏━━┳━━━┳━━━┳━━━┓\n";
    NSString *s2 = @"┃序号┃姓名  ┃性别  ┃年龄  ┃\n┣━━╋━━━╋━━━╋━━━┫\n";
    NSString *s3 = @"┃ 1  ┃张三  ┃ 男   ┃  18  ┃\n┣━━╋━━━╋━━━╋━━━┫\n";
    NSString *s4 = @"┃ 2  ┃李四  ┃ 女   ┃  17  ┃\n┣━━╋━━━╋━━━╋━━━┫\n";
    NSString *s5 = @"┃ 3  ┃王五  ┃ 男   ┃  16  ┃\n┗━━┻━━━┻━━━┻━━━┛\n\n\n";
    
    [self.escManager esc_line_height:0];
    [self.escManager esc_print_text:s1];
    [self.escManager esc_print_text:s2];
    [self.escManager esc_print_text:s3];
    [self.escManager esc_print_text:s4];
    return [self.escManager esc_print_text:s5];
}

// 通过
/**
 * 打印控制命令
 **/
- (Boolean)printControlCommand {
    [self.escManager esc_reset];
    [self.escManager esc_print_text:@"控制命令效果展示：\n"];
    
    [self.escManager esc_print_text:@"打印并回车效果演示："];
    [self.escManager esc_print_enter];
    
    [self.escManager esc_print_text:@"打印并走纸一行效果演示："];
    [self.escManager esc_print_formfeed];
    
    [self.escManager esc_print_text:@"打印并走纸100个纵向移动单位效果演示："];
    [self.escManager esc_print_formfeed:100];
    
    [self.escManager esc_print_text:@"打印并走纸10个行高效果演示："];
    [self.escManager esc_print_formfeed_row:10];
    
    [self.escManager esc_print_text:@"横向跳格效果演示：\n"];
    [self.escManager esc_next_horizontal_tab];
    
    [self.escManager esc_print_text:@"1"];
    [self.escManager esc_next_horizontal_tab];
    
    [self.escManager esc_print_text:@"2"];
    [self.escManager esc_next_horizontal_tab];
    
    [self.escManager esc_print_text:@"3"];
    [self.escManager esc_next_horizontal_tab];
    
    [self.escManager esc_print_text:@"4\n"];
    
    [self.escManager esc_absolute_print_position:0 nH:0];
    [self.escManager esc_print_text:@"绝对位置0、0效果演示：\n"];
    
    [self.escManager esc_absolute_print_position:50 nH:50];
    [self.escManager esc_print_text:@"绝对位置50、50效果演示：\n"];
    
    [self.escManager esc_absolute_print_position:150 nH:150];
    [self.escManager esc_print_text:@"绝对位置150、150效果演示：\n"];
    
     [self.escManager esc_reset];
    [self.escManager esc_default_line_height];
    [self.escManager esc_print_text:@"设置默认行高效果演示：\n"];
    
    [self.escManager esc_line_height:0];
    [self.escManager esc_print_text:@"设置行高为0效果演示：\n"];
    
    [self.escManager esc_line_height:50];
    [self.escManager esc_print_text:@"设置行高为50效果演示：\n"];
    
    [self.escManager esc_line_height:150];
    [self.escManager esc_print_text:@"设置行高为150效果演示：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_right_space:0];
    [self.escManager esc_print_text:@"设置右边距为0效果演示：\n"];
    
    [self.escManager esc_right_space:50];
    [self.escManager esc_print_text:@"设置右边距为50效果演示：\n"];
    
    [self.escManager esc_right_space:100];
    [self.escManager esc_print_text:@"设置右边距为100效果演示：\n"];
    
    [self.escManager esc_right_space:150];
    [self.escManager esc_print_text:@"设置右边距为150效果演示：\n"];
    
    [self.escManager esc_reset];
    [self.escManager esc_left_margin:50 nH:0];
    [self.escManager esc_print_text:@"设置左边距为50、0效果演示：\n"];
    
     [self.escManager esc_left_margin:50 nH:1];
    [self.escManager esc_print_text:@"设置左边距为50、1效果演示：\n"];
    
     [self.escManager esc_left_margin:100 nH:1];
    [self.escManager esc_print_text:@"设置左边距为100、1效果演示：\n"];
    
     [self.escManager esc_left_margin:0 nH:0];
    [self.escManager esc_print_text:@"设置左边距为0效果演示：\n\n\n\n"];
    
    return [self.escManager esc_reset];
}

// 通过
/**
 * 打印餐饮账单
 **/
- (Boolean)printCateringBills {
    [self.escManager esc_reset];
    [self.escManager esc_default_line_height];
    [self.escManager esc_align:1];
    [self.escManager esc_print_text:@"红星餐厅\n\n"];
    
    [self.escManager esc_character_size:22];
    [self.escManager esc_print_text:@"桌号：1号桌\n\n"];
    
    [self.escManager esc_character_size:0];
    [self.escManager esc_align:0];
    [self.escManager esc_print_text:[JQPrintTool printTwoData:@"订单编号" rightText:@"201704161515\n"]];
    [self.escManager esc_print_text:[JQPrintTool printTwoData:@"点菜时间" rightText:@"2017-04-16 10:46\n"]];
    [self.escManager esc_print_text:[JQPrintTool printTwoData:@"上菜时间" rightText:@"2017-04-16 11:46\n"]];
    [self.escManager esc_print_text:[JQPrintTool printTwoData:@"人数：2人" rightText:@"收银员：张三\n"]];

    [self.escManager esc_print_text:@"--------------------------------\n"];
    [self.escManager esc_bold:YES];
    [self.escManager esc_print_text:[JQPrintTool printThreeData:@"项目" middleText:@"数量" rightText:@"金额\n"]];
    [self.escManager esc_print_text:@"--------------------------------\n"];
    [self.escManager esc_bold:NO];
    [self.escManager esc_print_text:[JQPrintTool printThreeData:@"面" middleText:@"1" rightText:@"0.00\n"]];
    [self.escManager esc_print_text:[JQPrintTool printThreeData:@"米饭" middleText:@"1" rightText:@"6.00\n"]];
    [self.escManager esc_print_text:[JQPrintTool printThreeData:@"铁板烧" middleText:@"1" rightText:@"26.00\n"]];
    [self.escManager esc_print_text:[JQPrintTool printThreeData:@"红烧鲤鱼" middleText:@"1" rightText:@"226.00\n"]];
    [self.escManager esc_print_text:[JQPrintTool printThreeData:@"红烧牛肉面" middleText:@"1" rightText:@"2226.00\n"]];
    [self.escManager esc_print_text:[JQPrintTool printThreeData:@"红烧牛肉面红烧牛肉面红烧牛肉面" middleText:@"888" rightText:@"98886.00\n"]];

    [self.escManager esc_print_text:@"--------------------------------\n"];
    [self.escManager esc_print_text:[JQPrintTool printTwoData:@"合计" rightText:@"53.50\n"]];
    [self.escManager esc_print_text:[JQPrintTool printTwoData:@"抹零" rightText:@"3.50\n"]];
    [self.escManager esc_print_text:@"--------------------------------\n"];
    [self.escManager esc_print_text:[JQPrintTool printTwoData:@"应收" rightText:@"50.00\n"]];
    [self.escManager esc_print_text:@"--------------------------------\n"];

    [self.escManager esc_align:0];
    [self.escManager esc_print_text:@"备注：不要辣、不要香菜"];
    [self.escManager esc_print_text:@"\n\n\n\n"];
    
    return YES;
}

// 通过
/**
 * 打印巡查结果
 **/
- (Boolean)printPatrolResult {
    Byte temp1[] = {0x1B,0x40,0x1B,0x61,0x01,0x1C,0x21,0x08};
    [self.bleManager writeCmd:temp1 cmdLenth:sizeof(temp1)];
    [self.escManager esc_print_text:@"---------------------------------------------------\n厦门市工商行政管理局\n"];
    Byte temp2[] = {0x1B,0x40,0x1B,0x61,0x01,0x1C,0x57,0x01};
    [self.bleManager writeCmd:temp2 cmdLenth:sizeof(temp2)];
    [self.escManager esc_print_text:@"责令改正通知书\n"];
    Byte temp3[] = {0x1C,0x57,0x00};
    [self.bleManager writeCmd:temp3 cmdLenth:sizeof(temp3)];
    [self.escManager esc_print_text:@"厦工商食责[2012]  14号\n（工商部门留存）"];
    Byte temp4[] = {0x1B,0x40};
    [self.bleManager writeCmd:temp4 cmdLenth:sizeof(temp4)];
    [self.escManager esc_print_text:@"厦门集正商贸有限公司：\n  经查，你（单位）从事批发业务的食品经营企业没有向购货者开具销售票据或者清单，进货时未查验许可证和相关证明文件。上诉行为违反了《流通环节食品安全监督管理办法》第十四条第二款、《食品安全法》第三十九条第一款的规定，构成了从事批发业务的食品经营企业没有向购货者开具销售票据或者清单、进货时未查验许可证和相关证明文件行为。根据《流通环节食品安全监督管理办法》第六十三条、《食品安全法》第八十七条的规定，现责令你（单位）立即改正。\n  如果对本责令改正通知不服，可以在收到本通知之日起六十日内向厦门市人民政府行政复议委员会申请复议；也可以在三个月内依法向厦门市思明区人民法院提起诉讼。\n"];
    
    return YES;
}

// 通过
/**
 * 打印货品清单
 **/
- (Boolean)printGoodsList {
    NSString *s1 =  @"┏━━━━━━━┳━━┳━━━┓\n";
    NSString *s2 =  @"┃   商品名称   ┃单位┃ 单价 ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s3 =  @"┃玻璃纸        ┃ 张 ┃9.00  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s4 =  @"┃磨砂玻璃纸    ┃ 张 ┃11.00 ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s5 =  @"┃签字笔芯      ┃ 支 ┃4.50  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s6 =  @"┃修正液/胶水   ┃ 瓶 ┃4.00  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s7 =  @"┃复印纸        ┃ 盒 ┃22    ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s8 =  @"┃双面胶/透明胶 ┃ 卷 ┃11.20 ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s9 =  @"┃回形针        ┃ 盒 ┃2.00  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s10 = @"┃订书机        ┃ 台 ┃16.6  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s11 = @"┃直尺          ┃ 把 ┃3.00  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s12 = @"┃订书针        ┃ 盒 ┃9.80  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s13 = @"┃胶水          ┃ 瓶 ┃9.60  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s14 = @"┃三格文件架    ┃ 个 ┃19.00 ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s15 = @"┃三层活动文件架┃ 个 ┃36.00 ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s16 = @"┃单格文件架    ┃ 个 ┃8.00  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s17 = @"┃文件柜        ┃ 个 ┃122   ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s18 = @"┃介刀          ┃ 把 ┃17.5  ┃\n┣━━━━━━━╋━━╋━━━┫\n";
    NSString *s19 = @"┃笔记本        ┃ 本 ┃4.5   ┃\n┗━━━━━━━┻━━┻━━━┛\n\n\n";
    
    [self.escManager esc_line_height:0];
    [self.escManager esc_print_text:s1];
    [self.escManager esc_print_text:s2];
    [self.escManager esc_print_text:s3];
    [self.escManager esc_print_text:s4];
    [self.escManager esc_print_text:s5];
    [self.escManager esc_print_text:s6];
    [self.escManager esc_print_text:s7];
    [self.escManager esc_print_text:s8];
    [self.escManager esc_print_text:s9];
    [self.escManager esc_print_text:s10];
    [self.escManager esc_print_text:s11];
    [self.escManager esc_print_text:s12];
    [self.escManager esc_print_text:s13];
    [self.escManager esc_print_text:s14];
    [self.escManager esc_print_text:s15];
    [self.escManager esc_print_text:s16];
    [self.escManager esc_print_text:s17];
    [self.escManager esc_print_text:s18];
    return [self.escManager esc_print_text:s19];
}

@end
