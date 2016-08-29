//
//  ViewController.m
//  瀑布流
//
//  Created by HYS on 15/12/5.
//  Copyright © 2015年 HYS. All rights reserved.
//

#import "ViewController.h"
#import "HYSWaterflowLayout.h"
#import "HYSShopCell.h"
#import "MJExtension.h"
#import "HYSShop.h"
#import "MJRefresh/MJRefresh.h"
@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, HYSWaterflowLayoutDelegate>
@property (weak, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *shopsArray;
@end

@implementation ViewController
static NSString *ID = @"shop";

- (NSMutableArray *)shopsArray{
    if (!_shopsArray) {
        _shopsArray = [NSMutableArray new];
    }
    return _shopsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HYSWaterflowLayout *wflayout = [[HYSWaterflowLayout alloc]init];
    wflayout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:wflayout];
    [collectionView registerNib:[UINib nibWithNibName:@"HYSShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"plist"];
//    NSArray *array = [NSArray arrayWithContentsOfFile:path];
//    NSLog(@"%@", array);
    
    
    NSArray *shopArray = [HYSShop objectArrayWithFilename:@"1.plist"];
    [self.shopsArray addObjectsFromArray:shopArray];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView addFooterWithTarget:self action:@selector(addData)];
    
}

- (void)addData{
    NSArray *shopArray = [HYSShop objectArrayWithFilename:@"1.plist"];
    [self.shopsArray addObjectsFromArray:shopArray];
    [self.collectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shopsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HYSShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.shop = self.shopsArray[indexPath.row];
    return cell;
}
#pragma mark 
- (CGFloat)waterflowLayout:(HYSWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath{
    HYSShop *shop = self.shopsArray[indexPath.item];
    return shop.h / shop.w * width;
}
@end
