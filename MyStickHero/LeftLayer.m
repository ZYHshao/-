//
//  LeftLayer.m
//  MyStickHero
//
//  Created by 大脚a on 14-12-9.
//  Copyright 2014年 DJ_ZYH. All rights reserved.
//

#import "LeftLayer.h"
#import "SimpleAudioEngine.h"
static BOOL music;
@implementation LeftLayer
{
    CCMenuItemFont * sound;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        music=YES;
        self.contentSize=CGSizeMake(150, SCREEN_SIZE.height);
        CCSprite * bg = [CCSprite spriteWithFile:@"leftBar.jpg"];
        bg.opacity=0;
        bg.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:bg];
        CCLabelTTF * best = [CCLabelTTF labelWithString:@"最佳!" fontName:@"-" fontSize:40];
        best.position=CGPointMake(self.contentSize.width/2, self.contentSize.height*0.93);
        best.color=ccBLACK;
        [self addChild:best];
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * dic = [userDefaults objectForKey:@"record"];
        int scorce;
        if (dic) {
            scorce = [[dic objectForKey:@"scoure"]intValue];
        }else{
            scorce=0;
        }
        NSString * str = [self returnLevel:scorce];
        CCLabelTTF * level = [CCLabelTTF labelWithString:str fontName:@"-" fontSize:40];
        level.position=CGPointMake(self.contentSize.width/2, self.contentSize.height*0.82);
        level.color=ccBLACK;
        [self addChild:level];
        
        CCLabelTTF * chive = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"战绩:%d",scorce] fontName:@"-" fontSize:40];
        chive.color = ccBLACK;
        chive.position=CGPointMake(self.contentSize.width/2, self.contentSize.height*0.70);
        [self addChild:chive];
        sound = [CCMenuItemFont itemWithString:@"音效:开" block:^(id sender) {
            music=!music;
            [self changeSound];
        }];
        sound.fontName=@"-";
        sound.fontSize=40;
        if (music) {
            [sound setString:@"音效:开"];
            [[SimpleAudioEngine sharedEngine]setMute:!music];
        }else{
            [sound setString:@"音效:关"];
             [[SimpleAudioEngine sharedEngine]setMute:!music];
        }
        
        CCMenu * menu = [CCMenu menuWithItems:sound, nil];
        menu.position=CGPointMake(self.contentSize.width/2, self.contentSize.height*0.47);
        sound.color=ccRED;
        [self addChild:menu];
        
        
        CCMenuItemFont * message = [CCMenuItemFont itemWithString:@"英雄所见略同" block:^(id sender) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://15137348047"]];
        }];
        message.fontName=@"-";
        message.fontSize=25 ;
        message.color=ccRED;
        CCMenu * mess = [CCMenu menuWithItems:message, nil];
        mess.position=CGPointMake(self.contentSize.width/2, self.contentSize.height*0.35);
        [self addChild:mess];
        
        [self creatAnimation];
        
    }
    return self;
}
-(void)creatAnimation{
    CCLabelTTF * label1 = [CCLabelTTF labelWithString:@"模仿无罪" fontName:@"-" fontSize:20];
    CCLabelTTF * label2 = [CCLabelTTF labelWithString:@"仅供学习" fontName:@"-" fontSize:20];
    label1.position = CGPointMake(self.contentSize.width/2, self.contentSize.height*0.25);
    label2.position = CGPointMake(self.contentSize.width/2, self.contentSize.height*0.15);
    [self addChild:label1];
    [self addChild:label2];
    
    CCTintTo * tintR1 = [CCTintTo actionWithDuration:1 red:255 green:0 blue:0];
    CCTintTo * tintG1 = [CCTintTo actionWithDuration:1 red:0 green:255 blue:0];
    CCTintTo * tintB1 = [CCTintTo actionWithDuration:1 red:0 green:0 blue:255];
    CCSequence * seq1 = [CCSequence actions:tintR1,tintG1,tintB1, nil];
    CCBlink * blick1 = [CCBlink actionWithDuration:1.5 blinks:10];
    CCRotateBy * rotate = [CCRotateBy actionWithDuration:3 angle:360];
    CCSpawn* spa = [CCSpawn actions:seq1, rotate,blick1, nil];
    CCRepeatForever * fover1 = [CCRepeatForever actionWithAction:spa];
    
    CCTintTo * tintR2 = [CCTintTo actionWithDuration:1 red:255 green:0 blue:0];
    CCTintTo * tintG2 = [CCTintTo actionWithDuration:1 red:0 green:255 blue:0];
    CCTintTo * tintB2 = [CCTintTo actionWithDuration:1 red:0 green:0 blue:255];
    CCRotateBy * rotate2 = [CCRotateBy actionWithDuration:3 angle:360];
    CCBlink * blick2 = [CCBlink actionWithDuration:1.5 blinks:10];
    CCSequence * seq2 = [CCSequence actions:tintR2,tintG2,tintB2, nil];
     CCSpawn* spa2 = [CCSpawn actions:seq2, rotate2,blick2, nil];
    CCRepeatForever * fover2 = [CCRepeatForever actionWithAction:spa2];
    
    [label1 runAction:fover1];
    [label2 runAction:fover2];
    
}

-(void)changeSound{
    if (music) {
        [sound setString:@"音效:开"];
         [[SimpleAudioEngine sharedEngine]setMute:!music];
        
    }else{
        [sound setString:@"音效:关"];
         [[SimpleAudioEngine sharedEngine]setMute:!music];
    }
}
-(NSString*)returnLevel:(int)s{
    if (s<10) {
        return @"江湖菜鸟";
    }else if (s>=10&&s<25){
        return @"无名小生";
    }else if (s>=25&&s<40){
        return @"小有名气";
    }else if(s>=40&&s<60){
        return @"名震一方";
    }else if (s>=60&&s<90){
        return @"神剑百手";
    }else if (s>=90&&s<120){
        return @"东方不败";
    }else if (s>=120&&s<160){
        return @"不死之身";
    }else {
        return @"开发者";
    }
}

@end
