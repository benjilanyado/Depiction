//
//  UIFont+Theme.m
//  Whatsnap
//
//  Created by Alexander G Edge on 22/01/2014.
//  Copyright (c) 2014 Steer. All rights reserved.
//

#import "UIFont+Theme.h"

@implementation UIFont (Theme)

+ (UIFont *)themeFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"Baskerville" size:size];
}

+ (UIFont *)italicThemeFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"Baskerville-Italic" size:size];
}

+ (UIFont *)navigationBarFont{
    return [UIFont italicThemeFontOfSize:24.f];
}

@end
