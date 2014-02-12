//
//  ScrollCollectionViewCell.m
//  NestedScrollview
//
//  Created by 韩傻傻 on 14-2-12.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import "ScrollCollectionViewCell.h"
#import "UIColor+RandomColor.h"

#define PULL_DISSHOULD 60

@interface ScrollCollectionViewCell () <UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *colorView;
@property(nonatomic, assign)BOOL pulling;
@property(nonatomic, assign)BOOL deceleratingBackToZero;
@property(nonatomic, assign)CGFloat deceleratingRadio;

@end
@implementation ScrollCollectionViewCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _colorView=[[UIView alloc]init];
        _colorView.backgroundColor=[UIColor randomColor];
        
        _scrollView=[[UIScrollView alloc]init];
        _scrollView.delegate=self;
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        
        [_scrollView addSubview:_colorView];
        [self.contentView addSubview:_scrollView];
    }
    return self;
}

- (void)layoutSubviews{
    UIView *contentView=self.contentView;
    CGRect bounds=contentView.bounds;
    
    CGFloat pageWidth=bounds.size.width +PULL_DISSHOULD;
    _scrollView.frame=CGRectMake(0, 0, pageWidth, bounds.size.height);
    _scrollView.contentSize=CGSizeMake(pageWidth*2, bounds.size.height);
    
    _colorView.frame=[_scrollView convertRect:bounds fromView:contentView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset=scrollView.contentOffset.x;
    
    //did we start pulling
    if(offset > PULL_DISSHOULD && !_pulling){
        [_delegate scrollingCellDidBeginPulling:self];
        _pulling=YES;
    }
    
    if(_pulling){
        CGFloat pullOffset;
        if(_deceleratingBackToZero){
            pullOffset=offset*_deceleratingBackToZero;
        }else{
            pullOffset=MAX(0,offset-PULL_DISSHOULD);
        }
        [_delegate scrollingCell:self didChangePullOffset:pullOffset];
        
        _scrollView.transform=CGAffineTransformMakeTranslation(pullOffset, 0);
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self scrollingEnded];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollingEnded];
}

-(void)scrollingEnded{
    [_delegate scrollingCellDidEndPulling:self];
    _pulling=NO;
    _deceleratingBackToZero=NO;
    
    _scrollView.contentOffset=CGPointZero;
    _scrollView.transform=CGAffineTransformIdentity;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat offset=_scrollView.contentOffset.x;
    
    if((*targetContentOffset).x==0 &&offset>0){
        _deceleratingBackToZero=YES;
        CGFloat pullOffset=MAX(0, offset-PULL_DISSHOULD);
        _deceleratingRadio=pullOffset/offset;
    }
}



/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
