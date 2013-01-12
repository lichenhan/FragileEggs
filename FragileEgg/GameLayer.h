//
//  GameLayer.h
//  FragileEggs
//
//  Created by socialapp on 5/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "GLES-Render.h"
#import "SceneManager.h"
#import "EggObject.h"

@interface GameLayer : CCLayer {
	int stage;
	int level;
	int eggCount;
	int eggNumber;
	BOOL worldGravity;
	bool gravityTurnedOnBefore;
	int angle;
	BOOL loaded;
	BOOL paused;
	
	CCLabelTTF *timeLabel;
	ccTime totalTime;
	int myTime; //this is your incremented time.
	int currentTime;
	int oldTime;
	
	CCMenuItem *pauseButton;
	CCSprite *box;
	CCMenu *myMenu;
	
	b2World* world;
	b2Vec2 gravity;
	GLESDebugDraw *m_debugDraw;
	b2MouseJoint *mouseJoint;
	b2Body *groundBody;
	
	CCSprite *birdCoo;
	CCAnimation *animB;
	CCAnimate *birdCooAnim;
	
	SimpleAudioEngine *engine;
	
	EggObject *currentEgg;
	
	EggObject *egg1;
	EggObject *egg2;
	EggObject *egg3;
	EggObject *egg4;
	EggObject *egg5;
	EggObject *egg6;
	EggObject *egg7;
	EggObject *egg8;
	EggObject *egg9;
	EggObject *egg10;
	EggObject *egg11;
	EggObject *egg12;
	EggObject *egg13;
	EggObject *egg14;
	EggObject *egg15;
	
	id action1;
	id action2;
	id action3;
	id action4;
	id action5;
	id action6;
	id action7;
	id action8;
	id action9;
	id action10;
	id action11;
	id action12;
	id action13;
	id action14;
	id action15;
	id actionCallFunc;
}

@property int myTime;

+(CCScene *) scene;
//-(id) initWithValues:(int)l :(int)s;
-(void) addEggs;
-(void) birdCooAnimate;
-(void) turnOffGravity:(b2Body *)b;
-(void) turnOnGravity:(b2Body *)b;
-(void) goNextLevel;
-(void) goMainMenu;
-(void) pauseGame;
-(void) resumeGame;
-(void) resetTime;

@end
