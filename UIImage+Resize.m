//
//  UIImage+Resize.m
//  Whatsnap
//
//  Created by Alexander G Edge on 16/01/2014.
//  Copyright (c) 2014 Steer. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)
- (UIImage *)resizedImage:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImage;
}
@end
