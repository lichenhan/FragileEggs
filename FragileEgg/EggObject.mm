//
//  EggObject.m
//  FragileEggs
//
//  Created by socialapp on 5/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EggObject.h"
#import "Constants.h"

@implementation EggObject

@synthesize body;
@synthesize fixture;
@synthesize final;
@synthesize touchable, spinnable;

- (id) init {
	if ((self = [super init])) {
		self.type = kGameObjectEgg;
	}
	return self;
}

-(void) createBox2dObject:(b2World*)world {
	
    // Define the dynamic body.
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.angle = 0;
	bodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
	bodyDef.userData = self;
	bodyDef.fixedRotation = true;
	
	body = world->CreateBody(&bodyDef);
	
	// Define a box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(([self boundingBox].size.width/PTM_RATIO)/2.5, ([self boundingBox].size.height/PTM_RATIO)/2.5);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution =  0.1f;
	
	fixture = body->CreateFixture(&fixtureDef);
}

@end