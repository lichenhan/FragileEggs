//
//  LevelScreenLayer.h
//  FragileEggs
//
//  Created by socialapp on 5/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GLES-Render.h"
#include <stdlib.h>
#import "SimpleAudioEngine.h"
#import "SceneManager.h"


@interface ScoreScreenLayer : CCLayer {
	CCSprite *backgroundImage;
	int randomNumber;
	SimpleAudioEngine *engine;
	BOOL canTransition;
	CCLabelTTF *tap;
	CCLabelTTF *score;
	int level;
	int stage;
}

+(CCScene *) scene;
-(void) goNextLevel;

@end
