//
//  SceneryDetailVC.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SceneryDetailVC.h"
#import "SecneryDetailCell.h"
#import "HYPictureViewController.h"

@interface SceneryDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@end

@implementation SceneryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NavTitleH(self.contentlist.name);
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SecneryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakSelf = self;
    cell.clickPicBlock = ^{
        HYPictureViewController *hyPictureVC = [[HYPictureViewController alloc] init];
        hyPictureVC.picArray = weakSelf.contentlist.picList;
        [weakSelf.navigationController pushViewController:hyPictureVC animated:YES];
    };
    cell.contentlist = self.contentlist;
    return cell;
}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerNib:[UINib nibWithNibName:@"SecneryDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellID"];
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.estimatedRowHeight = 200;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.separatorColor = [UIColor clearColor];
    }
    return _mainTableView;
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
