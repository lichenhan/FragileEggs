//
//  SceneManager.m
// 

#import "SceneManager.h"

@implementation SceneManager
static SceneManager* _sharedSceneManger = nil;

@synthesize playerName;
@synthesize gameLevel, gameStage, levelScore, moveCount;
@synthesize scoreArray;

+(SceneManager*)sharedSceneManager{
	@synchronized([SceneManager class])
	{
		if(!_sharedSceneManger){
			[[self alloc] init];
		}
		return _sharedSceneManger;
	}
	return nil;
}

+(id)alloc{
	@synchronized ([SceneManager class])
	{
		NSAssert(_sharedSceneManger == nil, 
				 @"attempted to allocate a second instance of SceneManager singleton");
		_sharedSceneManger = [super alloc];
		return _sharedSceneManger;
	}
	return nil;
}

-(id)init{
	self = [super init];
	if(self != nil){
	}
	return self;
}

+(void) goStartScreen {
    [SceneManager go:[StartScreenLayer node]];
}

+(void) goLevelScreen {
    [SceneManager go:[LevelScreenLayer node]];
}

+(void) goGameScreen {
    [SceneManager go:[GameLayer node]];
}

+(void) goScoreScreen {
    [SceneManager go:[ScoreScreenLayer node]];
}

+(void) goHighScoresScreen {
    [SceneManager go:[HighScoresLayer node]];
}

+(void) go: (CCLayer *) layer {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {        
        [director replaceScene:newScene];
    }
    else {
        [director runWithScene:newScene];
    }
}

+(CCScene *) wrap: (CCLayer *) layer {
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
}

@end
