//
//  LevelScreenLayer.m
//  FragileEggs
//
//  Created by socialapp on 5/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelScreenLayer.h"


@implementation LevelScreenLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelScreenLayer *layer = [LevelScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
	
	self = [super init];
	if (self != nil){
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		backgroundImage = [CCSprite spriteWithFile:@"LevelMenuBkground.png"];		
		
		[backgroundImage setPosition: CGPointMake(screenSize.width/2, screenSize.height/2)];
		
		[self addChild:backgroundImage z:0];
		
		menuItem1 = [CCMenuItemImage itemFromNormalImage:@"Level1.png"
															 selectedImage: @"Level1.png"
																	target:self
																  selector:@selector(selectLevelOne)];
		menuItem2 = [CCMenuItemImage itemFromNormalImage:@"Level2.png"
															 selectedImage: @"Level2.png"
																	target:self
																  selector:@selector(selectLevelTwo)];
		menuItem3 = [CCMenuItemImage itemFromNormalImage:@"Level3.png"
															 selectedImage: @"Level3.png"
																	target:self
																  selector:@selector(selectLevelThree)];
		
		// Create a menu and add your menu items to it
		myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
		[myMenu setPosition:ccp(screenSize.width/2, screenSize.height/2)];
		[myMenu alignItemsHorizontally];
		
		// add the menu to your scene
		[self addChild:myMenu z:5];
		
		CCLabelTTF *instr = [CCLabelTTF labelWithString:@"Choose Your Level" 
								 dimensions:CGSizeMake(500, 120) alignment:UITextAlignmentCenter
								   fontName:@"Helvetica" fontSize:42];
		[instr setPosition:ccp(screenSize.width/2, screenSize.height-150)];
		instr.color = ccc3(0, 0, 0);
		[self addChild:instr z:3];
		
		self.isTouchEnabled = YES;
	}
	return self;
}

-(void) selectLevelOne{
	[[SceneManager sharedSceneManager] setGameStage:1];
	[[SceneManager sharedSceneManager] setGameLevel:1];
	[SceneManager goGameScreen];
}

-(void) selectLevelTwo{
	[[SceneManager sharedSceneManager] setGameStage:1];
	[[SceneManager sharedSceneManager] setGameLevel:2];
	[SceneManager goGameScreen];
}

-(void) selectLevelThree{
	[[SceneManager sharedSceneManager] setGameStage:1];
	[[SceneManager sharedSceneManager] setGameLevel:3];
	[SceneManager goGameScreen];
}

- (void) dealloc{
	[super dealloc];
}

@end
