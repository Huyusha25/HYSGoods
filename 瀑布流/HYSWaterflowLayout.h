//
//  HYSWaterflowLayout.h
//  瀑布流
//
//  Created by HYS on 15/12/6.
//  Copyright © 2015年 HYS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYSWaterflowLayout;
@protocol HYSWaterflowLayoutDelegate <NSObject>

- (CGFloat)waterflowLayout:(HYSWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface HYSWaterflowLayout : UICollectionViewLayout
/**每列之间的间距*/
@property (nonatomic, assign) CGFloat columnMargin;
/**每行之间的距离*/
@property (nonatomic, assign) CGFloat rowMargin;
/**多少列*/
@property (nonatomic, assign) CGFloat columnsCount;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (weak, nonatomic) id<HYSWaterflowLayoutDelegate> delegate;

@end
