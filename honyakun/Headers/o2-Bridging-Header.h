//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestOpenCV : NSObject
+(UIImage *)DetectEdgeWithImage:(UIImage *)image;
+(UIImage *)onAdaptive:(UIImage *)image;



@end
