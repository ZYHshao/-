//
//  HelloWorldLayer.h
//  MyStickHero
//
//  Created by 大脚a on 14-12-8.
//  Copyright DJ_ZYH 2014年. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "LeftLayer.h"
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@property(nonatomic,retain)LeftLayer * left;
@property(nonatomic,retain)CCLayer * main;
@end
