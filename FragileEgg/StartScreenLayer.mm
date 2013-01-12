//
//  StartScreenLayer.m
//  FragileEggs
//
//  Created by socialapp on 5/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StartScreenLayer.h"
#import "QueryCallback.h"

#define PTM_RATIO 32

@implementation StartScreenLayer

@synthesize myTextField;

CGSize screenSize;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StartScreenLayer *layer = [StartScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	
	return scene;
}

-(id) init {
	
	self = [super init];
	if (self != nil){
		
		if(([SceneManager sharedSceneManager].playerName)){
			entered = [SceneManager sharedSceneManager].playerName;
		}else{
			entered = @"New Player";
			[SceneManager sharedSceneManager].playerName = @"New Player";
		}
		
		final = CGPointMake(651, 403);
		
		screenSize.width = 1024;
        screenSize.height = 768;
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -20.0f);
		
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
		groundBodyDef.position.Set(0, 8); // bottom-left corner
		
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
		
		backgroundImage = [CCSprite spriteWithFile:@"startscreen.png"];		
		
		[backgroundImage setPosition: CGPointMake(screenSize.width/2, screenSize.height/2)];
		
		[self addChild:backgroundImage z:0];
		
		[self addStartEgg:CGPointMake(screenSize.width/4, screenSize.height/2)];
		
		instr = [CCLabelTTF labelWithString:@"Drag the Egg into the Nest!" 
								 dimensions:CGSizeMake(260, 120) alignment:UITextAlignmentCenter
								   fontName:@"Helvetica" fontSize:42];
		[instr setPosition:ccp(screenSize.width/(1.3), screenSize.height/(1.2))];
		instr.color = ccc3(0, 0, 0);
		[self addChild:instr z:3];
		
		name = [CCLabelTTF labelWithString:entered
								   fontName:@"Helvetica" fontSize:32];
		[name setPosition:ccp(screenSize.width/2+150.0, 225.0)];
		name.color = ccc3(0, 0, 0);
		[self addChild:name z:3];
		
		menuItem1 = [CCMenuItemImage itemFromNormalImage:@"StartNameInput.png"
															 selectedImage: @"StartNameInput.png"
																	target:self
																  selector:@selector(generateAlert)];
		// Create a menu and add your menu items to it
		myMenu = [CCMenu menuWithItems:menuItem1, nil];
		[myMenu setPosition:ccp(screenSize.width/2+150.0, 225.0)];
		// add the menu to your scene
		[self addChild:myMenu z:0];
		
		highScoreButton = [CCMenuItemImage itemFromNormalImage:@"highscores.png"
															 selectedImage: @"highscores.png"
																	target:self
																  selector:@selector(showHighScores)];
		highScoreButton.position = ccp(screenSize.width/2, 75);
		highScoreMenu = [CCMenu menuWithItems:highScoreButton, nil];
		[highScoreMenu setPosition:CGPointZero];
		[self addChild:highScoreMenu z:3];
		
		
		self.isTouchEnabled = YES;
		
		startBirdCoo = [CCSprite spriteWithFile:@"startbirdcoo1.png"];
		startBirdCoo.position = ccp(854, 440);
		[self addChild:startBirdCoo z:1];
		
		engine = [SimpleAudioEngine sharedEngine];
		
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void)showHighScores{
	[SceneManager goHighScoresScreen];
}

-(void)generateAlert{
	UIView* view = [[CCDirector sharedDirector] openGLView];
	
	UIAlertView* myAlertView = [[UIAlertView alloc] initWithTitle: @"Your Name Here!" message: @"\n\n" delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"OK", nil];
	[view addSubview: myAlertView];
	
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 0.0);
	[myAlertView setTransform: myTransform];
	
	myTextField = [[UITextField alloc] initWithFrame: CGRectMake(12.0, 45.0, 260.0, 25.0)];
	[myTextField setBackgroundColor: [UIColor whiteColor]];
	[myAlertView addSubview: myTextField];
	[myAlertView show];
	[myAlertView release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		if([myTextField.text length] != 0){
			entered = myTextField.text;
			[[SceneManager sharedSceneManager] setPlayerName:(myTextField.text)];
			[name setString:entered];
		}else{
			[[SceneManager sharedSceneManager] setPlayerName:@"New Player"];
		}
	}
}

-(void) addStartEgg:(CGPoint)p
{	
	startEgg = [CCSprite spriteWithFile:@"startegg.png"];
	startEgg.position = ccp(p.x, p.y);
	[self addChild:startEgg z:5];
	
	// Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.angle = 0;
	bodyDef.fixedRotation = true;
	
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = startEgg;
	startEggBody = world->CreateBody(&bodyDef);
	
	// Define a box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(([startEgg boundingBox].size.width/PTM_RATIO)/2, ([startEgg boundingBox].size.height/PTM_RATIO)/2);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution = 0.1f;
	startEggFixture = startEggBody->CreateFixture(&fixtureDef);
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

-(void) tick: (ccTime) dt
{
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
    if (_mouseJoint != NULL){
		return;
	}
	
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);

    if (startEggFixture->TestPoint(locationWorld)) {
        b2MouseJointDef md;
        md.bodyA = groundBody;
        md.bodyB = startEggBody;
        md.target = locationWorld;
        md.collideConnected = true;
        md.maxForce = 1000.0f * startEggBody->GetMass();
		
        _mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
        startEggBody->SetAwake(true);
    }
	
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
    if (_mouseJoint == NULL){
		return;
	}
	
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
	
    _mouseJoint->SetTarget(locationWorld);
	
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
    if (_mouseJoint) {
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
	
		if((startEggBody->GetPosition().x*PTM_RATIO) > final.x-30 && 
		   (startEggBody->GetPosition().x*PTM_RATIO) < final.x+30 && 
		   (startEggBody->GetPosition().y*PTM_RATIO) > final.y-30 &&
		   (startEggBody->GetPosition().y*PTM_RATIO) < final.y+30){
			
			startEgg.position = final;
			startEgg.rotation = 0;
			world->DestroyBody(startEggBody);
			
			[self save];
			CCAnimation *anim = [CCAnimation animation];
			[anim addFrameWithFilename:@"startbirdcoo2.png"];
			CCAnimate *birdCooAnim = [CCAnimate actionWithDuration:1.0f animation:anim restoreOriginalFrame:YES];
			[engine playEffect:@"sfx_happy_ding.wav"];
			[startBirdCoo runAction:[CCSequence actions:                          
								birdCooAnim,[CCCallFunc actionWithTarget:self selector:@selector(birdCooEnded)],nil]];
		}else{
			[engine playEffect:@"sfx_sad_ding.wav"];
		}
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self ccTouchesCancelled:touches withEvent:event];  
}

-(void)birdCooEnded{
	[SceneManager goLevelScreen];
}

-(void)save{
	if([myTextField.text length]!=0){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		[defaults setObject:myTextField.text forKey:@"name"];
		[defaults synchronize];
		
		//NSLog(@"Data saved");
	}
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
