//
//  HealthViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HealthViewController.h"
#import "HealthyViewController.h"
#import "H_TitleModel.h"

@interface HealthViewController ()<MJCSegmentDelegate>
@property (nonatomic,strong) NSMutableArray *titlesArr;
@end

@implementation HealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavTitleH(@"健康知识");
    
    [self loadTitleData];
}
-(void)loadTitleData{
    [self.titlesArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Health_name"]];
    if(self.titlesArr.count>0){
        [self createTitleView];
    }
    [[HYDataService sharedClient] requestWithUrlString:Health_List_Url parameters:nil method:REQUEST_METHOD_POST success:^(id response, NSError *error) {
        NSMutableArray *tempTitleArr = [NSMutableArray array];//name
        NSMutableDictionary *titleDic = [NSMutableDictionary dictionary];
        H_TitleModel *titleModel = [H_TitleModel mj_objectWithKeyValues:response];
        for (H_List *list in titleModel.list) {
            [tempTitleArr addObject:list.name];
            [titleDic setObject:list.titleID forKey:list.name];
        }
        [[NSUserDefaults standardUserDefaults] setObject:tempTitleArr forKey:@"Health_name"];
        [[NSUserDefaults standardUserDefaults] setObject:titleDic forKey:@"Health_Title"];
        if(self.titlesArr.count == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.titlesArr addObjectsFromArray:tempTitleArr];
                [self createTitleView];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}

-(void)createTitleView{
    NSMutableArray *vcArray = [NSMutableArray array];
    NSDictionary *titleDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Health_Title"];
    for(int i = 0;i<self.titlesArr.count;i++){
        HealthyViewController *vc1 = [[HealthyViewController alloc]init];
        vc1.titleStr = [titleDic objectForKey:self.titlesArr[i]];
        [vcArray addObject:vc1];
    }
    // 分段样式属性工具
    MJCSegmentStylesTools *tools = [MJCSegmentStylesTools jc_initWithSegmentStylestoolsBlock:^(MJCSegmentStylesTools *jc_tools) {
        jc_tools.jc_titleBarStyles(MJCTitlesScrollStyle).
        jc_titlesViewFrame(CGRectMake(0, 0, self.view.jc_width,30));
        jc_tools.ItemDefaultShowCount = 6;
        jc_tools.childScollEnabled = YES;
        jc_tools.indicatorFollowEnabled = YES;
    }];
    MJCSegmentInterface *interFace = [MJCSegmentInterface initWithFrame:CGRectMake(0,64,self.view.jc_width, self.view.jc_height-64) interFaceStyletools:tools];
    interFace.delegate = self;
    [self.view addSubview:interFace];
    [interFace intoTitlesArray:self.titlesArr intoChildControllerArray:vcArray hostController:self];
}
-(NSMutableArray *)titlesArr{
    if(!_titlesArr){
        _titlesArr = [NSMutableArray array];
    }
    return _titlesArr;
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
