//
//  HelloWorldLayer.m
//  MyStickHero
//
//  Created by 大脚a on 14-12-8.
//  Copyright DJ_ZYH 2014年. All rights reserved.
/*
 这个界面是游戏的主界面，控制切换
 */


// Import the interfaces
#import "HelloWorldLayer.h"
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
//    NSArray * familyName = [UIFont familyNames];
//    for (NSString * name in familyName) {
//        printf("Family:%s\n",[name UTF8String]);
//        NSArray * font = [UIFont fontNamesForFamilyName:name];
//        for (NSString * fontName  in font) {
//            printf("\tfont:%s\n",[fontName UTF8String]);
//        }
//    }
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        //游戏主视图
        
        CCSprite * bg = [CCSprite spriteWithFile:@"Game.jpg"];
        bg.position=CGPointMake(SCREEN_SIZE.width/2, SCREEN_SIZE.height/2);
        [self addChild:bg];
        _main = [[CCLayer alloc]init];
        _main.contentSize=SCREEN_SIZE;
        _main.position=CGPointZero;
        [_main addChild:[GameLayer scene]];
        //左视图
        _left = [[LeftLayer alloc]init];
        _left.position = CGPointMake(-_left.contentSize.width, 0);
        [self addChild:_left];
        [self addChild:_main];
    }
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    CCLOG(@"dealloc:%@",[self class]);
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    [_left release];
    [_main release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
