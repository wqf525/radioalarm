//
//  UIImage+Common.h
//  Ciwei
//
//  Created by 吴启飞 on 15/6/3.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

+(UIImage *)covertViewToImage:(UIView *)view;
+(UIImage*)scaleImageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
