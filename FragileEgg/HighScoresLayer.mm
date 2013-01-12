//
//  LevelScreenLayer.m
//  FragileEggs
//
//  Created by socialapp on 5/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScoresLayer.h"


@implementation HighScoresLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HighScoresLayer *layer = [HighScoresLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
	
	self = [super init];
	if (self != nil){
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		CCSprite *backgroundImage = [CCSprite spriteWithFile:@"LevelMenuBkground.png"];		
		[backgroundImage setPosition: CGPointMake(screenSize.width/2, screenSize.height/2)];
		[self addChild:backgroundImage z:0];
		
		NSString *item;
		
		CCLabelTTF *back = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Currently Running iOS version: %@. \nTap to Return",
														[[UIDevice currentDevice] systemVersion]]
											dimensions:CGSizeMake(1000,100) alignment:UITextAlignmentCenter
											  fontName:@"Helvetica" fontSize:28];
		[back setPosition:ccp(screenSize.width/2,700)];
		back.color = ccc3(0,0,0);
		[self addChild:back z:1];
		
		int c = 1;
		for (item in [[SceneManager sharedSceneManager].scoreArray reverseObjectEnumerator]) {
			
			if((c*30)>668){
				break;
			}
			
			CCLabelTTF *text = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", item] 
												dimensions:CGSizeMake(1000, 30) alignment:UITextAlignmentCenter
												  fontName:@"Helvetica" fontSize:24];
			[text setPosition:ccp(screenSize.width/2,668-(30*c))];
			text.color = ccc3(0,0,0);
			[self addChild:text z:1];
			c++;
			
			NSLog(@"ITEM ADDED");
		}
		
		self.isTouchEnabled = YES;
	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self ccTouchesCancelled:touches withEvent:event];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[SceneManager goStartScreen];
}

- (void) dealloc{
	[super dealloc];
}

@end
