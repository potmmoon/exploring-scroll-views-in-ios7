//
//  NestedScrollViewController.m
//  NestedScrollview
//
//  Created by 韩傻傻 on 14-2-12.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import "NestedScrollViewController.h"
#import "UIColor+RandomColor.h"
#import "ScrollCollectionViewCell.h"
#import "DynamicCollectionViewLayout.h"

@interface NestedScrollViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,ScrollingCellDelegate>

@property(nonatomic, strong)DynamicCollectionViewLayout *layout;
@property(nonatomic, strong)UIScrollView *outerScrollView;
@property(nonatomic, strong)UIView *buildingView;
@end

static NSString *reuseid=@"collectionViewReuserID";
@implementation NestedScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _outerScrollView=[[UIScrollView alloc]initWithFrame:self.view.frame];
    _outerScrollView.contentSize=CGSizeMake(self.view.frame.size.width*2,self.view.frame.size.height);
    _outerScrollView.showsHorizontalScrollIndicator=NO;
    _outerScrollView.pagingEnabled=YES;
    _outerScrollView.delegate=self;
    
	// Do any additional setup after loading the view.
    self.layout=[[DynamicCollectionViewLayout alloc]init];
    self.layout.itemSize=CGSizeMake(self.view.frame.size.width, 44);
    
    UICollectionView *collectionView=[[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:self.layout];
    [collectionView registerClass:[ScrollCollectionViewCell class] forCellWithReuseIdentifier:reuseid];
    collectionView.backgroundColor=[UIColor whiteColor];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    
    [_outerScrollView addSubview:collectionView];
    
    _buildingView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width+100, 100, 200, 200)];
    _buildingView.backgroundColor=[UIColor blueColor];
    [_outerScrollView addSubview:_buildingView];
    [self.view addSubview:_outerScrollView];
    
}

#pragma mark - ScrollingCellDelegate
- (void)scrollingCellDidBeginPulling:(ScrollCollectionViewCell *)cell{
    [_outerScrollView setScrollEnabled:NO];
}
- (void)scrollingCell:(ScrollCollectionViewCell *)cell didChangePullOffset:(CGFloat)offset{
    NSLog(@"pullOffset:%f",offset);
    [_outerScrollView setContentOffset:CGPointMake(offset, 0)];
}
- (void)scrollingCellDidEndPulling:(ScrollCollectionViewCell *)cell{
    [_outerScrollView setScrollEnabled:YES];
    NSLog(@"outerScrollView Scrollagain");
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ScrollCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:reuseid forIndexPath:indexPath];
    cell.delegate=self;
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
