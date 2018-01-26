//
//  HYWKViewController.m
//  HYCustomDemo
//
//  Created by HY on 2017/8/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HYWKViewController.h"

@interface HYWKViewController ()

@end

@implementation HYWKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addPanGesture];
}
-(void)loadRequestWithUrlString:(NSString *)urlString methodStyle:(METHOD_STYLE)methodStyle{
    if (methodStyle == METHOD_STYLE_WKWebView) {
        [self.myWKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }else if (methodStyle == METHOD_STYLE_UIWebView){
        [self.myUIWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
}
//添加系统滑动返回
-(void)addPanGesture{
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.myWKWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
#pragma mark --------懒加载-------
-(WKWebView *)myWKWebView{
    if (!_myWKWebView) {
        _myWKWebView = [[WKWebView alloc] init];
        _myWKWebView.UIDelegate = self;
        _myWKWebView.navigationDelegate = self;
        [self.view addSubview:_myWKWebView];
        _myWKWebView.userInteractionEnabled = YES;
        
        _myWKWebView.sd_layout
        .leftSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 20)
        .rightSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);

        [_myWKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _myWKWebView;
}
-(UIWebView *)myUIWebView{
    if (!_myUIWebView) {
        _myUIWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _myUIWebView.backgroundColor = [UIColor whiteColor];
        _myUIWebView.delegate = self;
        // UIWebView 滚动的比较慢，这里设置为正常速度
        _myUIWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        [self.view addSubview:_myUIWebView];
        
        _myUIWebView.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);
    }
    return _myUIWebView;
}
- (UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,21,Main_Screen_Width, 0)];
        _progressView.tintColor = [UIColor orangeColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark ----------WKNavigationDelegate----------
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
//-----WKWebView拦截URL-----
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *urlStr = [navigationAction.request.URL host];
    if ([urlStr isEqualToString:@"login_wechat"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self.myWKWebView reload];
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark ----------UINavigationDelegate----------
// ------UIWebView拦截URL------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = [request.URL host];
    if ([urlStr isEqualToString:@"login_wechat"]) {
        return NO;
    }
    return YES;
}
#pragma mark ================ WKUIDelegate ================
// js-警告框
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}
// js-提示框
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}
// js-输入框
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)dealloc {
//    [self.myWKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
