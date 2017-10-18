//
//  open.m
//  newCamera
//
//  Created by WKC on 2015/12/29.
//  Copyright © 2015年 WKC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "o2-Bridging-Header.h"

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation TestOpenCV : NSObject

+(UIImage *)DetectEdgeWithImage:(UIImage *)image{
    
    //UIImageをcv::Matに変換
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    //白黒濃淡画像に変換
    cv::Mat gray;
    cv::cvtColor(mat, gray, CV_BGR2GRAY);
    
    //エッジ検出
    cv::Mat edge;
    cv::Canny(gray, edge, 200, 180);
    
    //cv::MatをUIImageに変換
    UIImage *edgeImg = MatToUIImage(edge);
    
    return edgeImg;
    
}


+(UIImage *)onAdaptive:(UIImage *)image{
    
    //UIImageをcv::Matに変換
    /* cv::Mat mat;
     UIImageToMat(image, mat);
     
     //白黒濃淡画像に変換
     cv::Mat gray;
     cv::cvtColor(mat, gray, CV_BGR2GRAY);
     
     //エッジ検出
     cv::Mat edge;
     cv::Canny(gray, edge, 200, 180);
     
     //cv::MatをUIImageに変換
     UIImage *edgeImg = MatToUIImage(edge);*/
    cv::Mat     mat;
    //UIImageToMat(image,mat);
    
    // グレイスケール化してから適応的二値化
    //cv::Mat     mat = [self matWithImage:image];
    
    UIImage* correctImage = image;
   // UIGraphicsBeginImageContextWithOptions(correctImage.size,NO,0.0);
    UIGraphicsBeginImageContext(correctImage.size);
    [correctImage drawInRect:CGRectMake(0, 0, correctImage.size.width, correctImage.size.height)];
    correctImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    UIImageToMat(correctImage,mat);
    cv::cvtColor(mat, mat, CV_BGR2GRAY);
    cv::adaptiveThreshold(mat, mat, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, 7, 8);
    UIImage *edgeimg = MatToUIImage(mat);
    return edgeimg;
}

@end

