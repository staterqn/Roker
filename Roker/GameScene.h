//
//  GameScene.h
//  Roker
//

//  Copyright (c) 2015年 chuanshaungzhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


struct CGLocation {
    CGFloat x;
    CGFloat y;
};
typedef struct CGLocation CGLocation;

CG_INLINE CGLocation

CGLocationMake(NSInteger x, NSInteger y)
{
    CGLocation location;
    location.x = x;
    location.y = y;
    return location;
}



@interface GameScene : SKScene

@end
