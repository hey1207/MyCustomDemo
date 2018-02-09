//
//  HYPictureViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HYPictureViewController.h"
#import "MyPictureCell.h"
#import "RCDraggableButton.h"

@interface HYPictureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *picCollectionView;
@property (nonatomic,strong) NSMutableArray *bigPicArray;
@end

@implementation HYPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.picCollectionView];
    self.picCollectionView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    [self loadAvatarButton];
}
//添加悬浮返回按钮
-(void)loadAvatarButton{
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInView:self.view WithFrame:CGRectMake(10, 25, 30, 30)];
    avatar.backgroundColor = [UIColor whiteColor];
    [avatar setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [avatar setAutoDocking:NO];
    avatar.tapBlock = ^(RCDraggableButton *avatar) {
        [self.navigationController popViewControllerAnimated:YES];
    };
    avatar.dragDoneBlock = ^(RCDraggableButton *avatar) {
        NSLog(@"\n\tAvatar in customView === DragDone!!! ===");
    };
}
-(void)setPicArray:(NSArray *)picArray{
    _picArray = picArray;
    for (S_PicList *picList in picArray) {
        [self.bigPicArray addObject:picList.picUrl];
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.picList = self.picArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < self.picArray.count; i++) {
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:nil imageUrl:[NSURL URLWithString:self.bigPicArray[i]]];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    [browser showFromViewController:self];
}

-(UICollectionView *)picCollectionView{
    if (!_picCollectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        //行间距
        layOut.minimumLineSpacing = 5;
        //列间距（不设的话默认最低为10）
        layOut.minimumInteritemSpacing = 5;
        //单个Item的size (宽高)
        CGFloat width = (Main_Screen_Width-2*10-5)/2;
        layOut.itemSize = CGSizeMake(width, width);
        //设置内容边界的距离
        layOut.sectionInset = UIEdgeInsetsMake(0, 10, 20, 10); //{top, left, bottom, right}
        
        _picCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layOut];
        _picCollectionView.delegate = self;
        _picCollectionView.dataSource = self;
        _picCollectionView.backgroundColor = [UIColor clearColor];
        
        [_picCollectionView registerClass:[MyPictureCell class] forCellWithReuseIdentifier:@"picCell"];
    }
    return _picCollectionView;
}

-(NSMutableArray *)bigPicArray{
    if (!_bigPicArray) {
        _bigPicArray = [NSMutableArray array];
    }
    return _bigPicArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
