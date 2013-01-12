//
//  EggObject.h
//  FragileEggs
//
//  Created by socialapp on 5/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GameObject.h"

@interface EggObject: GameObject {
	b2Body *body;
	b2Fixture *fixture;
	BOOL touchable;
	BOOL spinnable;
	CGPoint final;
}

@property (nonatomic, readwrite) b2Body *body;
@property (nonatomic, readwrite) b2Fixture *fixture;
@property CGPoint final;
@property BOOL touchable;
@property BOOL spinnable;

-(void) createBox2dObject:(b2World*)world;

@end
