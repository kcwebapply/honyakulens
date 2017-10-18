//
//  honyakun-Server.h
//  honyakun
//
//  Created by WKC on 2016/09/06.
//  Copyright © 2016年 WKC. All rights reserved.
//

#ifndef honyakun_Swift_h
#define honyakun_Swift_h
#import "SVProgressHUD.h"
#import "sqlite3.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImage+animatedGIF.h"
#import "UIImage+animatedGIF.m"
@interface TestOpenCV : NSObject
+(UIImage *)DetectEdgeWithImage:(UIImage *)image;
+(UIImage *)onAdaptive:(UIImage *)image;



@end
#endif /* honyakun_Server_h */
