//
//  WebViewController.m
//  GitHubYi
//
//  Created by coderyi on 15/4/4.
//  Copyright (c) 2015年 www.coderyi.com. All rights reserved.
//

#import "LSWebViewController.h"

@interface LSWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UILabel   *titleText;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIButton  *backBt;
@property (strong, nonatomic) UIButton  *closeBt;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSString  *urlString;
@end

@implementation LSWebViewController

#pragma mark - Lifecycle

- (id)initWithUrl:(NSString *)urlString
{
    if( self = [self init] )
    {
        self.urlString = urlString;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if( self )
    {
        _urlString = @"http://caipiao.163.com/t/";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.activityIndicator removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;

    self.titleText = [[UILabel alloc] initWithFrame: CGRectMake((kScreenWidth-120)/2, 0, 120, 44)];
    self.titleText.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleText.backgroundColor = [UIColor clearColor];
    self.titleText.textColor=[UIColor whiteColor];
    [self.titleText setFont:[UIFont systemFontOfSize:17.0]];
    self.titleText.textAlignment=NSTextAlignmentCenter;
    self.titleText.text=_urlString;
    self.navigationItem.titleView = self.titleText;
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:self.webView];
    self.webView.delegate=self;
    [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_urlString]] ];
    
    self.activityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 0, 44, 44)];
    [self.navigationController.navigationBar addSubview:self.activityIndicator];
    self.activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    
    self.backBt=[UIButton buttonWithType:UIButtonTypeCustom];
    self.backBt.frame=CGRectMake(0, 0, 30, 30);
    [self.backBt setImage:[UIImage imageNamed:@"ic_arrow_back_white_48pt"] forState:UIControlStateNormal];
    [self.backBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backBt addTarget:self action:@selector(backBtAction) forControlEvents:UIControlEventTouchUpInside];
    self.closeBt=[UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBt.frame=CGRectMake(0, 0, 30, 30);
    self.closeBt.titleLabel.font=[UIFont systemFontOfSize:12];
    [self.closeBt setImage:[UIImage imageNamed:@"ic_cancel_white_48pt"] forState:UIControlStateNormal];
    [self.closeBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeBt addTarget:self action:@selector(closeBtAction) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc] initWithCustomView:self.backBt]];
}

- (void)backBtAction
{
    if(self.webView.canGoBack)
    {
        [self.webView goBack];
        
        self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc] initWithCustomView:self.backBt],[[UIBarButtonItem alloc] initWithCustomView:self.closeBt]];
    }
    else
    {
        [self closeBtAction];
    }
}

- (void)closeBtAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.titleText.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


@end
