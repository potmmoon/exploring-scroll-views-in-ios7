//
//  ScrollCollectionViewCell.h
//  NestedScrollview
//
//  Created by 韩傻傻 on 14-2-12.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollingCellDelegate;
@interface ScrollCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UIColor *color;
@property(nonatomic, weak) id<ScrollingCellDelegate> delegate;
@end


@protocol ScrollingCellDelegate <NSObject>
- (void)scrollingCellDidBeginPulling:(ScrollCollectionViewCell *)cell;
- (void)scrollingCell:(ScrollCollectionViewCell *)cell didChangePullOffset:(CGFloat)offset;
- (void)scrollingCellDidEndPulling:(ScrollCollectionViewCell *)cell;
@end
