//
//  HYSWaterflowLayout.m
//  瀑布流
//
//  Created by HYS on 15/12/6.
//  Copyright © 2015年 HYS. All rights reserved.
//

#import "HYSWaterflowLayout.h"

@interface HYSWaterflowLayout ()
/**存放每列的最大y值(每一列的最大高度)*/
@property (nonatomic, strong) NSMutableDictionary *maxYDict;
/**存放所有的attrs*/
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end

@implementation HYSWaterflowLayout

- (NSMutableDictionary *)maxYDict{
    if (!_maxYDict) {
        _maxYDict = [NSMutableDictionary new];
    }
    return _maxYDict;
}
- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray new];
    }
    return _attrsArray;
}
- (instancetype)init{
    if (self = [super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //默认3列
        self.columnsCount = 3;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
//可在此初始化: 开始布局之前会调用该方法
- (void)prepareLayout{
    //每次布局都要重新算 清空
    for (int i = 0; i < self.columnsCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d", i];
        self.maxYDict[column] = @(self.sectionInset.top);
    }
    //计算所有attr
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attr];
    }

}
//返回所有尺寸(内)
- (CGSize)collectionViewContentSize{
    //假设最大的那一列是第0列
    __block NSString *maxColumn = @"0";
    //找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull column, NSNumber*  _Nonnull maxY, BOOL * _Nonnull stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    return  CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.sectionInset.bottom);
}

//会掉多次 可放倒preareLayout里面
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    //每次布局都要重新算
//    for (int i = 0; i < self.columnsCount; i++) {
//        NSString *column = [NSString stringWithFormat:@"%d", i];
//        self.maxYDict[column] = @(0);
//    }
//
//    NSMutableArray *array = [NSMutableArray new];
//    NSInteger count = [self.collectionView numberOfItemsInSection:0];
//    for (int i = 0; i < count; i++) {
//        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//        [array addObject:attr];
//    }
    return self.attrsArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //假设最短的那一列是第0列
    __block NSString *minColumn = @"0";
    //找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull column, NSNumber*  _Nonnull maxY, BOOL * _Nonnull stop) {
        if ([maxY floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    //计算宽度和高度
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnsCount - 1) * self.columnMargin) / self.columnsCount;
    CGFloat height = [self.delegate waterflowLayout:self heightForWidth:width atIndexPath:indexPath];
    //计算位子x:
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColumn intValue];
    CGFloat y = [self.maxYDict[minColumn] floatValue] + self.rowMargin;
    //更新这一列的最大y
    self.maxYDict[minColumn] = @(y + height);
    //创建属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(x, y, width, height);
    return attr;
}

@end
