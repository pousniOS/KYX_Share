//
//  UIResponder+PSResponder.h
//  PSOksales
//
//  Created by POSUN-MAC on 17/3/15.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponderEvent.h"

@interface UIResponder (PSResponder)
@property(nonatomic,retain,readonly)NSMutableArray *eventBlacks;
-(void)addEventBlack:(EventBlack)eventBlack andControlEvents:(UIControlEvents)controlEvent;
-(void)eventBlackWith:(NSDictionary *)information;
@end
