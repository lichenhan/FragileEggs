// GameObject.h

#import "cocos2d.h"
#import "Constants.h"

@interface GameObject : CCSprite {
    GameObjectType type;
}

@property (nonatomic, readwrite) GameObjectType type;

@end