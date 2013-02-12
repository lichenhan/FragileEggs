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
#import "SceneManager.h"


@interface LevelScreenLayer : CCLayer {
	CCMenu *myMenu;
	CCSprite *backgroundImage;
	CCMenuItemImage *menuItem1;
	CCMenuItemImage *menuItem2;
	CCMenuItemImage *menuItem3;
}

+(CCScene *) scene;

@end
