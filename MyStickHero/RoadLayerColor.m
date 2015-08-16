//
//  RoadLayerColor.m
//  MyStickHero
//
//  Created by 大脚a on 14-12-8.
//  Copyright 2014年 DJ_ZYH. All rights reserved.
//

#import "RoadLayerColor.h"


@implementation RoadLayerColor
- (instancetype)initWithMaxWidth:(int)maxWidth
{
    self = [super initWithColor:ccc4(0, 0, 0, 255)];
    if (self) {
        self.contentSize=CGSizeMake(arc4random()%(maxWidth-20)+15, 150);
    }
    return self;
}
@end
