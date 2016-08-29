//
//  HYSShopCell.m
//  瀑布流
//
//  Created by HYS on 15/12/6.
//  Copyright © 2015年 HYS. All rights reserved.
//

#import "HYSShopCell.h"
#import "HYSShop.h"
#import "UIImageView+WebCache.h"
@interface HYSShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end


@implementation HYSShopCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setShop:(HYSShop *)shop{
    _shop = shop;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"123"]];
    _priceLabel.text = shop.price;
}
@end
