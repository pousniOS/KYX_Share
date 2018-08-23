//
//  UIButton+Add.m
//  PSOksales
//
//  Created by POSUN-MAC on 17/3/14.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#import "UIButton+Add.h"

@interface UIButton()
@end

@implementation UIButton (Add)
-(void)addCE:(UIControlEvents)cE andBEB:(EventBlack)bEB
{
    [self addEventBlack:bEB andControlEvents:cE];
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:cE];
}

-(void)setBIN:(UIImage*)bIN andBIH:(UIImage *)bIH andCE:(UIControlEvents)cE andBEB:(EventBlack)bEB
{
    [self addCE:cE andBEB:bEB];
    [self setImage:bIN forState:UIControlStateNormal];
    [self setImage:bIH forState:UIControlStateHighlighted];

}
-(void)setBIN:(UIImage*)bIN andBIS:(UIImage *)bIS andCE:(UIControlEvents)cE andBEB:(EventBlack)bEB
{
    [self addCE:cE andBEB:bEB];
    [self setImage:bIN forState:UIControlStateNormal];
    [self setImage:bIS forState:UIControlStateSelected];
}
-(void)setBTN:(NSString*)bTN andBCN:(UIColor *)bCN andBTH:(NSString *)bTH andBCH:(UIColor *)bCH andCE:(UIControlEvents)cE andBEB:(EventBlack)bEB
{
    [self addCE:cE andBEB:bEB];
    [self setTitle:bTN forState:UIControlStateNormal];
    [self setTitle:bTH forState:UIControlStateHighlighted];
    [self setTitleColor:bCN forState:UIControlStateNormal];
    [self setTitleColor:bCH forState:UIControlStateHighlighted];
}
-(void)setBTN:(NSString*)bTN andBCN:(UIColor *)bCN andBTS:(NSString *)bTS andBCS:(UIColor *)bCS andCE:(UIControlEvents)cE andBEB:(EventBlack )bEB
{
    [self addCE:cE andBEB:bEB];
    [self setTitle:bTN forState:UIControlStateNormal];
    [self setTitle:bTS forState:UIControlStateSelected];
    [self setTitleColor:bCN forState:UIControlStateNormal];
    [self setTitleColor:bCS forState:UIControlStateSelected];
}
#pragma mark - ========== 给类触发事 ===========
-(void)buttonAction:(UIButton *)sender
{
    [self eventBlackWith:nil];
}
@end
