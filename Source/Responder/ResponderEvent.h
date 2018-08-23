//
//  ResponderEvent.h
//  PSOksales
//
//  Created by POSUN-MAC on 17/3/15.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^EventBlack)(UIResponder *responder ,id information);



@interface ResponderEvent : UIView
@property(nonatomic,copy)EventBlack eventBlack;
@property(nonatomic,assign)UIControlEvents controlEvents;
@end
