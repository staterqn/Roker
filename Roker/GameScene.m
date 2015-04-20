//
//  GameScene.m
//  Roker
//
//  Created by chuanshuangzhang chuan shuang on 15/4/7.
//  Copyright (c) 2015年 chuanshaungzhang. All rights reserved.
//

#import "GameScene.h"
#import "RKSpriteNode.h"

#define ScenePercenet 0.95

typedef NS_ENUM(NSInteger, MoveState) {
   MoveStateNone,
   MoveStateAviailable
};

@interface GameScene ()

@property (nonatomic,strong)     SKSpriteNode *RKRouteMapNode;
@property (nonatomic,readwrite)  CGFloat      routeStep;
@property (nonatomic,readwrite)  NSInteger    steps;
@property (nonatomic,readwrite)  CGLocation   currentLocation;
@property (nonatomic,readwrite)  CGPoint      startLocation;
@property (nonatomic,strong)     RKSpriteNode *selectNode;
@property (nonatomic,readwrite)  Direction    currentDirection;
@property (nonatomic,readwrite)  MoveState    moveState;
@property (nonatomic,readwrite)  NSInteger    movingSteps;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
     UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:pangesture];
    [self.view addGestureRecognizer:tapGesture];
    
    self.size = [UIScreen mainScreen].bounds.size;
    /* Setup your scene here */
    [self setUpRouteMap];
    [self setCubeLocationInMap:CGLocationMake(1, 1)];
    [self setCubeLocationInMap:CGLocationMake(1, 2)];
    [self setCubeLocationInMap:CGLocationMake(1, 3)];
    [self setCubeLocationInMap:CGLocationMake(2, 1)];
    [self setCubeLocationInMap:CGLocationMake(2, 2)];
    [self setCubeLocationInMap:CGLocationMake(4, 3)];
    [self setCubeLocationInMap:CGLocationMake(3, 5)];
    [self setCubeLocationInMap:CGLocationMake(3, 2)];
    [self setCubeLocationInMap:CGLocationMake(6, 3)];
}

-(void)setUpRouteMap
{
    CGFloat t = self.size.width*ScenePercenet;
    _steps = 6;
    _movingSteps = 0;
    _routeStep = t/_steps;
    _RKRouteMapNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Map"] size:CGSizeMake(t, t)];
    [_RKRouteMapNode setAnchorPoint:CGPointZero];
    [_RKRouteMapNode setPosition:CGPointMake(self.size.width*(1-ScenePercenet)/2.0, self.size.height/2.0-_RKRouteMapNode.size.height/2.0)];
    [self addChild:_RKRouteMapNode];
}
-(void)setCubeLocationInMap:(CGLocation)location
{
    RKSpriteNode *node = [RKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"test"] size:CGSizeMake(_routeStep*0.9, _routeStep*0.9)];
    [_RKRouteMapNode addChild:node];
    node.name = @"Cube";
    node.location = location;
    [node setPosition:CGPointMake((location.x-1)*_routeStep + _routeStep/2.0, (location.y-1)*_routeStep + _routeStep/2.0)];
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchLocation = [sender locationInView:sender.view];
        touchLocation = [self convertPointFromView:touchLocation];
        SKNode *node = [self nodeAtPoint:touchLocation];
        if([node.name isEqualToString:@"Cube"])
        {
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
            CGPoint velocity = [sender velocityInView:sender.view];
            _selectNode = (RKSpriteNode *)node;
            _moveState = MoveStateAviailable;
            _currentLocation = _selectNode.location;
            _currentDirection = [self directionWithVelocity:velocity];
            CGLocation location = _currentLocation;
            if(_currentDirection == DirectionVertical)
            {
                if(location.y + 1 > _steps || [self nodeAtLocationExisting:CGLocationMake(location.x, location.y+1)])
                {
                    _selectNode.maxMoveY = _selectNode.position.y;
                }
                else
                {
                    _selectNode.maxMoveY = [self convertLocationToPoint:CGLocationMake(location.x, location.y+1)].y;
                }
                if(location.y - 1 <= 0 || [self nodeAtLocationExisting:CGLocationMake(location.x, location.y-1)])
                {
                    _selectNode.minMoveY = _selectNode.position.y;
                }
                else
                {
                    _selectNode.minMoveY = [self convertLocationToPoint:CGLocationMake(location.x, location.y-1)].y;
                }
                
            }
            else if(_currentDirection == DirectionHorizontal)
            {
                if(location.x + 1 > _steps || [self nodeAtLocationExisting:CGLocationMake(location.x+1, location.y)])
                {
                    _selectNode.maxMoveX = _selectNode.position.x;
                }
                else
                {
                    _selectNode.maxMoveX = [self convertLocationToPoint:CGLocationMake(location.x + 1, location.y)].x;
                }
                if(location.x - 1 <= 0 || [self nodeAtLocationExisting:CGLocationMake(location.x-1, location.y)])
                {
                    _selectNode.minMoveX = _selectNode.position.x;
                }
                else
                {
                    _selectNode.minMoveX = [self convertLocationToPoint:CGLocationMake(location.x-1, location.y)].x;
                }
            }
        }
    }
    else if(sender.state == UIGestureRecognizerStateChanged)
    {
        if(_moveState == MoveStateAviailable)
        {
            CGPoint translation = [sender translationInView:sender.view];
            CGPoint postion = _selectNode.position;
            if(_currentDirection == DirectionHorizontal)
            {
                postion.x += translation.x;
                if(postion.x >= _selectNode.maxMoveX)
                {
                    postion.x = _selectNode.maxMoveX;
                }
                else if(postion.x  <= _selectNode.minMoveX)
                {
                    postion.x = _selectNode.minMoveX;
                }
                _selectNode.position = postion;
            }
            else if(_currentDirection == DirectionVertical)
            {
                postion.y -= translation.y;
                if(postion.y  >= _selectNode.maxMoveY)
                {
                    postion.y = _selectNode.maxMoveY;
                }
                else if(postion.y <= _selectNode.minMoveY)
                {
                    postion.y = _selectNode.minMoveY;
                }
                _selectNode.position = postion;
            }
        }
        [sender setTranslation:CGPointZero inView:sender.view];
    }
    else if(sender.state == UIGestureRecognizerStateEnded)
    {
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        if(_moveState == MoveStateAviailable){
            
            CGLocation location = [self convertPostionToLocation:_selectNode.position];
            _selectNode.position = [self convertLocationToPoint:location];
            if(_selectNode.location.x != location.x || _selectNode.location.y != location.y)
            {
                _movingSteps ++;
            }
            _selectNode.location = location;
        }
        _moveState = MoveStateNone;
    }
}
//convert node's postion to CGLocation
-(CGLocation)convertPostionToLocation:(CGPoint)postion
{
    CGLocation location = CGLocationMake(0, 0);
    location.x = (NSInteger)(postion.x/_routeStep + 1);
    location.y = (NSInteger)(postion.y/_routeStep + 1);
    return location;
}
//convert node's location to CGpoint
-(CGPoint)convertLocationToPoint:(CGLocation)location
{
    return CGPointMake((location.x-1)*_routeStep + _routeStep/2.0, (location.y-1)*_routeStep + _routeStep/2.0);
}
//Verfiy if node existing at specific location
-(BOOL)nodeAtLocationExisting:(CGLocation)location
{
    BOOL exsiting = NO;
  
    CGPoint point = [self convertLocationToPoint:location];
    SKNode *node = [_RKRouteMapNode nodeAtPoint:point];
    if([node.name isEqualToString:@"Cube"])
    {
        exsiting = YES;
    }
    
    return exsiting;
}
//verfiy move direction
-(Direction)directionWithVelocity:(CGPoint)velocity
{
    Direction direction = DirectionNone;
    if(fabs(velocity.x) > fabs(velocity.y))
    {
       direction = DirectionHorizontal;
    }
    else
    {
        direction = DirectionVertical;
    }
    return direction;
}
-(void)handleTapGesture:(UITapGestureRecognizer *)sender
{
  
}
@end
