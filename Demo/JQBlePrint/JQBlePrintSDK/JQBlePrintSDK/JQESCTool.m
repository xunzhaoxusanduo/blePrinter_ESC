//
//  JQESCTool.m
//  bleDemo
//
//  Created by wuyaju on 2017/6/22.
//  Copyright © 2017年 wuyaju. All rights reserved.
//

#import "JQESCTool.h"
#import "BleDeviceManager.h"
#import <UIKit/UIKit.h>

@interface JQESCTool ()

@property (nonatomic, strong)BleDeviceManager *bleManager;

@end

@implementation JQESCTool

+ (instancetype)ESCManager{
    static JQESCTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JQESCTool alloc] init];
    });
    
    return manager;
}

- (instancetype)init{
    self = [super init];
    
    self.bleManager = [BleDeviceManager bleManager];
    
    return self;
}

// 通过
/**
 * 1、打印文本。
 * @param text 表示所要打印的文本内容。
 */
- (Boolean)esc_print_text:(NSString *)text {
    return [self.bleManager writeText:text];
}

// 通过
/**
 * 2、初始化打印机。
 * 使所有设置恢复到打印机开机时的默认值模式。
 */
- (Boolean)esc_reset {
    Byte reset[] = {0x1B, 0x40};
    return [self.bleManager writeCmd:reset cmdLenth:sizeof(reset)];
}

// 通过
/**
 * 3、选择加粗模式。
 *
 * @param b b为true时选择加粗模式，b为false时取消加粗模式。
 */
- (Boolean)esc_bold:(Boolean)b {
    Byte esc_bold[3];
    esc_bold[0] = 0x1B;
    esc_bold[1] = 0x45;
    if(!b) esc_bold[2] = 0x00;
    else esc_bold[2] = 0x01;
    return [self.bleManager writeCmd:esc_bold cmdLenth:sizeof(esc_bold)];
}

// 通过
/**
 * 4、选择/取消下划线模式。
 * @param n 当n=1或n=49时选择下划线模式且设置为1点宽，当n=2或n=50时选择下划线模式且设置为2点宽，当n取其他值时取消下划线模式。
 */
- (Boolean)esc_underline:(NSInteger)n {
    Byte esc_underline[3];
    esc_underline[0] = 0x1B;
    esc_underline[1] = 0x2D;
    if (n == 1 || n == 49) esc_underline[2] = 0x01;
    else if (n == 2 || n == 50) esc_underline[2] = 0x02;
    else esc_underline[2] = 0x00;
    return [self.bleManager writeCmd:esc_underline cmdLenth:sizeof(esc_underline)];
}

// 通过
/**
 * 5、打印和行进。
 * 基于当前的行间距，打印缓冲区内的数据并走纸一行。
 */
- (Boolean)esc_print_formfeed {
    Byte esc_print_formfeed[] = {0x0A};
    return [self.bleManager writeCmd:esc_print_formfeed cmdLenth:sizeof(esc_print_formfeed)];
}

// 通过
/**
 * 6、水平制表符。
 * 将打印位置移动至下一水平制表符位置。
 */
- (Boolean)esc_next_horizontal_tab {
    Byte esc_next_horizontal_tab[] = {0x09};
    return [self.bleManager writeCmd:esc_next_horizontal_tab cmdLenth:sizeof(esc_next_horizontal_tab)];
}

// 通过
/**
 * 7、打印并走纸到左黑标处。
 * 将打印缓冲区中的数据全部打印出来并走纸到左黑标处。
 */
- (Boolean)esc_left_black_label {
    Byte esc_left_black_label[] = {0x0C};
    return [self.bleManager writeCmd:esc_left_black_label cmdLenth:sizeof(esc_left_black_label)];
}

// 通过
/**
 * 8、打印并回车。
 * 该指令等同于LF指令，既打印缓冲区内的数据并走纸一字符行。
 */
- (Boolean)esc_print_enter {
    Byte esc_print_enter[] = {0x0D};
    return [self.bleManager writeCmd:esc_print_enter cmdLenth:sizeof(esc_print_enter)];
}

// 通过
/**
 * 9、设定右侧字符间距。
 * @param  n 当n＜0时设定右侧字符间距为0，当n＞255时设定右侧字符间距为【255×（水平或垂直移动单位）】,
 *           当0≤n≤255时设定右侧字符间距为【n×（水平或垂直移动单位）】。
 */
- (Boolean)esc_right_space:(NSInteger)n {
    Byte esc_right_space[3];
    esc_right_space[0] = 0x1B;
    esc_right_space[1] = 0x20;
    if(n < 0) esc_right_space[2] = 0x00;
    else if(0 <= n && n <= 255) esc_right_space[2] = (Byte)n;
    else if(n > 255) esc_right_space[2] = 0xFF;
    return [self.bleManager writeCmd:esc_right_space cmdLenth:sizeof(esc_right_space)];
}

// 通过
/**
 * 10、选择打印模式。
 *  @param n 当n=0时选择字符字体A，当n=1时选择字符字体B，当n=2时表示选择字符字体C，当n=3时表示选择字符字体D；
 *           当n=8时选择字符加粗模式，当n=16时选择字符倍高模式，当n=32时选择字符倍宽模式，当n=128时选择字符下划线模式。
 *           此命令字体、加粗模式、倍高模式、倍宽模式、下划线模式同时设置。若要多种效果叠加，只需将相应的值相加即可
 *           （例如若要B字体加粗，只需将n=1+8即n=9传入）。
 */
- (Boolean)esc_print_mode:(NSInteger)n {
    Byte esc_print_mode[3];
    esc_print_mode[0] = 0x1B;
    esc_print_mode[1] = 0x21;
    
    if(n <= 0) esc_print_mode[2] = 0x00;
    else if(n == 1) esc_print_mode[2] = 0x01;
    else if(n == 2) esc_print_mode[2] = 0x02;
    else if(n == 3) esc_print_mode[2] = 0x03;
    else if(n == 8) esc_print_mode[2] = 0x08;
    else if(n == 16) esc_print_mode[2] = 0x10;
    else if(n == 32) esc_print_mode[2] = 0x20;
    else if(n == 128) esc_print_mode[2] = 0x80;
    else if(n >= 255) esc_print_mode[2] = 0xFF;
    else esc_print_mode[2] = (Byte)n;
    return [self.bleManager writeCmd:esc_print_mode cmdLenth:sizeof(esc_print_mode)];
}

// 通过
/**
 * 11、设置绝对打印位置。
 * 将当前位置设置到距离行首（nL+nH×256）×（横向或纵向移动单位）处。当nL＜0或nL＞255时将nL设置为0，当nH＜0或nH＞255时将nH设置为0。
 *
 */
- (Boolean)esc_absolute_print_position:(NSInteger)nL nH:(NSInteger)nH {
    Byte esc_right_space[4];
    esc_right_space[0] = 0x1B;
    esc_right_space[1] = 0x24;
    
    if(nL < 0 || nL > 255) esc_right_space[2] = 0x00;
    else esc_right_space[2] = nL;
    
    if(nH < 0 || nH > 255) esc_right_space[3] = 0x00;
    else esc_right_space[3] = nH;
    return [self.bleManager writeCmd:esc_right_space cmdLenth:sizeof(esc_right_space)];
}

/**
 * 12、选择位图模式打印图片。
 * @param m m表示位图模式。当m=1时位图模式为8点双密度，当m=32时位图模式为24点单密度，当m=33时位图模式为24点双密度，
 *          除m=1,32,33之外位图模式都为8点单密度。
 * @param bitmap bitmap为要打印的位图。由于打印纸宽度有限，图片不可太大。
 */
//public boolean esc_bitmap_mode(int m ,Bitmap bitmap){
//    if(m != 1 && m != 32 && m != 33) m = 0;
//    bitmap = Bitmap.createBitmap(bitmap);
//    
//    int width = bitmap.getWidth();
//    int height = bitmap.getHeight();
//    int heightbytes = (height - 1) / 8 + 1;
//    
//    int bufsize = width * heightbytes;
//    byte[] maparray = new byte[bufsize];
//    int[] pixels = new int[width * height];
//    
//    bitmap.getPixels(pixels, 0, width, 0, 0, width, height);
//    /**解析图片 获取位图数据**/
//    for (int j = 0; j < height; j++) {
//        for (int i = 0; i < width; i++) {
//            int pixel = pixels[width * j + i];
//            if (pixel != Color.WHITE) {//如果不是空白的话用黑色填充    这里如果童鞋要过滤颜色在这里处理
//                maparray[i + (j / 8) * width] |= (byte) (0x80 >> (j % 8));
//            }
//        }
//    }
//    byte[] Cmd = new byte[5];
//    byte[] pictureTop = new byte[]{0x1B,0x33,0x00};
//    if(!mBluetoothPort.write(pictureTop,0,pictureTop.length)){
//        return false;
//    }
//    /**对位图数据进行处理**/
//    for (int i = 0; i < heightbytes; i++) {
//        Cmd[0] = 0x1B;
//        Cmd[1] = 0x2A;
//        Cmd[2] = (byte) m;
//        Cmd[3] = (byte) (width % 256);
//        Cmd[4] = (byte) (width / 256);
//        if(!mBluetoothPort.write(Cmd,0,5)){return false;}
//        if(!mBluetoothPort.write(maparray, i * width, width)){return false;}
//        if(!mBluetoothPort.write(new byte[]{0x0D,0x0A},0,2)){return false;}
//    }
//    return true;
//}

typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

/**
 * 12、选择位图模式打印图片。
 * @param m m表示位图模式。当m=1时位图模式为8点双密度，当m=32时位图模式为24点单密度，当m=33时位图模式为24点双密度，
 *          除m=1,32,33之外位图模式都为8点单密度。
 * @param image bitmap为要打印的位图。由于打印纸宽度有限，图片不可太大。
 */
- (Boolean)esc_bitmap_mode:(NSUInteger)m iamge:(UIImage *)image {
    if(m != 1 && m != 32 && m != 33) m = 0;
//    UIImage *image = [img initWithCGImage:img.CGImage scale:(1/scale) orientation:UIImageOrientationUp];
    NSLog(@"%@", NSStringFromCGSize(image.size));
    
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    // 因为打印机只能打印黑和白，不支持灰度，为了减少传输数据量，将每个像素二值化后压缩为1位，1表示黑，0表示白
    NSUInteger heightbytes = (height - 1) / 8 + 1;
    Byte *maparray = (Byte *) calloc(width * heightbytes, sizeof(Byte));
    memset(maparray, width * heightbytes, sizeof(Byte));
    
    /**解析图片 获取位图数据**/
    for (int j = 0; j < height; j++) {
        for (int i = 0; i < width; i++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[width * j + i];
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            if (gray < 180) {//如果不是空白的话用黑色填充    这里如果童鞋要过滤颜色在这里处理
                maparray[i + (j / 8) * width] |= (Byte) (0x80 >> (j % 8));
            }
        }
    }
    
    {
        Byte cmd[] = {0x1B, 0x40};
        [self.bleManager writeCmd:cmd cmdLenth:sizeof(cmd)];
    }
    
    {
        Byte cmd[] = {0x1B, 0x33, 0x01};
        [self.bleManager writeCmd:cmd cmdLenth:sizeof(cmd)];
    }
    

    
    /**对位图数据进行处理**/
    for (int i = 0; i < heightbytes; i++) {
        {
            Byte Cmd[5];
            Cmd[0] = 0x1B;
            Cmd[1] = 0x2A;
            Cmd[2] = (Byte) m;
            Cmd[3] = (Byte) (width % 256);
            Cmd[4] = (Byte) (width / 256);
            
            if (![self.bleManager writeCmd:Cmd cmdLenth:sizeof(Cmd)]) {
                return NO;
            }
        }
        
        if (![self.bleManager writeCmd:&maparray[i * width] cmdLenth:width]) {
            return NO;
        }
        
        Byte temp[] = {0x0D, 0x0A};
        [self.bleManager writeCmd:temp cmdLenth:sizeof(temp)];
    }
    
    free(pixels);
    free(maparray);
    
    return true;
}


///**
// * 12、选择位图模式打印图片。
// * @param m m表示位图模式。当m=1时位图模式为8点双密度，当m=32时位图模式为24点单密度，当m=33时位图模式为24点双密度，
// *          除m=1,32,33之外位图模式都为8点单密度。
// * @param image bitmap为要打印的位图。由于打印纸宽度有限，图片不可太大。
// */
//- (Boolean)esc_bitmap_mode:(NSUInteger)m iamge:(UIImage *)image {
//    if(m != 1 && m != 32 && m != 33) m = 0;
//    
//    NSLog(@"%@", NSStringFromCGSize(image.size));
//    // 1. Get pixels of image
//    CGImageRef inputCGImage = [image CGImage];
//    NSUInteger width = CGImageGetWidth(inputCGImage);
//    NSUInteger height = CGImageGetHeight(inputCGImage);
//    
//    NSUInteger bytesPerPixel = 4;
//    NSUInteger bytesPerRow = bytesPerPixel * width;
//    NSUInteger bitsPerComponent = 8;
//    
//    UInt32 * pixels;
//    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
//                                                 bitsPerComponent, bytesPerRow, colorSpace,
//                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
//    
//    CGColorSpaceRelease(colorSpace);
//    CGContextRelease(context);
//    
//#define Mask8(x) ( (x) & 0xFF )
//#define R(x) ( Mask8(x) )
//#define G(x) ( Mask8(x >> 8 ) )
//#define B(x) ( Mask8(x >> 16) )
//    
//    // 将
//    NSUInteger dataWidth = (width - 1)/8 + 1;
//    NSUInteger dataHeight = height;
//    unsigned char dataByte[dataWidth * dataHeight];
//    
//    for (NSUInteger i = 0; i < dataHeight * dataWidth; i++) {
//        dataByte[i] = 0;
//    }
//    
//    UInt32 * currentPixel = pixels;
//    for (NSUInteger i = 0; i < height; i++) {
//        for (NSUInteger j = 0; j < width; j++) {
//            UInt32 color = *currentPixel;
//            UInt8 colored = (R(color)+G(color)+B(color))/3.0;
//            
//            if (colored < 180) {// 该像素二值化为1
//                dataByte[i * dataWidth + j/8] |= (0x80 >> (j % 8));
//            }
//            currentPixel++;
//        }
//    }
//    
////    {
////        Byte cmd[] = {0x1B, 0x40};
////        [self.bleManager writeCmd:cmd cmdLenth:sizeof(cmd)];
////    }
////    
////    {
////        Byte cmd[] = {0x1B, 0x33, 0x01};
////        [self.bleManager writeCmd:cmd cmdLenth:sizeof(cmd)];
////    }
//    
////    {
////        Byte cmd[] = {0x0D, 0x0A};
////        [self.bleManager writeCmd:cmd cmdLenth:sizeof(cmd)];
////    }
//    
//    {
//        Byte Cmd[8];
//        Cmd[0] = 0x1D;
//        Cmd[1] = 0x76;
//        Cmd[2] = 0x30;
//        Cmd[3] = (Byte) m;
//        Cmd[4] = (Byte) (dataWidth % 256);
//        Cmd[5] = (Byte) (dataWidth / 256);
//        Cmd[6] = (Byte) (dataHeight % 256);
//        Cmd[7] = (Byte) (dataHeight / 256);
//        
//        [self.bleManager writeCmd:Cmd cmdLenth:sizeof(Cmd)];
//    }
//    
//    [self.bleManager writeCmd:dataByte cmdLenth:sizeof(dataByte)];
//    
////    {
////        Byte cmd[] = {0x0D, 0x0A};
////        [self.bleManager writeCmd:cmd cmdLenth:sizeof(cmd)];
////    }
//    
//    free(pixels);
//    
//#undef R
//#undef G
//#undef B
//    
//    return true;
//}

// 通过
/**
 * 13、设置默认行高。
 * 将行间距设为约 3.75mm{30/203"}。
 */
- (Boolean)esc_default_line_height {
    Byte esc_default_line_height[] = {0x1B, 0x32};
    return [self.bleManager writeCmd:esc_default_line_height cmdLenth:sizeof(esc_default_line_height)];
}

// 通过
/**
 * 14、设置行高
 * 设置行高为[n×纵向或横向移动单位]英寸。
 *  @param n n表示行高值。当n＜0时设置行高为0，当n＞255时设置行高为255[n×纵向或横向移动单位]英寸，
 *           当0≤n≤255时设置行高为[n×纵向或横向移动单位]英寸。
 */
- (Boolean)esc_line_height:(NSInteger)n {
    Byte esc_line_height[3];
    esc_line_height[0] = 0x1B;
    esc_line_height[1] = 0x33;
    if(n < 0) esc_line_height[2] = 0x00;
    else if(n > 255) esc_line_height[2] = 0xFF;
    else esc_line_height[2] = n;
    return [self.bleManager writeCmd:esc_line_height cmdLenth:sizeof(esc_line_height)];
}

/**
 * 15、设置水平制表符位置。
 * @param n n的长度表示横向跳格数，n[k]表示第k个跳格位置的值。当n的长度大于32时，只取前32个值；当n[k]大于等于n[k-1]时忽略该命令。
 *          当n[k]≤0或n[k]≥255时，忽略该命令。
 */
- (Boolean)esc_horizontal_tab_position:(NSArray *)n {
    Byte esc_horizontal_tab_position_top[] = {0x1B, 0x44};
    NSMutableArray *targetB = [NSMutableArray arrayWithCapacity:32];
    
    if (n.count > 32) {
        NSArray *targetI = [n subarrayWithRange:NSMakeRange(0, 32)];
        targetB[0] = targetI.firstObject;
        for (int i = 1; i < targetI.count; i++) {
            if (targetI[i] <= targetI[i - 1]) return false;
            targetB[i] = targetI[i];
        }
        
        [self.bleManager writeCmd:esc_horizontal_tab_position_top cmdLenth:sizeof(esc_horizontal_tab_position_top)];
        NSMutableData *data = [NSMutableData data];
        for (NSNumber *object in targetB) {
            Byte element = [object unsignedCharValue];
            [data appendBytes:&element length:1];
        }
        return [self.bleManager writeData:data];
    } else {
        NSMutableArray *target = [NSMutableArray arrayWithCapacity:n.count];
        target[0] = n[0];
        for (int i = 1; i < n.count; i++) {
            if (n[i] <= n[i - 1]) return false;
            target[i] = n[i];
        }
        [self.bleManager writeCmd:esc_horizontal_tab_position_top cmdLenth:sizeof(esc_horizontal_tab_position_top)];
        NSMutableData *data = [NSMutableData data];
        for (NSNumber *object in target) {
            Byte element = [object unsignedCharValue];
            [data appendBytes:&element length:1];
        }
        return [self.bleManager writeData:data];
    }
}

// 通过
/**
 * 16、打印并进纸。
 * @param n 当0≤n≤255时打印缓冲区数据并进纸【n×纵向或横向移动单位】英寸。当n＜0时进纸0，当n＞255时进纸【255×纵向或横向移动单位】英寸。
 */
- (Boolean)esc_print_formfeed:(NSInteger)n {
    Byte esc_print_formfeed[3];
    esc_print_formfeed[0] = 0x1B;
    esc_print_formfeed[1] = 0x4A;
    if(n < 0) esc_print_formfeed[2] = 0x00;
    else if(n > 255) esc_print_formfeed[2] = 0xFF;
    else esc_print_formfeed[2] = n;
    return [self.bleManager writeCmd:esc_print_formfeed cmdLenth:sizeof(esc_print_formfeed)];
}

// 不生效，调用esc_print_mode生效
/**
 * 17、选择字体。
 * @param n 当n=1或n=49时选择字体B，当n=2或n=50时选择字体C，当n=3或n=51时选择字体D，当n为其他值时选择字体A。
 */
- (Boolean)esc_font:(NSInteger)n {
    Byte esc_font[] = {0x1B, 0x4D, 0x00};
    esc_font[0] = 0x1B;
    esc_font[1] = 0x4D;
    if(n == 1 || n == 49) esc_font[2] = 0x01;
    else if(n == 2 || n == 50) esc_font[2] = 0x02;
    else if(n == 3 || n == 51) esc_font[2] = 0x03;
    else esc_font[2] = 0x00;
    return [self.bleManager writeCmd:esc_font cmdLenth:sizeof(esc_font)];
}

/**
 * 18、选择国际字符集。
 * @param n 当n≤0或n＞13时选择America字符集，当n=1时选择France字符集，当n=2时选择German字符集，当n=3时选择UK字符集，
 *          当n=4时选择Denmar字符集，当n=5时选择Sweden字符集，当n=6时选择Italy字符集，当n=7时选择Spain I字符集，当n=8时选择Japan字符集，
 *          当n=9时选择Norway字符集，当n=10时选择Denmar字符集，当n=11时选择Spain II字符集，当n=12时选择Latin字符集，当n=13时选择Korea字符集。
 */
- (Boolean)esc_national_character_set:(NSInteger)n {
    Byte esc_national_character_set[3];
    esc_national_character_set[0] = 0x1B;
    esc_national_character_set[1] = 0x52;
    if(n == 1) esc_national_character_set[2] = 0x01;
    else if(n == 2) esc_national_character_set[2] = 0x02;
    else if(n == 3) esc_national_character_set[2] = 0x03;
    else if(n == 4) esc_national_character_set[2] = 0x04;
    else if(n == 5) esc_national_character_set[2] = 0x05;
    else if(n == 6) esc_national_character_set[2] = 0x06;
    else if(n == 7) esc_national_character_set[2] = 0x07;
    else if(n == 8) esc_national_character_set[2] = 0x08;
    else if(n == 9) esc_national_character_set[2] = 0x09;
    else if(n == 10) esc_national_character_set[2] = 0x0A;
    else if(n == 11) esc_national_character_set[2] = 0x0B;
    else if(n == 12) esc_national_character_set[2] = 0x0C;
    else if(n == 13) esc_national_character_set[2] = 0x0D;
    else esc_national_character_set[2] = 0x00;
    return [self.bleManager writeCmd:esc_national_character_set cmdLenth:sizeof(esc_national_character_set)];
}

// 通过
/**
 * 19、选择/取消顺时针旋转90°。
 * @param n 当n=1或n=49时设置90°顺时针旋转模式，当n=2或n=50时设置180°顺时针旋转模式，当n=3或n=51时设置270°顺时针旋转模式，
 *          当n取其他值时取消旋转模式。
 */
- (Boolean)esc_rotate:(NSInteger)n {
    Byte esc_rotate[3];
    esc_rotate[0] = 0x1B;
    esc_rotate[1] = 0x56;
    if(n == 1 || n == 49) esc_rotate[2] = 0x01;
    else if(n == 2 || n == 50) esc_rotate[2] = 0x02;
    else if(n == 3 || n == 51) esc_rotate[2] = 0x03;
    else esc_rotate[2] = 0x00;
    return [self.bleManager writeCmd:esc_rotate cmdLenth:sizeof(esc_rotate)];
}

/**
 * 20、设定相对打印位置。
 * 将打印位置从当前位置移至（nL+nH×256）×（水平或垂直运动单位）。当nL＜0时设置nL=0，当nL＞255时设置nL=255。
 * 当nH＜0时设置nH=0，当nH＞255时设置nH=255。
 */
- (Boolean)esc_relative_print_position:(NSInteger)nL nH:(NSInteger)nH {
    Byte esc_relative_print_position[4];
    esc_relative_print_position[0] = 0x1B;
    esc_relative_print_position[1] = 0x5C;
    
    if(nL < 0) esc_relative_print_position[2] = 0x00;
    else if(nL > 255) esc_relative_print_position[2] = 0xFF;
    else esc_relative_print_position[2] = nL;
    
    if(nH < 0) esc_relative_print_position[3] = 0x00;
    else if(nH > 255) esc_relative_print_position[3] = 0xFF;
    else esc_relative_print_position[3] = nH;
    return [self.bleManager writeCmd:esc_relative_print_position cmdLenth:sizeof(esc_relative_print_position)];
}

// 通过
/**
 * 21、选择对齐模式。
 * @param n 当n=1或n=49时选择居中对齐，当n=2或n=50时选择右对齐，当n取其他值时选择左对齐。
 */
- (Boolean)esc_align:(NSInteger)n {
    Byte esc_align[3];
    esc_align[0] = 0x1B;
    esc_align[1] = 0x61;
    if(n == 1 || n == 49) esc_align[2] = 0x01;
    else if(n == 2 || n == 50) esc_align[2] = 0x02;
    else esc_align[2] = 0x00;
    return [self.bleManager writeCmd:esc_align cmdLenth:sizeof(esc_align)];
}

// 通过
/**
 * 22、打印并向前走纸n行。
 * @param n 当n＜0时进纸0行，当n＞255时进纸255行，当0≤n≤255时进纸n行。
 */
- (Boolean)esc_print_formfeed_row:(NSInteger)n {
    Byte esc_print_formfeed_row[3];
    esc_print_formfeed_row[0] = 0x1B;
    esc_print_formfeed_row[1] = 0x64;
    if(n < 0) esc_print_formfeed_row[2] = 0x00;
    else if(n > 255) esc_print_formfeed_row[2] = 0xFF;
    else esc_print_formfeed_row[2] = n;
    return [self.bleManager writeCmd:esc_print_formfeed_row cmdLenth:sizeof(esc_print_formfeed_row)];
}

/**
 * 23、选择字符代码页。
 * @param n 当n=1时选择Page 1 Katakana，当n=2时选择Page 2 Multilingual(Latin-1) [CP850]，当n=3时选择Page 3 Portuguese [CP860]，
 *          当n=4时选择Page 4 Canadian-French [CP863]，当n=5时选择Page 5 Nordic [CP865]，当n=6时选择Page 6 Slavic(Latin-2) [CP852]，
 *          当n=7时选择Page 7 Turkish [CP857]，当n=8时选择Page 8 Greek [CP737]，当n=9时选择Page 9 Russian(Cyrillic) [CP866]，
 *          当n=10时选择Page 10 Hebrew [CP862]，当n=11时选择Page 11 Baltic [CP775]，当n=12时选择Page 12 Polish，
 *          当n=13时选择Page 13 Latin-9 [ISO8859-15]，当n=14时选择Page 14 Latin1[Win1252]，当n=15时选择Page 15 Multilingual Latin I + Euro[CP858]，
 *          当n=16时选择Page 16 Russian(Cyrillic)[CP855]，当n=17时选择Page 17 Russian(Cyrillic)[Win1251]，当n=18时选择Page 18 Central Europe[Win1250]，
 *          当n=19时选择Page 19 Greek[Win1253]，当n=20时选择Page 20 Turkish[Win1254]，当n=21时选择Page 21 Hebrew[Win1255]，
 *          当n=22时选择Page 22 Vietnam[Win1258]，当n=23时选择Page 23 Baltic[Win1257]，当n=24时选择Page 24 Azerbaijani，
 *          当n=30时选择Thai[CP874]Thai[CP874]，当n=40时选择Page 25 Arabic [CP720]，当n=41时选择Page 26 Arabic [Win 1256]，
 *          当n=42时选择Page 27 Arabic (Farsi)，当n=43时选择Page 28 Arabic presentation forms B，当n=50时选择Page 29 Page 25 Hindi_Devanagari，
 *          当n=252时选择Page 30 Japanese[CP932]，当n=253时选择Page 31 Korean[CP949]，当n=254时选择Page 32 Traditional Chinese[CP950]，
 *          当n=255时选择Page 33 Simplified Chinese[CP936]。
 *          当n取其他值时选择else if(n == 252) esc_character_code_page[2] = 0x01。
 */
- (Boolean)esc_character_code_page:(NSInteger)n {
    Byte esc_character_code_page[3];
    esc_character_code_page[0] = 0x1B;
    esc_character_code_page[1] = 0x74;
    if(n == 1) esc_character_code_page[2] = 1;
    else if(n == 2) esc_character_code_page[2] = 2;
    else if(n == 3) esc_character_code_page[2] = 3;
    else if(n == 4) esc_character_code_page[2] = 4;
    else if(n == 5) esc_character_code_page[2] = 5;
    else if(n == 6) esc_character_code_page[2] = 6;
    else if(n == 7) esc_character_code_page[2] = 7;
    else if(n == 8) esc_character_code_page[2] = 8;
    else if(n == 9) esc_character_code_page[2] = 9;
    else if(n == 10) esc_character_code_page[2] = 10;
    else if(n == 11) esc_character_code_page[2] = 11;
    else if(n == 12) esc_character_code_page[2] = 12;
    else if(n == 13) esc_character_code_page[2] = 13;
    else if(n == 14) esc_character_code_page[2] = 14;
    else if(n == 15) esc_character_code_page[2] = 15;
    else if(n == 16) esc_character_code_page[2] = 16;
    else if(n == 17) esc_character_code_page[2] = 17;
    else if(n == 18) esc_character_code_page[2] = 18;
    else if(n == 19) esc_character_code_page[2] = 19;
    else if(n == 20) esc_character_code_page[2] = 20;
    else if(n == 21) esc_character_code_page[2] = 21;
    else if(n == 22) esc_character_code_page[2] = 22;
    else if(n == 23) esc_character_code_page[2] = 23;
    else if(n == 24) esc_character_code_page[2] = 24;
    else if(n == 30) esc_character_code_page[2] = 30;
    else if(n == 40) esc_character_code_page[2] = 40;
    else if(n == 41) esc_character_code_page[2] = 41;
    else if(n == 42) esc_character_code_page[2] = 42;
    else if(n == 43) esc_character_code_page[2] = 43;
    else if(n == 50) esc_character_code_page[2] = 50;
    else if(n == 252) esc_character_code_page[2] = 252;
    else if(n == 253) esc_character_code_page[2] = 253;
    else if(n == 254) esc_character_code_page[2] = 254;
    else if(n == 255) esc_character_code_page[2] = 255;
    else esc_character_code_page[2] = 0x00;
    return [self.bleManager writeCmd:esc_character_code_page cmdLenth:sizeof(esc_character_code_page)];
}

// 4倍不生效
/**
 * 24、选择字符大小。
 * @param n 当n=2时2倍高，当n=3时3倍高，当n=4时4倍高，当n=20时2倍宽，当n=30时3倍宽，当n=40时4倍宽，当n=22时2倍宽高，当n=33时3倍宽高，
 *          当n=44时4倍宽高，当n取其他值时1倍宽高。
 */
- (Boolean)esc_character_size:(NSInteger)n {
    Byte esc_character_size[3];
    esc_character_size[0] = 0x1D;
    esc_character_size[1] = 0x21;
    if(n == 2) esc_character_size[2] = 0x01;
    else if(n == 3) esc_character_size[2] = 0x02;
    else if(n == 4) esc_character_size[2] = 0x03;
    else if(n == 20) esc_character_size[2] = 0x10;
    else if(n == 30) esc_character_size[2] = 0x20;
    else if(n == 40) esc_character_size[2] = 0x30;
    else if(n == 22) esc_character_size[2] = 0x11;
    else if(n == 33) esc_character_size[2] = 0x22;
    else if(n == 44) esc_character_size[2] = 0x33;
    else esc_character_size[2] = 0x00;
    return [self.bleManager writeCmd:esc_character_size cmdLenth:sizeof(esc_character_size)];
}

/**
 * 25、定义并打印下载位图。
 * @param x x表示位图的横向点数（1≤x≤255），
 * @param y y表示位图的纵向点数（1≤y≤48）。
 * @param data data的长度等于x*y*8（1≤x*y≤1536），表示位图字节数，除以上取值外其他取值均忽略此命令。
 * @param m m表示打印下载位图的模式，当m=1或m=49时设置倍宽模式，当m=2或m=50时设置倍高模式，当m=3或m=51时设置倍宽倍高模式，
 *          当m取其他值时设置普通模式打印所下载的位图。
 */
- (Boolean)esc_define_print_download_bitmap:(NSInteger)x y:(NSInteger)y data:(NSArray *)data mode:(NSInteger)m {
    Byte esc_define_download_bitmap[4];
    esc_define_download_bitmap[0] = 0x1D;
    esc_define_download_bitmap[1] = 0x2A;
    if(x<1 || x>255 || y<1 || y>48 || (x*y)>1536 || data.count!=(x*y*8)) return false;
    esc_define_download_bitmap[2] = x;
    esc_define_download_bitmap[3] = y;
    
    NSMutableData *tempData = [NSMutableData data];
    for (NSNumber *object in data) {
        Byte element = [object unsignedCharValue];
        [tempData appendBytes:&element length:1];
    }
    
    [self.bleManager writeCmd:esc_define_download_bitmap cmdLenth:sizeof(esc_define_download_bitmap)];
    [self.bleManager writeData:tempData];
    
    Byte esc_print_download_bitmap[3];
    esc_print_download_bitmap[0] = 0x1D;
    esc_print_download_bitmap[1] = 0x2F;
    if(m == 1 || m == 49) esc_print_download_bitmap[2] = 0x01;
    else if(m == 2 || m == 50) esc_print_download_bitmap[2] = 0x02;
    else if(m == 3 || m == 51) esc_print_download_bitmap[2] = 0x03;
    else esc_print_download_bitmap[2] = 0x00;
    return [self.bleManager writeCmd:esc_print_download_bitmap cmdLenth:sizeof(esc_print_download_bitmap)];
}

// 通过
/**
 * 26、选择/取消黑白反显打印模式。
 * @param b 当b为true时选择黑白反显打印模式，当b为false时取消黑白反显打印模式。
 */
- (Boolean)esc_black_white_reverse:(Boolean)b {
    Byte esc_black_white_reverse[3];
    esc_black_white_reverse[0] = 0x1D;
    esc_black_white_reverse[1] = 0x42;
    if(!b) esc_black_white_reverse[2] = 0x00;
    else if(b) esc_black_white_reverse[2] = 0x01;
    return [self.bleManager writeCmd:esc_black_white_reverse cmdLenth:sizeof(esc_black_white_reverse)];
}

// 通过
/**
 * 27、设定左边距。
 * 当0≤nL≤255且0≤nH≤255时，将左边距设为【(nL+nH×256)×(水平移动单位)】。当nL和nH取其他值时将左边距设为0。
 */
- (Boolean)esc_left_margin:(NSInteger)nL nH:(NSInteger)nH {
    Byte esc_left_margin[4];
    esc_left_margin[0] = 0x1D;
    esc_left_margin[1] = 0x4C;
    if(0 <= nL && nL <= 255 && 0 <= nH && nH <= 255) {
        esc_left_margin[2] = nL;
        esc_left_margin[3] = nH;
    }
    else {
        esc_left_margin[2] = 0x00;
        esc_left_margin[3] = 0x00;
    }
    return [self.bleManager writeCmd:esc_left_margin cmdLenth:sizeof(esc_left_margin)];
}

/**
 * 28、设定横向和纵向移动单位。
 * 当0≤x≤255且0≤y≤255时分别将水平和垂直移动单位设为25.4/x毫米和25.4/y毫米。当x和y取其他值时取x=0和Y=0。
 */
- (Boolean)esc_move_unit:(NSInteger)x y:(NSInteger)y {
    Byte esc_move_unit[4];
    esc_move_unit[0] = 0x1D;
    esc_move_unit[1] = 0x50;
    if(0 <= x && x <= 255 && 0 <= y && y <= 255) {
        esc_move_unit[2] = (Byte)x;
        esc_move_unit[3] = (Byte)y;
    }
    else {
        esc_move_unit[2] = 0x00;
        esc_move_unit[3] = 0x00;
    }
    return [self.bleManager writeCmd:esc_move_unit cmdLenth:sizeof(esc_move_unit)];
}

/**
 * 29、设定打印区域宽度。
 * 当0≤nL≤255且0≤nH≤255时,将打印区域宽度设为（nL+nH×256）×（水平移动单位）。当nL和nH取其他值时取nL=0和nH=0。
 */
- (Boolean)esc_print_area_width:(NSInteger)nL nH:(NSInteger)nH {
    Byte esc_print_area_width[4];
    esc_print_area_width[0] = 0x1D;
    esc_print_area_width[1] = 0x57;
    if(0 <= nL && nL <= 255 && 0 <= nH && nH <= 255) {
        esc_print_area_width[2] = (Byte) nL;
        esc_print_area_width[3] = (Byte) nH;
    }
    else {
        esc_print_area_width[2] = 0x00;
        esc_print_area_width[3] = 0x00;
    }
    return [self.bleManager writeCmd:esc_print_area_width cmdLenth:sizeof(esc_print_area_width)];
}

/**
 * 30、设定汉字模式。
 * @param b 当b为true时选择汉字模式，当b为false时取消汉字模式。
 */
- (Boolean)esc_chinese_mode:(Boolean)b {
    Byte esc_chinese_mode[2];
    esc_chinese_mode[0] = 0x1C;
    if(!b) esc_chinese_mode[1] = 0x2E;
    else esc_chinese_mode[1] = 0x26;
    return [self.bleManager writeCmd:esc_chinese_mode cmdLenth:sizeof(esc_chinese_mode)];
}

/**
 * 31、设置汉字字符模式。
 * @param n 当n=4时选择倍宽，当n=8时选择倍高，当n=128时选择下划线，当n=12时选择倍高倍宽，当n=132时选择倍宽下划线，当n=136时选择倍高下划线，
 *          当n=140时选择倍宽倍高下划线，当n取其他值时不选择倍高倍宽下划线。
 *          倍高、倍宽、下划线模式同时设置。
 */
- (Boolean)esc_chinese_character_mode:(NSInteger)n {
    Byte esc_chinese_character_mode[3];
    esc_chinese_character_mode[0] = 0x1C;
    esc_chinese_character_mode[1] = 0x21;
    if(n == 4) esc_chinese_character_mode[2] = 0x04;
    else if(n == 8) esc_chinese_character_mode[2] = 0x08;
    else if(n == 128) esc_chinese_character_mode[2] = (Byte) 128;
    else if(n == 12) esc_chinese_character_mode[2] =12;
    else if(n == 132) esc_chinese_character_mode[2] = (Byte) 132;
    else if(n == 136) esc_chinese_character_mode[2] = (Byte) 136;
    else if(n == 140) esc_chinese_character_mode[2] = (Byte) 140;
    else esc_chinese_character_mode[2] = 0x00;
    return [self.bleManager writeCmd:esc_chinese_character_mode cmdLenth:sizeof(esc_chinese_character_mode)];
}

/**
 * 32、选择/取消汉字下划线模式。
 * @param n 当n=1或n=49时选择汉字下划线（1点宽），当n=2或n=50时选择汉字下划线（2点宽），当n为其他值时不加下划线。
 */
- (Boolean)esc_chinese_character_underline_mode:(NSInteger)n {
    Byte esc_chinese_character_underline_mode[3];
    esc_chinese_character_underline_mode[0] = 0x1C;
    esc_chinese_character_underline_mode[1] = 0x2D;
    if(n == 1 || n== 49) esc_chinese_character_underline_mode[2] = 0x01;
    else if(n == 2 || n== 50) esc_chinese_character_underline_mode[2] = 0x02;
    else esc_chinese_character_underline_mode[2] = 0x00;
    return [self.bleManager writeCmd:esc_chinese_character_underline_mode cmdLenth:sizeof(esc_chinese_character_underline_mode)];
}

/**
 * 33、定义自定义汉字。
 * @param c2 c2表示自定义字符编码第二个字节,取值范围为A1H≤c2≤FEH，第一个字节为FEH，
 * @param data data表示自定义汉字的数据，1表示打印一个点，0表示不打印点。
 *             data的长度为72，若data的长度不等于72或data的每个元素值出现小于0或大于255的情况，则忽略该命令。
 */
- (Boolean)esc_define_chinese_character:(NSInteger)c2 data:(NSArray *)data {
    Byte esc_define_chinese_character[4];
    esc_define_chinese_character[0] = 0x1C;
    esc_define_chinese_character[1] = 0x32;
    esc_define_chinese_character[2] = (Byte) 0xFE;
    if(c2 < 0xA1 || c2 > 0xFE || (data.count != 72)) return false;
    for (NSNumber *value in data) {
        if (value.unsignedCharValue < 0 || value.unsignedCharValue > 255) {
            return false;
        }
    }
    esc_define_chinese_character[3] = (Byte) c2;
    [self.bleManager writeCmd:esc_define_chinese_character cmdLenth:sizeof(esc_define_chinese_character)];
    
    NSMutableData *tempData = [NSMutableData data];
    for (NSNumber *object in data) {
        Byte element = [object unsignedCharValue];
        [tempData appendBytes:&element length:1];
    }
    return [self.bleManager writeData:tempData];
}

/**
 * 34、选择/取消汉字倍高倍宽。
 * @param b 当b为true时选择汉字倍高倍宽模式，当b为false时取消汉字倍高倍宽模式。
 */
- (Boolean)esc_chinese_character_twice_height_width:(Boolean)b {
    Byte esc_chinese_character_twice_height_width[3];
    esc_chinese_character_twice_height_width[0] = 0x1C;
    esc_chinese_character_twice_height_width[1] = 0x57;
    if(!b) esc_chinese_character_twice_height_width[2] = 0x00;
    else esc_chinese_character_twice_height_width[2] = 0x01;
    return [self.bleManager writeCmd:esc_chinese_character_twice_height_width cmdLenth:sizeof(esc_chinese_character_twice_height_width)];
}

// 通过
/**
 * 35、打印并走纸到右黑标处。
 */
- (Boolean)esc_print_to_right_black_label {
    Byte esc_print_to_right_black_label[] = {0x0E};
    return [self.bleManager writeCmd:esc_print_to_right_black_label cmdLenth:sizeof(esc_print_to_right_black_label)];
}

// 通过
/**
 * 36、走纸到标签处。
 */
- (Boolean)esc_print_to_label {
    Byte esc_print_to_label[] = {0x1D, 0x0C};
    return [self.bleManager writeCmd:esc_print_to_label cmdLenth:sizeof(esc_print_to_label)];
}

/**
 * 37、打印光栅位图。
 * @param m m表示光栅位图模式，当m=1或m=49时选择倍宽模式，当m=2或m=50时选择倍高模式，当m=3或m=51时选择倍宽倍高模式。
 *           data表示要打印的光栅位图的数据，data的长度等于(xL+xH*256)*(yL+yH*256)，表示要打印的光栅位图数据长度，
 *           当xL<0或xL>255或xH<0或xH>255或yL<0或yL>255或yH<0或yH>255或data的长度不等于((xL+xH*256)*(yL+yH*256))或((xL+xH*256)*(yL+yH*256))等于0时忽略该命令。
 */
- (Boolean)esc_print_grating_bitmap:(NSInteger)m xL:(NSInteger)xL xH:(NSInteger)xH yL:(NSInteger)yL yH:(NSInteger)yH data:(NSArray *)data {
    Byte esc_print_grating_bitmap[8];
    esc_print_grating_bitmap[0] = 0x1D;
    esc_print_grating_bitmap[1] = 0x76;
    esc_print_grating_bitmap[2] = 0x30;
    if(m == 1 || m == 49) esc_print_grating_bitmap[3] = 0x01;
    else if(m == 2 || m == 50) esc_print_grating_bitmap[3] = 0x02;
    else if(m == 3 || m == 51) esc_print_grating_bitmap[3] = 0x03;
    else esc_print_grating_bitmap[3] = 0x00;
    if(xL < 0 || xL > 255 || xH < 0 || xH > 255 || yL < 0 || yL > 255 || yH < 0 || yH > 255 ||
       (data.count != (xL+xH*256)*(yL+yH*256)) || ((xL+xH*256)*(yL+yH*256)) == 0) return false;
    esc_print_grating_bitmap[4] = (Byte) xL;
    esc_print_grating_bitmap[5] = (Byte) xH;
    esc_print_grating_bitmap[6] = (Byte) yL;
    esc_print_grating_bitmap[7] = (Byte) yH;

    [self.bleManager writeCmd:esc_print_grating_bitmap cmdLenth:sizeof(esc_print_grating_bitmap)];
    
    NSMutableData *tempData = [NSMutableData data];
    for (NSNumber *object in data) {
        Byte element = [object unsignedCharValue];
        [tempData appendBytes:&element length:1];
    }
    return [self.bleManager writeData:tempData];
}

/**
 * 38、设置参数打印条码。
 * @param HRI_position HRI_position表示HRI字符打印位置(当HRI_position=1或HRI_position=49时HRI字符显示在条形码上方；
 *                     当HRI_position=2或HRI_position=50时HRI字符显示在条形码下方；当HRI_position取其他值时HRI字符不显示)。
 * @param HRI_font HRI_font表示HRI字符字体（当HRI_font=1或HRI_font=49时选择字体B，当HRI_font取其他值时选择字体A）。
 * @param width width表示条码宽度（当width=2时设置条形码宽度为2，当width=3时设置条形码宽度为3，当width取其他值时设置条形码宽度为1），
 * @param height height表示条码高度（当1<=height<=255时设置条码高度为height，当height取其他值时设置条码高度为162），
 * @param type type表示条码类型（当type=0或type=65时选择条码类型为UPC-A，当type=1或type=66时选择条码类型为UPC-E，
 *             当type=2或type=67时选择条码类型为EAN13，当type=3或type=68时选择条码类型为EAN8，当type=4或type=69时选择条码类型为CODE39，
 *             当type=5或type=70时选择条码类型为ITF，当type=6或type=71时选择条码类型为CODABAR，当type=7或type=72时选择条码类型为CODE93，
 *             当type=8或type=73时选择条码类型为CODE128），
 * @param content content表示条码内容（UPC-A（长度为11、12）、UPC-E（长度为7、8、11、12）、EAN13（长度为12、13）、EAN8（长度为7、8）、
 *                ITF（长度为大于2的偶数）只支持数字；
 *                CODE39（长度大于1且小于255，支持数字、英文、空格、‘$’、‘%’、‘*’、‘+’、‘-’、‘.’、‘/’）；
 *                CODE93（长度大于1且小于255，支持数字、英文、空格、‘$’、‘%’、‘+’、‘-’、‘.’、‘/’）；
 *                CODABAR（长度大于2且小于255，支持数字、英文ABCDabcd、‘$’、‘+’、‘-’、‘.’、‘/’、‘:’）；
 *                CODE128（长度大于2且小于255，支持所有英文）。
 */
- (Boolean)esc_barcode_1d:(NSInteger)HRI_position HRI_font:(NSInteger)HRI_font width:(NSInteger)width height:(NSInteger)height type:(NSInteger)type content:(NSString *)content {
    Byte esc_barcode_1d_width[] = {0x1D, 0x77, 0x00};
    if(width == 2) esc_barcode_1d_width[2] = 0x02;
    else if(width == 3) esc_barcode_1d_width[2] = 0x03;
    else esc_barcode_1d_width[2] = 0x01;
    [self.bleManager writeCmd:esc_barcode_1d_width cmdLenth:sizeof(esc_barcode_1d_width)];
    
    Byte esc_barcode_1d_HRI_position[] = {0x1D, 0x48, 0x00};
    if(HRI_position == 1 || HRI_position ==49) esc_barcode_1d_HRI_position[2] = 0x01;
    else if(HRI_position == 2 || HRI_position ==50) esc_barcode_1d_HRI_position[2] = 0x02;
    else esc_barcode_1d_HRI_position[2] = 0x00;
    [self.bleManager writeCmd:esc_barcode_1d_HRI_position cmdLenth:sizeof(esc_barcode_1d_HRI_position)];
    
    Byte esc_barcode_1d_HRI_font[] = {0x1D, 0x66, 0x00};
    if(HRI_font == 1 || HRI_font ==49) esc_barcode_1d_HRI_font[2] = 0x01;
    else esc_barcode_1d_HRI_font[2] = 0x00;
    [self.bleManager writeCmd:esc_barcode_1d_HRI_font cmdLenth:sizeof(esc_barcode_1d_HRI_font)];
    
    Byte esc_barcode_1d_height[] = {0x1D,0x68, 0xA2};
    if(height <= 0 || height > 255) esc_barcode_1d_height[2] = 0xA2;
    else esc_barcode_1d_height[2] =  height;
    [self.bleManager writeCmd:esc_barcode_1d_height cmdLenth:sizeof(esc_barcode_1d_height)];
    
    if(type == 0 || type == 65) type = 0;
    else if(type == 1 || type == 66) type = 1;
    else if(type == 2 || type == 67) type = 2;
    else if(type == 3 || type == 68) type = 3;
    else if(type == 4 || type == 69) type = 4;
    else if(type == 5 || type == 70) type = 5;
    else if(type == 6 || type == 71) type = 6;
    else if(type == 7 || type == 72) type = 7;
    else if(type == 8 || type == 73) type = 8;
    else type = 8 ;
    Byte esc_barcode_1d_type[] = {0x1D, 0x6B, (Byte)type};
    [self.bleManager writeCmd:esc_barcode_1d_type cmdLenth:sizeof(esc_barcode_1d_type)];
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [self.bleManager writeData:data];
//    [self.bleManager writeText:content];
    Byte esc_barcode_1d_content_end[] = {0x00};
    return [self.bleManager writeCmd:esc_barcode_1d_content_end cmdLenth:sizeof(esc_barcode_1d_content_end)];
}

/**
 * 39、打印二维码。
 * @param type type表示二维码类型，当type=0时选择PDF417，当type=2时选择DATAMATRIX，当type取其他值时选择QRCODE。
 * @param content content表示要打印的二维码内容。
 */
- (Boolean)esc_print_barcode_2d:(NSInteger)type content:(NSString *)content {
    if(type == 0) type = 10;
    else if(type == 2) type = 12;
    else type = 0x20;
    Byte esc_print_barcode_2d_type[] = {0x1D,0x6B, (Byte)type};
    [self.bleManager writeCmd:esc_print_barcode_2d_type cmdLenth:sizeof(esc_print_barcode_2d_type)];
    
    [self.bleManager writeText:content];
    
    Byte esc_barcode_1d_content_end[] = {0x00};
    return [self.bleManager writeCmd:esc_barcode_1d_content_end cmdLenth:sizeof(esc_barcode_1d_content_end)];
}

@end
