//
//  GameLayer.m
//  FragileEggs
//
//  Created by socialapp on 5/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "Constants.h"
#import "QueryCallback.h"

#define ALLOTED_TIME 30

@implementation GameLayer

@synthesize myTime;

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

-(id) init{
	
	self = [super init];
	if (self != nil){
		loaded = NO;
		paused = NO;
		
		stage = [SceneManager sharedSceneManager].gameStage;
		level = [SceneManager sharedSceneManager].gameLevel;
		[SceneManager sharedSceneManager].levelScore = 0;
		[SceneManager sharedSceneManager].moveCount = 0;
		
		if(level == 1){
			eggCount = 3;
			eggNumber = 3;
		}else if(level == 2){
			eggCount = 9;
			eggNumber = 9;
		}else if(level == 3){
			eggCount = 15;
			eggNumber = 15;
		}
		worldGravity = YES;
		gravityTurnedOnBefore = NO;
		angle = 0;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		// Define the gravity vector.
		gravity.Set(0.0f, 0.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
		//		flags += b2DebugDraw::e_jointBit;
		//		flags += b2DebugDraw::e_aabbBit;
		//		flags += b2DebugDraw::e_pairBit;
		//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
		
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 4); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// top
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		CCSprite *backgroundImage; 
		
		if(level == 1){
			backgroundImage = [CCSprite spriteWithFile:@"Tree1Nest1.png"];		
		}else if(level == 2){
			backgroundImage = [CCSprite spriteWithFile:@"Tree2Nest3.png"];		
		}else if(level == 3){
			backgroundImage = [CCSprite spriteWithFile:@"Tree3Nest5_with_keys.png"];		
		}
		
		[backgroundImage setPosition: CGPointMake(screenSize.width/2, screenSize.height/2)];
		
		[self addChild:backgroundImage z:0];
		
		pauseButton = [CCMenuItemImage itemFromNormalImage:@"pause.png"
											 selectedImage: @"pause.png"
													target:self
												  selector:@selector(pauseGame)];
		pauseButton.position = ccp(110, 710);
		CCMenu *pauseMenu = [CCMenu menuWithItems:pauseButton, nil];
		[pauseMenu setPosition:CGPointZero];
		[self addChild:pauseMenu z:8];
		
		[self addEggs];
				
		self.isTouchEnabled = YES;
		
		CCSprite *wind;
		wind = [CCSprite spriteWithFile:@"Wind0.png"];
		wind.position = ccp(screenSize.width/2, screenSize.height/2);
		[self addChild:wind z:1];
		
		CCAnimation *animW = [CCAnimation animation];
        for(int i = 1; i <= 15; i++) {
            [animW addFrameWithFilename:[NSString stringWithFormat:@"Wind%d.png", i]];
        }
        CCAnimate *windAnim = [CCAnimate actionWithDuration:2.0f animation:animW restoreOriginalFrame:YES];
		
		[wind runAction:windAnim];
		
		birdCoo = [CCSprite spriteWithFile:@"BirdCoo1.png"];
		if(level == 1){
			birdCoo.position = ccp(610, 495);
		}else if(level == 2){
			birdCoo.position = ccp(630, 390);
		}else if(level == 3){
			birdCoo.position = ccp(580, 515);
		}
		[self addChild:birdCoo z:1];
		
		engine = [SimpleAudioEngine sharedEngine];
		[engine preloadEffect:@"sfx_happy_ding.wav"];
		[engine preloadEffect:@"sfx_sad_ding.wav"];
		
		myTime = ALLOTED_TIME;
		oldTime = 0;
		
		timeLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:48];
		timeLabel.position = CGPointMake(screenSize.width-50, 75);
		timeLabel.color = ccc3(0, 0, 0); //black
		// Adjust the label's anchorPoint's y position to make it align with the top.
		timeLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
		// Add the time label
		[self addChild:timeLabel z:10];
		
		[engine playBackgroundMusic:@"music.mp3" loop:YES];
		
		[self schedule:@selector(updateTime:)];
		
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void) addEggs{
	
	switch (level){
		case 3:
			egg1 = [EggObject spriteWithFile:@"level3_egg1.png"];
			egg2 = [EggObject spriteWithFile:@"level3_egg2.png"];
			egg3 = [EggObject spriteWithFile:@"level3_egg3.png"];
			egg4 = [EggObject spriteWithFile:@"level3_egg4.png"];
			egg5 = [EggObject spriteWithFile:@"level3_egg5.png"];
			egg6 = [EggObject spriteWithFile:@"level3_egg6.png"];
			egg7 = [EggObject spriteWithFile:@"level3_egg7.png"];
			egg8 = [EggObject spriteWithFile:@"level3_egg8.png"];
			egg9 = [EggObject spriteWithFile:@"level3_egg9.png"];
			egg10 = [EggObject spriteWithFile:@"level3_egg10.png"];
			egg11 = [EggObject spriteWithFile:@"level3_egg11.png"];
			egg12 = [EggObject spriteWithFile:@"level3_egg12.png"];
			egg13 = [EggObject spriteWithFile:@"level3_key1.png"];
			egg14 = [EggObject spriteWithFile:@"level3_key2.png"];
			egg15 = [EggObject spriteWithFile:@"level3_key3.png"];
			break;
		case 2:
			egg4 = [EggObject spriteWithFile:@"Egg4.png"];
			egg5 = [EggObject spriteWithFile:@"Egg5.png"];
			egg6 = [EggObject spriteWithFile:@"Egg6.png"];
			egg7 = [EggObject spriteWithFile:@"Egg7.png"];
			egg8 = [EggObject spriteWithFile:@"Egg8.png"];
			egg9 = [EggObject spriteWithFile:@"Egg9.png"];
			//no break
		case 1:
			egg1 = [EggObject spriteWithFile:@"Egg1.png"];
			egg2 = [EggObject spriteWithFile:@"Egg2.png"];
			egg3 = [EggObject spriteWithFile:@"Egg3.png"];
			break;
		default:
			return;
	}
	
	switch (level)
	{
		case 3:
			egg1.position = ccp(424, 691);
			egg2.position = ccp(480, 696);
			egg3.position = ccp(540, 697);
			egg4.position = ccp(238, 585);
			egg5.position = ccp(298, 601);
			egg6.position = ccp(359, 589);
			egg7.position = ccp(266, 414);
			egg8.position = ccp(331, 425);
			egg9.position = ccp(392, 421);
			egg10.position = ccp(633, 436);
			egg11.position = ccp(689, 430);
			egg12.position = ccp(742, 437);
			egg13.position = ccp(628, 600);
			egg14.position = ccp(686, 607);
			egg15.position = ccp(746, 610);
			
			egg1.final = ccp(424, 691);
			egg2.final = ccp(480, 696);
			egg3.final = ccp(540, 697);
			egg4.final = ccp(238, 585);
			egg5.final = ccp(298, 601);
			egg6.final = ccp(359, 589);
			egg7.final = ccp(266, 414);
			egg8.final = ccp(331, 425);
			egg9.final = ccp(392, 421);
			egg10.final = ccp(633, 436);
			egg11.final = ccp(689, 430);
			egg12.final = ccp(742, 437);
			egg13.final = ccp(628, 600);
			egg14.final = ccp(686, 607);
			egg15.final = ccp(746, 610);
			break;
			
		case 2:
			egg1.position = ccp(379, 688);
			egg2.position = ccp(447, 701);
			egg3.position = ccp(503, 688);
			egg4.position = ccp(196, 566);
			egg5.position = ccp(334, 553);
			egg6.position = ccp(268, 565);
			egg7.position = ccp(754, 591);
			egg8.position = ccp(691, 581);
			egg9.position = ccp(632, 595);
			
			egg1.final = ccp(379, 688);
			egg2.final = ccp(447, 701);
			egg3.final = ccp(503, 688);
			egg4.final = ccp(196, 566);
			egg5.final = ccp(334, 553);
			egg6.final = ccp(268, 565);
			egg7.final = ccp(754, 591);
			egg8.final = ccp(691, 581);
			egg9.final = ccp(632, 595);
			break;
		
		case 1:
			egg1.position = ccp(346, 682);
			egg2.position = ccp(415, 695);
			egg3.position = ccp(471, 682);
			
			egg1.final = ccp(346, 682);
			egg2.final = ccp(415, 695);
			egg3.final = ccp(471, 682);
			break;
		
		default:
			return;
	}
	
	switch (level){
		actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(addPhysicBodies)];
		case 3:
			if(stage == 2){
				egg10.rotation = 90;
				egg11.rotation = 90;
				egg12.rotation = 90;
				egg13.rotation = 90;
				egg14.rotation = 90;
				egg15.rotation = 90;
			}
			if(stage == 3){
				egg10.spinnable = YES;
				egg11.spinnable = YES;
				egg12.spinnable = YES;
				egg13.spinnable = YES;
				egg14.spinnable = YES;
				egg15.spinnable = YES;
			}
			[self addChild:egg10 z:5];
			[self addChild:egg11 z:5];
			[self addChild:egg12 z:5];
			[self addChild:egg13 z:5];
			[self addChild:egg14 z:5];
			[self addChild:egg15 z:5];
			
			action10 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(150, 150)];
			action11 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(850, 150)];
			action12 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(650, 150)];
			action13 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(450, 150)];
			action14 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(800, 150)];
			action15 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(750, 150)];
			
			[egg10 runAction:[CCSequence actions: action10, actionCallFunc, nil]];
			[egg11 runAction:[CCSequence actions: action11, nil]];
			[egg12 runAction:[CCSequence actions: action12, nil]];
			[egg13 runAction:[CCSequence actions: action13, nil]];
			[egg14 runAction:[CCSequence actions: action14, nil]];
			[egg15 runAction:[CCSequence actions: action15, nil]];
			//no break
		case 2:
			if(stage == 2){
				egg4.rotation = 90;
				egg5.rotation = 90;
				egg6.rotation = 90;
				egg7.rotation = 90;
				egg8.rotation = 90;
				egg9.rotation = 90;
			}
			if(stage == 3){
				egg4.spinnable = YES;
				egg5.spinnable = YES;
				egg6.spinnable = YES;
				egg7.spinnable = YES;
				egg8.spinnable = YES;
				egg9.spinnable = YES;
			}
			[self addChild:egg4 z:5];
			[self addChild:egg5 z:5];
			[self addChild:egg6 z:5];
			[self addChild:egg7 z:5];
			[self addChild:egg8 z:5];
			[self addChild:egg9 z:5];
			
			action4 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(300, 150)];
			action5 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(550, 150)];
			action6 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(250, 150)];
			action7 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(350, 150)];
			action8 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(700, 150)];
			action9 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(500, 150)];
			
			[egg4 runAction:[CCSequence actions: action4, actionCallFunc, nil]];
			[egg5 runAction:[CCSequence actions: action5, nil]];
			[egg6 runAction:[CCSequence actions: action6, nil]];
			[egg7 runAction:[CCSequence actions: action7, nil]];
			[egg8 runAction:[CCSequence actions: action8, nil]];
			[egg9 runAction:[CCSequence actions: action9, nil]];
			
			//no break
		case 1:
			if(stage == 2){
				egg1.rotation = 90;
				egg2.rotation = 90;
				egg3.rotation = 90;
			}
			if(stage == 3){
				egg1.spinnable = YES;
				egg2.spinnable = YES;
				egg3.spinnable = YES;
			}
			
			[self addChild:egg1 z:5];
			[self addChild:egg2 z:5];
			[self addChild:egg3 z:5];
			
			action1 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(600, 150)];
			action2 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(200, 150)];
			action3 = [CCMoveTo actionWithDuration: 1 position: CGPointMake(400, 150)];
			
			actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(addPhysicBodies)];
			
			[egg1 runAction:[CCSequence actions: action1, actionCallFunc, nil]];
			[egg2 runAction:[CCSequence actions: action2, nil]];
			[egg3 runAction:[CCSequence actions: action3, nil]];
			break;
		default:
			return;
	}
}

-(void) addPhysicBodies{
	switch(level){
		case 3:
			[egg10 createBox2dObject:world];
			[egg11 createBox2dObject:world];
			[egg12 createBox2dObject:world];
			[egg13 createBox2dObject:world];
			[egg14 createBox2dObject:world];
			[egg15 createBox2dObject:world];
		case 2:
			[egg4 createBox2dObject:world];
			[egg5 createBox2dObject:world];
			[egg6 createBox2dObject:world];
			[egg7 createBox2dObject:world];
			[egg8 createBox2dObject:world];
			[egg9 createBox2dObject:world];
		case 1:
			[egg1 createBox2dObject:world];
			[egg2 createBox2dObject:world];
			[egg3 createBox2dObject:world];
			break;
		default:
			return;
	}
}

-(void) birdCooAnimate{
	animB = [CCAnimation animation];
	[animB addFrameWithFilename:@"BirdCoo2.png"];
	birdCooAnim = [CCAnimate actionWithDuration:1.0f animation:animB restoreOriginalFrame:YES];
	[engine playEffect:@"sfx_happy_ding.wav"];
	[birdCoo runAction:birdCooAnim];
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
}

-(void)goMainMenu{
	[self resumeGame];
	[engine stopBackgroundMusic];
	[SceneManager goStartScreen];
}

-(void)goNextLevel{
	[engine stopBackgroundMusic];
	[SceneManager goScoreScreen];
}

-(void)pauseGame{
	
	if(!paused){
		paused = YES;
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		box = [CCSprite spriteWithFile:@"rectangle.png"];
		box.position = ccp(screenSize.width/2, screenSize.height/2);
		[self addChild:box z:7];

		CCMenuItem *menuItem1 = [CCMenuItemImage itemFromNormalImage:@"resume.png"
		selectedImage: @"resume.png"
		target:self
		selector:@selector(resumeGame)];
		menuItem1.position = ccp(screenSize.width/2, screenSize.height/2+50);

		CCMenuItem *menuItem2 = [CCMenuItemImage itemFromNormalImage:@"mainmenu.png"
		selectedImage: @"mainmenu.png"
		target:self
		selector:@selector(goMainMenu)];
		menuItem2.position = ccp(screenSize.width/2, screenSize.height/2-35);

		// Create a menu and add your menu items to it
		myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
		[myMenu setPosition:ccp(0, 0)];
		// add the menu to your scene
		[self addChild:myMenu z:8];
		
		[[CCDirector sharedDirector] pause];
	}else{
		return;
	}
}

-(void)resumeGame{
	[self removeChild:box cleanup:YES];
	[self removeChild:myMenu cleanup:YES];
	
	paused = NO;
	[[CCDirector sharedDirector] resume];
}

-(void)tick: (ccTime) dt
{
	if((eggCount == 0) && (!loaded)){
		loaded = YES;
		
		NSString *scoreString = [NSString stringWithFormat:@"Username: %@, Level: %d, Stage: %d, Time: %d, Moves Taken: %d, Score: %d.",
								 [SceneManager sharedSceneManager].playerName,
								 level, 
								 stage, 
								 ((eggNumber*ALLOTED_TIME)-[SceneManager sharedSceneManager].levelScore),
								 [SceneManager sharedSceneManager].moveCount,
								 [SceneManager sharedSceneManager].levelScore];
		
		if([[SceneManager sharedSceneManager].scoreArray count]<21){
			[[SceneManager sharedSceneManager].scoreArray addObject:scoreString];
		}else{
			[[SceneManager sharedSceneManager].scoreArray removeObjectAtIndex:0];
			[[SceneManager sharedSceneManager].scoreArray addObject:scoreString];
		}
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		[defaults setObject:[SceneManager sharedSceneManager].scoreArray forKey:@"scoreArray"];
		[defaults synchronize];
		
		//NSLog(@"%@", scoreString);
		//NSLog(@"Data saved");
		
		[self goNextLevel];
	}
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	angle+=10;
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
		//Synchronize the AtlasSprites position and rotation with the corresponding body
		
			EggObject *myActor = (EggObject*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			
			if(stage == 3){
				if(myActor.spinnable){
					myActor.rotation = angle;
					b->SetTransform(b->GetPosition(), angle);
				}
			}
			
			if(worldGravity){
				[self turnOnGravity:b];
				gravityTurnedOnBefore = YES;
			}else if(gravityTurnedOnBefore){
				[self turnOffGravity:b];
			}
		
		}
	}
}

-(void)turnOffGravity:(b2Body *)b{
	b2Vec2 force;
	force.Set(0.0f, 20.0f);
	b2Vec2 p = b->GetLocalCenter();
	b->ApplyForce(b->GetMass()*force, p);
}

-(void)turnOnGravity:(b2Body *)b{
	b2Vec2 force;
	force.Set(0.0f, -20.0f);
	b2Vec2 p = b->GetLocalCenter();
	b->ApplyForce(b->GetMass()*force, p);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* myTouch = [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	location = [self convertToNodeSpace:location];
	
	b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, 
                                  location.y/PTM_RATIO);
	if (mouseJoint != NULL)
	{
		return;
	}
	
	b2AABB aabb;
	b2Vec2 d = b2Vec2(0.001f, 0.001f);
	aabb.lowerBound = locationWorld - d;
	aabb.upperBound = locationWorld + d;
	
	// Query the world for overlapping shapes.
	QueryCallback callback(locationWorld);
	world->QueryAABB(&callback, aabb);
	
	if (callback.m_fixture)
	{
		
		b2BodyDef bodyDef;
		groundBody = world->CreateBody(&bodyDef);
		
		b2Body* bodyz = callback.m_fixture->GetBody();
		bodyz->SetAwake(true);
		currentEgg = (EggObject*)bodyz->GetUserData();
		currentEgg.spinnable = NO;
		
		b2MouseJointDef md;
		md.bodyA = groundBody;
		md.bodyB = bodyz;
		md.target = locationWorld;
		md.maxForce = 1000.0f * bodyz->GetMass();
		
		mouseJoint = (b2MouseJoint*)world->CreateJoint(&md);
	}
}

- (void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch* myTouch = [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	location = [self convertToNodeSpace:location];
	
	b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, 
                                  location.y/PTM_RATIO);
	
	if (mouseJoint)
	{
		mouseJoint->SetTarget(locationWorld);
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self ccTouchesCancelled:touches withEvent:event];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (mouseJoint)
	{
		[SceneManager sharedSceneManager].moveCount++;
		world->DestroyJoint(mouseJoint);
		mouseJoint = NULL;
		
		if((currentEgg.body->GetPosition().x*PTM_RATIO) > currentEgg.final.x-20 && 
		   (currentEgg.body->GetPosition().x*PTM_RATIO) < currentEgg.final.x+20 && 
		   (currentEgg.body->GetPosition().y*PTM_RATIO) > currentEgg.final.y-20 &&
		   (currentEgg.body->GetPosition().y*PTM_RATIO) < currentEgg.final.y+20){
			
			currentEgg.position = currentEgg.final;
			currentEgg.rotation = 0;
			world->DestroyBody(currentEgg.body);
			eggCount--;
			[self resetTime];
			[self birdCooAnimate];
		}else{
			[engine playEffect:@"sfx_sad_ding.wav"];
			currentEgg.spinnable = YES;
		}
	}
}

-(void)updateTime:(ccTime)dt{
	
	if(eggCount!=0){
		totalTime += dt;
		currentTime = (int)totalTime;
		if (myTime > 0)
		{
			myTime = ALLOTED_TIME-((currentTime-oldTime)%(ALLOTED_TIME+1));
			[timeLabel setString:[NSString stringWithFormat:@"%i", myTime]];
		}else if(myTime == 0){
			oldTime = currentTime;
		}
	}
}

-(void)resetTime{
	[SceneManager sharedSceneManager].levelScore += myTime;
	myTime = ALLOTED_TIME;
	oldTime = currentTime;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	groundBody = NULL;
	
	delete m_debugDraw;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
