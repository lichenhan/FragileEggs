// GameObject.m

#import "GameObject.h"

@implementation GameObject

@synthesize type;

- (id)init
{
    self = [super init];
    if (self) {
        type = kGameObjectNone;
    }
	
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end