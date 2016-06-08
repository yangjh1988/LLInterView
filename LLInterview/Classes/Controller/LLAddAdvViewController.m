//
//  LLAddAdvViewController.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLAddAdvViewController.h"

#import "LLAddAdvCell.h"

@interface LLAddAdvViewController ()
<UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextField *urlTextField;
@property (nonatomic, strong) UIButton    *submitButton;

@end

@implementation LLAddAdvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)initData
{
    
}

- (void)setupViews
{
    [self setNavigationTitleWith:@"编辑"];
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    if (!self.titleTextField) {
        self.titleTextField = [[UITextField alloc] init];
        self.titleTextField.delegate = self;
    }
    if (!self.urlTextField) {
        self.urlTextField = [[UITextField alloc] init];
        self.urlTextField.delegate = self;
    }
    if (!self.submitButton) {
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submitButton.frame = CGRectMake(15.0, 20.0, kScreenWidth-30.0, 44.0);
        self.submitButton.layer.cornerRadius = 2.0;
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submitButton setBackgroundColor:[UIColor greenColor]];
        [self.submitButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64.0)];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:self.submitButton];
        self.tableView.tableFooterView = footerView;
    }
}

- (void)reset
{
    self.urlTextField.text = nil;
    self.titleTextField.text = nil;
}

#pragma mark -- Action --
- (void)submitAction:(UIButton *)sender
{
    if (self.urlTextField.text==nil||[self.urlTextField.text isEqualToString:@""]) {
        [[LLActionSheetView shareInstance] showAlertViewWith:@"" message:@"请输入URL"];
        return;
    }
    else if (self.titleTextField.text==nil||[self.titleTextField.text isEqualToString:@""]) {
        [[LLActionSheetView shareInstance] showAlertViewWith:@"" message:@"请输入Ttitle"];
        return;
    }
    
    [self doSubmitAdvRequest];
}

#pragma mark -- Network --
- (void)doSubmitAdvRequest
{
    __weak LLAddAdvViewController *wSelf = self;
    [self showProcessHUD];
    LLAddAdvRequest *request = [[LLAddAdvRequest alloc] init];
    request.title = self.titleTextField.text;
    request.url = self.urlTextField.text;
    
    [[LLNetworkManager createNetworkManager]
     addAdvWith:request
     completeBlock:^(LLNetworkBaseResult *responseObj) {
         LLAddAdvViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         LLAddAdvResult *result = (LLAddAdvResult *)responseObj;
         if (sSelf.completeBlock) {
             sSelf.completeBlock(result.adv);
         }
         [sSelf reset];
         [sSelf showToast:@"保存成功"];
    }
     failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
         LLAddAdvViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [[LLActionSheetView shareInstance] showAlertViewWith:@"" message:@"请求失败"];
    }];
}

#pragma mark -- UITableView Datasource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0==indexPath.row) {
        LLAddAdvCell *cell = [[LLAddAdvCell alloc] initWithTitle:@"Title :" textField:self.titleTextField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        LLAddAdvCell *cell = [[LLAddAdvCell alloc] initWithTitle:@"URL :" textField:self.urlTextField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark -- UITableView Delegate --

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
