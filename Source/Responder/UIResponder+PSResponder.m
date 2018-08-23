//
//  UIResponder+PSResponder.m
//  PSOksales
//
//  Created by POSUN-MAC on 17/3/15.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#import "UIResponder+PSResponder.h"
#import <objc/runtime.h>
static const char EventBlacksKey='\0';

@implementation UIResponder (PSResponder)

//-(instancetype)init{
//    if (self=[super init]) {
//        if ([self isKindOfClass:[UITableView class]]) {
//            UITableView *tableView=(UITableView *)self;
//            tableView.estimatedSectionFooterHeight=0;
//            tableView.estimatedSectionHeaderHeight=0;
//            tableView.estimatedRowHeight=0;
//
//        }
//    }
//    return self;
//}


-(NSMutableArray *)eventBlacks
{
    if (!objc_getAssociatedObject(self, &EventBlacksKey))
    {
        NSMutableArray *mutablArray=[[NSMutableArray alloc] init];
        objc_setAssociatedObject(self, &EventBlacksKey, mutablArray, OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &EventBlacksKey);
}
-(void)addEventBlack:(EventBlack)eventBlack andControlEvents:(UIControlEvents)controlEvent
{
    ResponderEvent *eventModel=[[ResponderEvent alloc] init];
    eventModel.eventBlack=eventBlack;
    eventModel.controlEvents=controlEvent;
    [self.eventBlacks addObject:eventModel];
}

-(void)eventBlackWith:(NSDictionary *)information
{
    for (ResponderEvent *model in self.eventBlacks)
    {
        if ([self isKindOfClass:[UIControl class]])
        {
            UIControl *control=(UIControl*)self;
            if (control.allControlEvents==model.controlEvents)
            {
                model.eventBlack(self,information);
            }
        }
    }
}

@end
