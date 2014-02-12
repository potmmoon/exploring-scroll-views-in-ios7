//
//  DynamicCollectionViewLayout.m
//  NestedScrollview
//
//  Created by 韩傻傻 on 14-2-12.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import "DynamicCollectionViewLayout.h"

@interface DynamicCollectionViewLayout()

@property(nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation DynamicCollectionViewLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    if(!_animator){
        _animator=[[UIDynamicAnimator alloc]initWithCollectionViewLayout:self];
        CGSize contentSize=[self collectionViewContentSize];
        NSArray *items=[super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        for(UICollectionViewLayoutAttributes *item in items){
            
            UIAttachmentBehavior *spring=[[UIAttachmentBehavior alloc]initWithItem:item attachedToAnchor:item.center];
            
            spring.length=0;
            spring.damping=0.5;
            spring.frequency=0.8;
            
            [_animator addBehavior:spring];
        }
    }
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return [_animator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_animator layoutAttributesForCellAtIndexPath:indexPath];
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    UIScrollView *scrollView=self.collectionView;
    CGFloat scrollDelta=newBounds.origin.y-scrollView.bounds.origin.y;
    
    //get the touch point
    CGPoint touchLocation=[scrollView.panGestureRecognizer locationInView:scrollView];
    for (UIAttachmentBehavior *spring in _animator.behaviors) {
        CGPoint anchorPoint=spring.anchorPoint;
        
        CGFloat distanchFromTouch=fabsf(touchLocation.y-anchorPoint.y);
        CGFloat scrollResistance=distanchFromTouch/500;
        
        UICollectionViewLayoutAttributes *item=[spring.items firstObject];
        CGPoint center=item.center;
        //center.y+=scrollDelta;
        center.y+=(scrollDelta>0)?MIN(scrollDelta, scrollDelta*scrollResistance):MAX(scrollDelta, scrollDelta*scrollResistance);
        item.center=center;

        [_animator updateItemUsingCurrentState:item];
    }
    
    return NO;
}
@end
