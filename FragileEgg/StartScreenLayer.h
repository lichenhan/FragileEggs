//
//  StartScreenLayer.h
//  FragileEggs
//
//  Created by socialapp on 5/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GLES-Render.h"
#import "SceneManager.h"
#import "SimpleAudioEngine.h"

@interface StartScreenLayer : CCLayer {
	CCSprite *backgroundImage;
	CCSprite *startEgg;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	b2MouseJoint *_mouseJoint;
	b2Body *startEggBody;
	b2Fixture *startEggFixture;
	b2Body *groundBody;
	CCLabelTTF *instr;
	CCLabelTTF *name;
	UITextField *myTextField;
	CCMenu *myMenu;
	CGPoint final;
	NSString *entered;
	CCSprite *startBirdCoo;
	SimpleAudioEngine *engine;
	CCMenuItemImage *menuItem1;
	CCMenuItem *highScoreButton;
	CCMenu *highScoreMenu;
}

@property (assign) UITextField *myTextField;

+(CCScene *) scene;
-(void) addStartEgg:(CGPoint)p;
-(void) generateAlert;
-(void) birdCooEnded;
-(void) save;
-(void) showHighScores;

@end
