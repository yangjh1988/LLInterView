//
//  LLAdvDetailViewController.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLAdvDetailViewController.h"

@interface LLAdvDetailViewController ()
<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LLAdvDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    [self setNavigationTitleWith:self.adv.title];
    [self setNavigationRightItemWithSystemItem:UIBarButtonSystemItemRefresh Action:@selector(loadWeb)];
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
    }
    [self loadWeb];
}

- (void)loadWeb
{
    NSURL *url = [NSURL URLWithString:self.adv.url];
    if (![url.scheme isEqualToString:@"http"] && ![url.scheme isEqualToString:@"https"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.adv.url]];
    }
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:urlRequest];
}

#pragma mark -- UIWebView Delegate --
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

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
