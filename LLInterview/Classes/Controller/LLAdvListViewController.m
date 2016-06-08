//
//  ViewController.m
//  LLInterview
//
//  Created by Jiahong on 16/6/8.
//  Copyright © 2016年 jiahong. All rights reserved.
//

#import "LLAdvListViewController.h"
#import "LLAdvDetailViewController.h"
#import "LLAddAdvViewController.h"

#import "LLAdvListCell.h"

@interface LLAdvListViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LLAdvListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupViews];
    [self doGetAdvListRequest];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initData
{
    self.dataArray = [[[LLDBManager shareInstance] getAdvData] mutableCopy];
}

- (void)setupViews
{
    [self setNavigationTitleWith:@"Master"];
    [self setNavigationRightItemWithSystemItem:UIBarButtonSystemItemAdd Action:@selector(addAction)];
    [self setNavigationLeftItemWithSystemItem:UIBarButtonSystemItemRefresh Action:@selector(refreshAction)];
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:self.tableView];
    }
}

#pragma mark -- Action --
- (void)refreshAction
{
    [self doGetAdvListRequest];
}

- (void)addAction
{
    __weak LLAdvListViewController *wSelf = self;
    LLAddAdvViewController *addCtrl = [[LLAddAdvViewController alloc] init];
    addCtrl.hidesBottomBarWhenPushed = YES;
    [addCtrl setCompleteBlock:^(LLAdvObject *adv) {
        LLAdvListViewController *sSelf = wSelf;
        [sSelf.dataArray insertObject:adv atIndex:0];
        [[LLDBManager shareInstance] insetAdvData:adv];
        [sSelf.tableView reloadData];
    }];
    [self.navigationController pushViewController:addCtrl animated:YES];
}

#pragma mark -- Network --
- (void)doGetAdvListRequest
{
    __weak LLAdvListViewController *wSelf = self;
    [self showProcessHUD];
    
    [[LLNetworkManager createNetworkManager]
     getAdvListWith:nil
     completeBlock:^(LLNetworkBaseResult *responseObj) {
         LLAdvListViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         LLGetAdvListResult *result = (LLGetAdvListResult *)responseObj;
         sSelf.dataArray = [NSMutableArray arrayWithArray:result.adv_list];
         if (sSelf.dataArray.count>0) {
             [[LLDBManager shareInstance] insertAdvData:sSelf.dataArray];
         }
         [sSelf.tableView reloadData];
    }
     failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
         LLAdvListViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [[LLActionSheetView shareInstance] showAlertViewWith:@"" message:@"请求失败"];
    }];
}

- (void)doDeleteAdvRequestWithIndex:(NSIndexPath *)indexPath
{
    __weak LLAdvListViewController *wSelf = self;
    [self showProcessHUD];
    if (indexPath.row>=self.dataArray.count) {
        return;
    }
    LLAdvObject *adv = [self.dataArray objectAtIndex:indexPath.row];
    LLDeleteAdvRequest *request = [[LLDeleteAdvRequest alloc] init];
    request._id = adv._id;
    
    [[LLNetworkManager createNetworkManager]
     deleteAdvWith:request
     completeBlock:^(LLNetworkBaseResult *responseObj) {
         LLAdvListViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         __unused LLDeleteAdvResult *result = (LLDeleteAdvResult *)responseObj;
         [[LLDBManager shareInstance] deleteAdvWithId:adv._id];
         [sSelf.dataArray removeObjectAtIndex:indexPath.row];
         [sSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
     failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
         LLAdvListViewController *sSelf = wSelf;
         [sSelf hideProcessHUD];
         [[LLActionSheetView shareInstance] showAlertViewWith:@"" message:@"请求失败"];
    }];
}

#pragma mark -- UITableView Datasource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LLAdvListCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"advListCell";
    LLAdvListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LLAdvListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    LLAdvObject *adv = [self.dataArray objectAtIndex:indexPath.row];
    [cell setupCellWithItem:adv index:indexPath.row actionBlock:NULL];
    return cell;
}

#pragma mark -- UITableView Delegate --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LLAdvObject *adv = [self.dataArray objectAtIndex:indexPath.row];
    LLAdvDetailViewController *detailCtrl = [[LLAdvDetailViewController alloc] init];
    detailCtrl.hidesBottomBarWhenPushed = YES;
    detailCtrl.adv = adv;
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak LLAdvListViewController *wSelf = self;
        [[LLActionSheetView shareInstance] showAlertViewWith:@""
                                                     message:@"确定要删除吗"
                                                         tag:1234
                                                 buttonBlock:^(NSInteger buttonIndex, UIAlertView *alert) {
                                                     if ([alert firstOtherButtonIndex]==buttonIndex) {
                                                         LLAdvListViewController *sSelf = wSelf;
                                                         [sSelf doDeleteAdvRequestWithIndex:indexPath];
//                                                         [sSelf.dataArray removeObjectAtIndex:indexPath.row];
//                                                         [tableView deleteRowsAtIndexPaths:@[indexPath]
//                                                                          withRowAnimation:UITableViewRowAnimationFade];
                                                     }
                                                 }
                                           cancelButtonTitle:@"取消"
                                            otherButtonTitle:@[@"删除"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
