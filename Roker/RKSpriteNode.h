//
//  RKSpriteNode.h
//  Roker
//
//  Created by chuanshuangzhang chuan shuang on 15/4/13.
//  Copyright (c) 2015年 chuanshaungzhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"


typedef NS_ENUM(NSInteger, Direction){
    
    DirectionNone,
    DirectionRight,
    DirectionLeft,
    DirectionUp,
    DirectionDown,
    DirectionHorizontal,
    DirectionVertical
};
@interface RKSpriteNode : SKSpriteNode

@property (nonatomic,readwrite)  CGLocation location;
@property (nonatomic,readwrite)  CGFloat     maxMoveX;
@property (nonatomic,readwrite)  CGFloat     maxMoveY;
@property (nonatomic,readwrite)  CGFloat     minMoveX;
@property (nonatomic,readwrite)  CGFloat     minMoveY;

@end
