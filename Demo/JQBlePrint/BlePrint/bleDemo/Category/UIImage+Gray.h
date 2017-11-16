//
//  GrayScale.h
//  XOGameFrame
//
//  Created by song on 11-1-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (grayscale)

- (UIImage *)convertToGrayscale;
- (UIImage *)toImageWithSize:(CGSize)reSize;

@end
