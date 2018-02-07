//
//  HYWKViewController.h
//  HYCustomDemo
//
//  Created by HY on 2017/8/2.
//  Copyright © 2017年 apple. All rights reserved.
//


typedef NS_ENUM(NSUInteger, METHOD_STYLE) {
    METHOD_STYLE_WKWebView,
    METHOD_STYLE_UIWebView
};

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface HYWKViewController : UIViewController <WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>

@property (nonatomic,strong) WKWebView *myWKWebView;
@property (nonatomic,strong) UIWebView *myUIWebView;

@property (nonatomic,strong) UIProgressView *progressView;

-(void)loadRequestWithUrlString:(NSString *)urlString methodStyle:(METHOD_STYLE)methodStyle;

@end
