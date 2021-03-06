//
//  JQESCTool.h
//  bleDemo
//
//  Created by wuyaju on 2017/6/22.
//  Copyright © 2017年 wuyaju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class UIImage;

@interface JQESCTool : NSObject

+ (instancetype)ESCManager;

/**
 * 1、打印文本。
 * @param text 表示所要打印的文本内容。
 */
- (Boolean)esc_print_text:(NSString *)text;

/**
 * 2、初始化打印机。
 * 使所有设置恢复到打印机开机时的默认值模式。
 */
- (Boolean)esc_reset;

/**
 * 3、选择加粗模式。
 *
 * @param b b为true时选择加粗模式，b为false时取消加粗模式。
 */
- (Boolean)esc_bold:(Boolean)b;

/**
 * 4、选择/取消下划线模式。
 * @param n 当n=1或n=49时选择下划线模式且设置为1点宽，当n=2或n=50时选择下划线模式且设置为2点宽，当n取其他值时取消下划线模式。
 */
- (Boolean)esc_underline:(NSInteger)n;

/**
 * 5、打印和行进。
 * 基于当前的行间距，打印缓冲区内的数据并走纸一行。
 */
- (Boolean)esc_print_formfeed;

/**
 * 6、水平制表符。
 * 将打印位置移动至下一水平制表符位置。
 */
- (Boolean)esc_next_horizontal_tab;

/**
 * 7、打印并走纸到左黑标处。
 * 将打印缓冲区中的数据全部打印出来并走纸到左黑标处。
 */
- (Boolean)esc_left_black_label;

/**
 * 8、打印并回车。
 * 该指令等同于LF指令，既打印缓冲区内的数据并走纸一字符行。
 */
- (Boolean)esc_print_enter;

/**
 * 9、设定右侧字符间距。
 * @param  n 当n＜0时设定右侧字符间距为0，当n＞255时设定右侧字符间距为【255×（水平或垂直移动单位）】,
 *           当0≤n≤255时设定右侧字符间距为【n×（水平或垂直移动单位）】。
 */
- (Boolean)esc_right_space:(NSInteger)n;

/**
 * 10、选择打印模式。
 *  @param n 当n=0时选择字符字体A，当n=1时选择字符字体B，当n=2时表示选择字符字体C，当n=3时表示选择字符字体D；
 *           当n=8时选择字符加粗模式，当n=16时选择字符倍高模式，当n=32时选择字符倍宽模式，当n=128时选择字符下划线模式。
 *           此命令字体、加粗模式、倍高模式、倍宽模式、下划线模式同时设置。若要多种效果叠加，只需将相应的值相加即可
 *           （例如若要B字体加粗，只需将n=1+8即n=9传入）。
 */
- (Boolean)esc_print_mode:(NSInteger)n;

/**
 * 11、设置绝对打印位置。
 * 将当前位置设置到距离行首（nL+nH×256）×（横向或纵向移动单位）处。当nL＜0或nL＞255时将nL设置为0，当nH＜0或nH＞255时将nH设置为0。
 *
 */
- (Boolean)esc_absolute_print_position:(NSInteger)nL nH:(NSInteger)nH;

/**
 * 12、选择位图模式打印图片。
 * @param m m表示位图模式。当m=1时位图模式为8点双密度，当m=32时位图模式为24点单密度，当m=33时位图模式为24点双密度，
 *          除m=1,32,33之外位图模式都为8点单密度。
 * @param image bitmap为要打印的位图。由于打印纸宽度有限，图片不可太大。
 */
- (Boolean)esc_bitmap_mode:(NSUInteger)m iamge:(UIImage *)image;

/**
 * 13、设置默认行高。
 * 将行间距设为约 3.75mm{30/203"}。
 */
- (Boolean)esc_default_line_height;

/**
 * 14、设置行高
 * 设置行高为[n×纵向或横向移动单位]英寸。
 *  @param n n表示行高值。当n＜0时设置行高为0，当n＞255时设置行高为255[n×纵向或横向移动单位]英寸，
 *           当0≤n≤255时设置行高为[n×纵向或横向移动单位]英寸。
 */
- (Boolean)esc_line_height:(NSInteger)n;

/**
 * 15、设置水平制表符位置。
 * @param n n的长度表示横向跳格数，n[k]表示第k个跳格位置的值。当n的长度大于32时，只取前32个值；当n[k]大于等于n[k-1]时忽略该命令。
 *          当n[k]≤0或n[k]≥255时，忽略该命令。
 */
- (Boolean)esc_horizontal_tab_position:(NSArray *)n;

/**
 * 16、打印并进纸。
 * @param n 当0≤n≤255时打印缓冲区数据并进纸【n×纵向或横向移动单位】英寸。当n＜0时进纸0，当n＞255时进纸【255×纵向或横向移动单位】英寸。
 */
- (Boolean)esc_print_formfeed:(NSInteger)n;

/**
 * 17、选择字体。
 * @param n 当n=1或n=49时选择字体B，当n=2或n=50时选择字体C，当n=3或n=51时选择字体D，当n为其他值时选择字体A。
 */
- (Boolean)esc_font:(NSInteger)n;

/**
 * 18、选择国际字符集。
 * @param n 当n≤0或n＞13时选择America字符集，当n=1时选择France字符集，当n=2时选择German字符集，当n=3时选择UK字符集，
 *          当n=4时选择Denmar字符集，当n=5时选择Sweden字符集，当n=6时选择Italy字符集，当n=7时选择Spain I字符集，当n=8时选择Japan字符集，
 *          当n=9时选择Norway字符集，当n=10时选择Denmar字符集，当n=11时选择Spain II字符集，当n=12时选择Latin字符集，当n=13时选择Korea字符集。
 */
- (Boolean)esc_national_character_set:(NSInteger)n;

/**
 * 19、选择/取消顺时针旋转90°。
 * @param n 当n=1或n=49时设置90°顺时针旋转模式，当n=2或n=50时设置180°顺时针旋转模式，当n=3或n=51时设置270°顺时针旋转模式，
 *          当n取其他值时取消旋转模式。
 */
- (Boolean)esc_rotate:(NSInteger)n;

/**
 * 20、设定相对打印位置。
 * 将打印位置从当前位置移至（nL+nH×256）×（水平或垂直运动单位）。当nL＜0时设置nL=0，当nL＞255时设置nL=255。
 * 当nH＜0时设置nH=0，当nH＞255时设置nH=255。
 */
- (Boolean)esc_relative_print_position:(NSInteger)nL nH:(NSInteger)nH;

/**
 * 21、选择对齐模式。
 * @param n 当n=1或n=49时选择居中对齐，当n=2或n=50时选择右对齐，当n取其他值时选择左对齐。
 */
- (Boolean)esc_align:(NSInteger)n;

/**
 * 22、打印并向前走纸n行。
 * @param n 当n＜0时进纸0行，当n＞255时进纸255行，当0≤n≤255时进纸n行。
 */
- (Boolean)esc_print_formfeed_row:(NSInteger)n;

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
- (Boolean)esc_character_code_page:(NSInteger)n;

/**
 * 24、选择字符大小。
 * @param n 当n=2时2倍高，当n=3时3倍高，当n=4时4倍高，当n=20时2倍宽，当n=30时3倍宽，当n=40时4倍宽，当n=22时2倍宽高，当n=33时3倍宽高，
 *          当n=44时4倍宽高，当n取其他值时1倍宽高。
 */
- (Boolean)esc_character_size:(NSInteger)n;

/**
 * 25、定义并打印下载位图。
 * @param x x表示位图的横向点数（1≤x≤255），
 * @param y y表示位图的纵向点数（1≤y≤48）。
 * @param data data的长度等于x*y*8（1≤x*y≤1536），表示位图字节数，除以上取值外其他取值均忽略此命令。
 * @param m m表示打印下载位图的模式，当m=1或m=49时设置倍宽模式，当m=2或m=50时设置倍高模式，当m=3或m=51时设置倍宽倍高模式，
 *          当m取其他值时设置普通模式打印所下载的位图。
 */
- (Boolean)esc_define_print_download_bitmap:(NSInteger)x y:(NSInteger)y data:(NSArray *)data mode:(NSInteger)m;

/**
 * 26、选择/取消黑白反显打印模式。
 * @param b 当b为true时选择黑白反显打印模式，当b为false时取消黑白反显打印模式。
 */
- (Boolean)esc_black_white_reverse:(Boolean)b;

/**
 * 27、设定左边距。
 * 当0≤nL≤255且0≤nH≤255时，将左边距设为【(nL+nH×256)×(水平移动单位)】。当nL和nH取其他值时将左边距设为0。
 */
- (Boolean)esc_left_margin:(NSInteger)nL nH:(NSInteger)nH;

/**
 * 28、设定横向和纵向移动单位。
 * 当0≤x≤255且0≤y≤255时分别将水平和垂直移动单位设为25.4/x毫米和25.4/y毫米。当x和y取其他值时取x=0和Y=0。
 */
- (Boolean)esc_move_unit:(NSInteger)x y:(NSInteger)y;

/**
 * 29、设定打印区域宽度。
 * 当0≤nL≤255且0≤nH≤255时,将打印区域宽度设为（nL+nH×256）×（水平移动单位）。当nL和nH取其他值时取nL=0和nH=0。
 */
- (Boolean)esc_print_area_width:(NSInteger)nL nH:(NSInteger)nH;

/**
 * 30、设定汉字模式。
 * @param b 当b为true时选择汉字模式，当b为false时取消汉字模式。
 */
- (Boolean)esc_chinese_mode:(Boolean)b;

/**
 * 31、设置汉字字符模式。
 * @param n 当n=4时选择倍宽，当n=8时选择倍高，当n=128时选择下划线，当n=12时选择倍高倍宽，当n=132时选择倍宽下划线，当n=136时选择倍高下划线，
 *          当n=140时选择倍宽倍高下划线，当n取其他值时不选择倍高倍宽下划线。
 *          倍高、倍宽、下划线模式同时设置。
 */
- (Boolean)esc_chinese_character_mode:(NSInteger)n;

/**
 * 32、选择/取消汉字下划线模式。
 * @param n 当n=1或n=49时选择汉字下划线（1点宽），当n=2或n=50时选择汉字下划线（2点宽），当n为其他值时不加下划线。
 */
- (Boolean)esc_chinese_character_underline_mode:(NSInteger)n;

/**
 * 33、定义自定义汉字。
 * @param c2 c2表示自定义字符编码第二个字节,取值范围为A1H≤c2≤FEH，第一个字节为FEH，
 * @param data data表示自定义汉字的数据，1表示打印一个点，0表示不打印点。
 *             data的长度为72，若data的长度不等于72或data的每个元素值出现小于0或大于255的情况，则忽略该命令。
 */
- (Boolean)esc_define_chinese_character:(NSInteger)c2 data:(NSArray *)data;

/**
 * 34、选择/取消汉字倍高倍宽。
 * @param b 当b为true时选择汉字倍高倍宽模式，当b为false时取消汉字倍高倍宽模式。
 */
- (Boolean)esc_chinese_character_twice_height_width:(Boolean)b;

/**
 * 35、打印并走纸到右黑标处。
 */
- (Boolean)esc_print_to_right_black_label;

/**
 * 36、走纸到标签处。
 */
- (Boolean)esc_print_to_label;

/**
 * 37、打印光栅位图。
 * @param m m表示光栅位图模式，当m=1或m=49时选择倍宽模式，当m=2或m=50时选择倍高模式，当m=3或m=51时选择倍宽倍高模式。
 *           data表示要打印的光栅位图的数据，data的长度等于(xL+xH*256)*(yL+yH*256)，表示要打印的光栅位图数据长度，
 *           当xL<0或xL>255或xH<0或xH>255或yL<0或yL>255或yH<0或yH>255或data的长度不等于((xL+xH*256)*(yL+yH*256))或((xL+xH*256)*(yL+yH*256))等于0时忽略该命令。
 */
- (Boolean)esc_print_grating_bitmap:(NSInteger)m xL:(NSInteger)xL xH:(NSInteger)xH yL:(NSInteger)yL yH:(NSInteger)yH data:(NSArray *)data;

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
- (Boolean)esc_barcode_1d:(NSInteger)HRI_position HRI_font:(NSInteger)HRI_font width:(NSInteger)width height:(NSInteger)height type:(NSInteger)type content:(NSString *)content;

/**
 * 39、打印二维码。
 * @param type type表示二维码类型，当type=0时选择PDF417，当type=2时选择DATAMATRIX，当type取其他值时选择QRCODE。
 * @param content content表示要打印的二维码内容。
 */
- (Boolean)esc_print_barcode_2d:(NSInteger)type content:(NSString *)content;

@end
