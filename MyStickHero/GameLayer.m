//
//  GameLayer.m
//  MyStickHero
//
//  Created by 大脚a on 14-12-8.
//  Copyright 2014年 DJ_ZYH. All rights reserved.
/*
 这个类来进行游戏
 */

#import "GameLayer.h"
#import "RoadLayerColor.h"
#import "Hero.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
@implementation GameLayer
{
    CCLayerRGBA * _perparaBegin;//准备开始游戏的层
    CCSprite * _bj;//背景
    //游戏标题标签
    CCLabelTTF * _gameTitle;
    //游戏开始按钮
    CCMenuItemAtlasFont * _beginGame;
    CCArray * _roadArray;//放置陆地的数组
    Hero * _hero;//英雄
    BOOL _isStart;//游戏开关
    CCLayerColor * _stick;//棒子
    BOOL _isEnter;//标记被按下
    BOOL _isCouldLong;//开关棍子是否可以张长
    CCLabelTTF * _scoreLabel;//分数文本
    int _score;//分数
    BOOL _isCouldOpenLeft;//是否可以打开做抽屉
    CGPoint _startPoint;//点击起始点
    CGPoint _movePoint;//手指移动点
    BOOL _openningLeft;//正在打开左视图
    ALuint * _longSound;
    BOOL * _islongSound;//正在播放
}
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    GameLayer *layer = [GameLayer node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}
-(void)dealloc{
    CCLOG(@"dealloc:%@",[self class]);
    [_stick release];
    [_roadArray release];
    [super dealloc];
}
#pragma mark - 初始化数组
-(void)creatArray{
    _roadArray = [[CCArray alloc]init];
    //初始化放三个
    for (int i=0; i<3; i++) {
        RoadLayerColor * road = [[RoadLayerColor alloc]initWithMaxWidth:150];
        [_roadArray addObject:road];
        [road release];
    }
}
//初始化函数
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatArray];
        
        [[[CCDirector sharedDirector]touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        self.contentSize=CGSizeMake(SCREEN_SIZE.width,SCREEN_SIZE.height);
        //创建背景
        _bj = [CCSprite spriteWithFile:@"bg.jpg"];
        _bj.position=CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_bj];
        
        _gameTitle = [CCLabelTTF labelWithString:@"棍子英雄" fontName:@"-" fontSize:60];
        _gameTitle.color=ccBLACK;
        _gameTitle.position = CGPointMake(SCREEN_SIZE.width/2, SCREEN_SIZE.height*4/5);
        _perparaBegin = [CCLayerRGBA node];
        _perparaBegin . position = CGPointMake(0, 0);
        [_bj addChild:_perparaBegin];
        [_perparaBegin addChild:_gameTitle];
        CCLabelTTF * tmp = [CCLabelTTF labelWithString:@"开始游戏" fontName:@"-" fontSize:45];
        tmp.color=ccBLACK;
        _beginGame = [CCMenuItemAtlasFont itemWithLabel:tmp target:self selector:@selector(beginGame:)];
        CCMenu * menu = [CCMenu menuWithItems:_beginGame, nil];
        [_perparaBegin addChild:menu];
        
        //初始化小人和土地
        CCLayerColor * firstRoad = [_roadArray objectAtIndex:0];
        firstRoad.position = CGPointMake(0 ,0);
        [_bj addChild:firstRoad];
        
        CCLayerColor * secondRoad = [_roadArray objectAtIndex:1];
        secondRoad.position = CGPointMake([[_roadArray objectAtIndex:0]contentSize].width+(SCREEN_SIZE.width-[[_roadArray objectAtIndex:1]contentSize].width-[[_roadArray objectAtIndex:0]contentSize].width)/2, 0);
        [_bj addChild:secondRoad];
        
        CCLayerColor * thirdRoad = [_roadArray objectAtIndex:2];
        thirdRoad.position=CGPointMake(SCREEN_SIZE.width, 0);
        [_bj addChild:thirdRoad];
        
        _hero= [Hero new];
        _hero.position=CGPointMake(firstRoad.contentSize.width-10, firstRoad.contentSize.height);
        [_bj addChild:_hero];
        [_hero release];
        
        //创建棒子
        _stick = [[CCLayerColor alloc]initWithColor:ccc4(0, 0, 0, 255) width:0 height:0];
        [_bj addChild:_stick];
        _isCouldLong=YES;
        _stick.anchorPoint=CGPointMake(0, 0);
        
        _scoreLabel=[CCLabelTTF labelWithString:@"江湖菜鸟:0" fontName:@"-" fontSize:25];
        _scoreLabel.position=CGPointMake(SCREEN_SIZE.width/2, SCREEN_SIZE.height*4/5);
        _scoreLabel.opacity=0;
        [_bj addChild:_scoreLabel];
        
        //预加载
        [[SimpleAudioEngine sharedEngine]preloadBackgroundMusic:@"bg_snow.wav"];
        //[[SimpleAudioEngine sharedEngine]preloadEffect:@"123.m4a"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"dead.wav"];
        [[SimpleAudioEngine  sharedEngine]preloadEffect:@"kick.wav"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"stick_grow_loop.wav"];
        [[SimpleAudioEngine  sharedEngine]preloadEffect:@"score.wav"];
        [[SimpleAudioEngine  sharedEngine]playBackgroundMusic:@"bg_snow.wav" loop:YES];
    }
    return self;
}
-(void)beginGame:(CCMenuItem*)iten{
    HelloWorldLayer *layer = (HelloWorldLayer*)self.parent.parent.parent;
    if (self.parent.parent.position.x>10) {
        CCMoveTo * mo = [CCMoveTo actionWithDuration:0.3 position:CGPointZero];
        CCScaleTo * sc = [CCScaleTo actionWithDuration:0.3 scale:1];
        CCMoveTo * move2 = [CCMoveTo actionWithDuration:0.3 position:CGPointMake(-150, 0)];
        CCScaleTo * sc2 = [CCScaleTo actionWithDuration:0.3 scale:0.7];
        
        [self.parent.parent runAction:mo];
        [self.parent.parent runAction:sc];
        [layer.left runAction:move2];
        [layer.left runAction:sc2];
    }
   // [[SimpleAudioEngine sharedEngine]playEffect:@"button.m4a" loop:false gain:1.0];
    _isStart=YES;
    _scoreLabel.opacity=255;
    _isCouldOpenLeft=NO;
    CCHide * hide = [CCHide action];
    [_perparaBegin runAction:hide];
    //开启定时器
    [self unscheduleUpdate];
    [self scheduleUpdate];
}

-(void)update:(ccTime)delta{
    if (_isEnter) {
        if (!_islongSound) {
           _longSound = [[SimpleAudioEngine sharedEngine]playEffect:@"stick_grow_loop.wav" loop:true gain:0.5f];
            
            _islongSound=YES;
        }
        _stick.contentSize=CGSizeMake(2, 2+_stick.contentSize.height);
        _stick.position=CGPointMake([[_roadArray objectAtIndex:0] contentSize].width, 150);
        
    }
    if (_islongSound&&_longSound) {
        [[SimpleAudioEngine  sharedEngine]stopEffect:_longSound];
        _islongSound=NO;
    }
}

#pragma merk - 点击屏幕触发
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (!_isStart||!_isCouldLong) {
        if (!_isStart) {
            CGPoint p = [touch locationInView:[touch view]];
            if (p.x<100&&!_openningLeft) {
                _isCouldOpenLeft=YES;
                _startPoint=p;
            }else if (_openningLeft){
                _isCouldOpenLeft=YES;
                _startPoint=p;
            }else{
                _isCouldOpenLeft=NO;
            }
        }
        return YES;
    }
    _isEnter=YES;
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_isCouldOpenLeft) {
        CGPoint p = [touch locationInView:[touch view]];
        _movePoint=p;
        int offset = _movePoint.x-_startPoint.x;
        
           HelloWorldLayer* layer = (HelloWorldLayer *)self.parent.parent.parent;
        
        if (layer.left.position.x+offset>=-150&&layer.left.position.x+offset<=0) {
            layer.main.position=CGPointMake(layer.main.position.x+offset, layer.main.position.y);
            layer.left.position=CGPointMake(layer.left.position.x+offset, layer.left.position.y);
            _startPoint=_movePoint;
            
            CGFloat  realOffset = layer.main.position.x;
            layer.main.scale=1-realOffset/150.0*0.3;
            layer.left.scale=0.7+realOffset/150.0*0.3;
        }
        
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    HelloWorldLayer * layer = (HelloWorldLayer *)self.parent.parent.parent;
    if (layer.left.position.x>=-75&&_isCouldOpenLeft) {
        CCMoveTo * move = [CCMoveTo actionWithDuration:0.3 position:CGPointMake(0, 0)];
        CCMoveTo * move2 = [CCMoveTo actionWithDuration:0.3 position:CGPointMake(150, 0)];
        [layer.left runAction:move];
        [layer.main runAction:move2];
        CCScaleTo * sc = [CCScaleTo actionWithDuration:0.3 scale:0.7];
        CCScaleTo * sc2 = [CCScaleTo actionWithDuration:0.3 scale:1];
        [layer.left runAction:sc2];
        [layer.main runAction:sc];
        _openningLeft=YES;
    }else if (layer.left.position.x<75&&_isCouldOpenLeft){
        CCMoveTo * move = [CCMoveTo actionWithDuration:0.3 position:CGPointMake(-150, 0)];
        CCMoveTo * move2 = [CCMoveTo actionWithDuration:0.3 position:CGPointMake(0, 0)];
        [layer.left runAction:move];
        [layer.main runAction:move2];
        CCScaleTo * sc = [CCScaleTo actionWithDuration:0.3 scale:1];
        CCScaleTo * sc2 = [CCScaleTo actionWithDuration:0.3 scale:0.7];
        [layer.left runAction:sc2];
        [layer.main runAction:sc];
        _openningLeft=NO;
    }
    if (!_isStart||!_isCouldLong||!_isEnter) {
        return;
    }
    _isEnter=NO;
    _isCouldLong=NO;
    [self disPlayGame];
}
-(void)disPlayGame{
    CCRotateTo * rotate = [CCRotateTo actionWithDuration:0.5 angle:90];
    [_stick runAction:rotate];
    [self performSelector:@selector(peopleMove) withObject:nil afterDelay:0.5];
}
-(void)peopleMove{
    [[SimpleAudioEngine  sharedEngine]playEffect:@"kick.wav" loop:false gain:1.0];
    CCMoveTo * moveTo = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(_hero.position.x+_stick.contentSize.height+10, _hero.position.y)];
    [_hero runAction:moveTo];
    [self performSelector:@selector(isGameOver) withObject:nil afterDelay:0.6];
}
-(void)isGameOver{
    if (_hero.position.x>[(CCNode*)[_roadArray objectAtIndex:1]position].x&&_hero.position.x<[(CCNode*)[_roadArray objectAtIndex:1]position].x+[[_roadArray objectAtIndex:1]contentSize].width) {
        [self goOn];
        [[SimpleAudioEngine sharedEngine]playEffect:@"score.wav" loop:false gain:1.0] ;
    }else{
        _isStart=NO;
        [self gameOver];
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

//继续游戏
-(void)goOn{
    //分数++ 刷新计分板
    _score++;
    _scoreLabel.string=[NSString stringWithFormat:@"%@:%d",[self returnLevel:_score],_score];
    //所有的土地和人物后移 棒子还原
    CGPoint point = CGPointMake([(CCNode *)[_roadArray objectAtIndex:1]position].x, 0);
    for (int i=0; i<3; i++) {
        if (i==2) {
          CGPoint point2 =  CGPointMake([[_roadArray objectAtIndex:1]contentSize].width+(SCREEN_SIZE.width-[[_roadArray objectAtIndex:2]contentSize].width-[[_roadArray objectAtIndex:1]contentSize].width)/2, 0);
            CCMoveTo * move2 = [CCMoveTo actionWithDuration:0.5 position:point2];
            [[_roadArray objectAtIndex:2] runAction:move2];
        }else{
            CGPoint point1 = CGPointMake([(CCNode*)[_roadArray objectAtIndex:i]position].x-point.x, 0);
            CCMoveTo * move = [CCMoveTo actionWithDuration:0.5 position:point1];
            [[_roadArray objectAtIndex:i] runAction:move];
        }
       
    }
    //移动棒子和小人
    CCMoveTo * move = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(_hero.position.x-point.x, _hero.position.y)];
    CCMoveTo * move2 = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(_stick.position.x-point.x, _stick.position.y)];
    [_hero runAction:move];
    [_stick runAction:move2];

    [self performSelector:@selector(peopleMove2) withObject:nil afterDelay:0.6];
}

-(void)peopleMove2{
    CCMoveTo * move = [CCMoveTo actionWithDuration:0.5 position:CGPointMake([[_roadArray objectAtIndex:1]contentSize].width-10, _hero.position.y)];
    [_hero runAction:move];
    [self performSelector:@selector(regist) withObject:nil afterDelay:0.6];
}

-(void)regist{
    _stick.rotation=0;
    _stick.contentSize=CGSizeZero;
    [_roadArray removeObjectAtIndex:0];
    RoadLayerColor * road = [[RoadLayerColor alloc]initWithMaxWidth:150];
    road.position=CGPointMake(SCREEN_SIZE.width, 0);
    [_bj addChild:road];
    [_roadArray addObject:road];
    [road release];
    _isCouldLong=YES;
}

//结束游戏

-(void)gameOver{
    //存数据
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * records = [userDefaults objectForKey:@"record"];
    if (records==nil) {
        NSDictionary * dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_score] forKey:@"scoure"];
        [userDefaults setObject:dic forKey:@"record"];
        [userDefaults synchronize];
    }
    int best = [[records objectForKey:@"scoure"]intValue];
    if (_score>best) {
        NSDictionary * dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_score] forKey:@"scoure"];
        [userDefaults setObject:dic forKey:@"record"];
        [userDefaults synchronize];
    }
    CCRotateTo * roto = [CCRotateTo actionWithDuration:0.5 angle:180];
    [_stick runAction:roto];
    CCMoveTo * move =[CCMoveTo actionWithDuration:0.5 position:CGPointMake(_hero.position.x, -100)];
    [_hero runAction:move];
    [self performSelector:@selector(playGameOver) withObject:nil afterDelay:0.3];
    CCTransitionFade * trans = [CCTransitionFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene] withColor:ccRED];
    [[[CCDirector sharedDirector]touchDispatcher]removeDelegate:self];
    [[CCDirector sharedDirector]replaceScene:trans];
}
-(void)playGameOver{
    [[SimpleAudioEngine  sharedEngine]playEffect:@"dead.wav" loop:false gain:1.0];
}
@end
