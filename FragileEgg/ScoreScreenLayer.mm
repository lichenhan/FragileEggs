//
//  LevelScreenLayer.m
//  FragileEggs
//
//  Created by socialapp on 5/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ScoreScreenLayer.h"


@implementation ScoreScreenLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ScoreScreenLayer *layer = [ScoreScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
	
	self = [super init];
	if (self != nil){
		
		level = [SceneManager sharedSceneManager].gameLevel;
		stage = [SceneManager sharedSceneManager].gameStage;
		
		randomNumber = (arc4random()%9)+1;
		
		NSLog(@"%d",randomNumber);
		
		canTransition = YES;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		backgroundImage = [CCSprite spriteWithFile:@"crackegg1.png"];		
		
		[backgroundImage setPosition: CGPointMake(screenSize.width/2, screenSize.height/2)];
		
		[self addChild:backgroundImage z:0];
		
		tap = [CCLabelTTF labelWithString:@"Tap Me!" 
							   dimensions:CGSizeMake(200, 100) alignment:UITextAlignmentCenter
								 fontName:@"Helvetica" fontSize:32];
		
		[tap setPosition:ccp(screenSize.width/2, screenSize.height/(1.5))];
		tap.color = ccc3(0, 0, 0);
		[self addChild:tap z:3];
		   
		score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", [SceneManager sharedSceneManager].levelScore] 
								 dimensions:CGSizeMake(190, 60) alignment:UITextAlignmentCenter
								   fontName:@"Helvetica" fontSize:60];
		[score setPosition:ccp(500, 330)];
		score.color = ccc3(0, 0, 0);
		[self addChild:score z:3];					 
							 
							 
		self.isTouchEnabled = YES;
	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self removeChild:tap cleanup:YES];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self ccTouchesCancelled:touches withEvent:event];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if(canTransition){
		canTransition = NO;
		
		CCAnimation *anim = [CCAnimation animation];
		[anim addFrameWithFilename:@"crackegg2.png"];
		[anim addFrameWithFilename:@"crackegg3.png"];
		
		switch (randomNumber)
		{
			case 9:
				[anim addFrameWithFilename:@"crackegg20.png"];
				[anim addFrameWithFilename:@"crackegg21.png"];
				[anim addFrameWithFilename:@"crackegg20.png"];
				break;
				
			case 8:
				[anim addFrameWithFilename:@"crackegg18.png"];
				[anim addFrameWithFilename:@"crackegg19.png"];
				[anim addFrameWithFilename:@"crackegg18.png"];
				break;
				
			case 7:
				[anim addFrameWithFilename:@"crackegg16.png"];
				[anim addFrameWithFilename:@"crackegg17.png"];
				[anim addFrameWithFilename:@"crackegg16.png"];
				break;
				
			case 6:
				[anim addFrameWithFilename:@"crackegg14.png"];
				[anim addFrameWithFilename:@"crackegg15.png"];
				[anim addFrameWithFilename:@"crackegg14.png"];
				break;
				
			case 5:
				[anim addFrameWithFilename:@"crackegg12.png"];
				[anim addFrameWithFilename:@"crackegg13.png"];
				[anim addFrameWithFilename:@"crackegg12.png"];
				break;
				
			case 4:
				[anim addFrameWithFilename:@"crackegg10.png"];
				[anim addFrameWithFilename:@"crackegg11.png"];
				[anim addFrameWithFilename:@"crackegg10.png"];
				break;
				
			case 3:
				[anim addFrameWithFilename:@"crackegg8.png"];
				[anim addFrameWithFilename:@"crackegg9.png"];
				[anim addFrameWithFilename:@"crackegg8.png"];
				break;
				
			case 2:
				[anim addFrameWithFilename:@"crackegg6.png"];
				[anim addFrameWithFilename:@"crackegg7.png"];
				[anim addFrameWithFilename:@"crackegg6.png"];
				break;
				
			case 1:
				[anim addFrameWithFilename:@"crackegg4.png"];
				[anim addFrameWithFilename:@"crackegg5.png"];
				[anim addFrameWithFilename:@"crackegg4.png"];
				break;
				
			default:
				return;
		}
		
		CCAnimate *bgAnim = [CCAnimate actionWithDuration:1.0f animation:anim restoreOriginalFrame:NO];
		[backgroundImage runAction:[CCSequence actions:                          
									bgAnim,[CCCallFunc actionWithTarget:self selector:@selector(goNextLevel)],nil]];
	}
}

-(void)goNextLevel{
	[engine playEffect:@"UI_ok.wav"];
	sleep(1);
	if(stage == 1 && level == 1){
		[[SceneManager sharedSceneManager] setGameStage:2];
		[[SceneManager sharedSceneManager] setGameLevel:1];
	}else if(stage == 2 && level == 1){
		[[SceneManager sharedSceneManager] setGameStage:3];
		[[SceneManager sharedSceneManager] setGameLevel:1];
	}else if(stage == 3 && level == 1){
		[[SceneManager sharedSceneManager] setGameStage:1];
		[[SceneManager sharedSceneManager] setGameLevel:2];
	}else if(stage == 1 && level == 2){
		[[SceneManager sharedSceneManager] setGameStage:2];
		[[SceneManager sharedSceneManager] setGameLevel:2];
	}else if(stage == 2 && level == 2){
		[[SceneManager sharedSceneManager] setGameStage:3];
		[[SceneManager sharedSceneManager] setGameLevel:2];
	}else if(stage == 3 && level == 2){
		[[SceneManager sharedSceneManager] setGameStage:1];
		[[SceneManager sharedSceneManager] setGameLevel:3];
	}else if(stage == 1 && level == 3){
		[[SceneManager sharedSceneManager] setGameStage:2];
		[[SceneManager sharedSceneManager] setGameLevel:3];
	}else if(stage == 2 && level == 3){
		[[SceneManager sharedSceneManager] setGameStage:3];
		[[SceneManager sharedSceneManager] setGameLevel:3];
	}else{
		[SceneManager goStartScreen];
		return;
	}
	[SceneManager goGameScreen];
}

- (void) dealloc{
	[super dealloc];
}

@end
