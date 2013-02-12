//
//  SceneManager.h
//  FragileEggs
//
//  Created by socialapp on 5/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

//
//  SceneManager.h
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "StartScreenLayer.h"
#import "LevelScreenLayer.h"
#import "GameLayer.h"
#import "ScoreScreenLayer.h"
#import "HighScoresLayer.h"

@interface SceneManager : NSObject {
	NSString *playerName;
	int gameLevel;
	int gameStage;
	int levelScore;
	int moveCount;
	NSMutableArray *scoreArray;
}

@property (nonatomic, retain) NSString *playerName;
@property (nonatomic, assign) int gameLevel;
@property (nonatomic, assign) int gameStage;
@property (nonatomic, assign) int levelScore;
@property (nonatomic, assign) int moveCount;
@property (nonatomic, retain) NSMutableArray *scoreArray;

+(SceneManager *)sharedSceneManager;

+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;

+(void) goStartScreen;
+(void) goLevelScreen;
+(void) goGameScreen;
+(void) goScoreScreen;
+(void) goHighScoresScreen;

@end

