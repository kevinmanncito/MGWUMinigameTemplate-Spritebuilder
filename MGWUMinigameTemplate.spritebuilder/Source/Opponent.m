//
//  Opponent.m
//  MGWUMinigameTemplate
//
//  Created by Kevin Mann on 7/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Opponent.h"

@implementation Opponent {
    float _velYPrev; // this tracks the previous velocity, it's used for animation
    float _punchTime; // this tracks how long a punch has been punching
    float _kickTime; // how long a kick has been kicking
    float _blockTime;
    BOOL _isIdling; // these BOOLs track what animations have been triggered.  By default, they're set to NO
    BOOL _isJumping;
    BOOL _isFalling;
    BOOL _isLanding;
    BOOL _isPunching;
    BOOL _isKicking;
    BOOL _isBlocking;
}

-(id)init {
    self = [super init];
    if (self) {
        CCLOG(@"Opponent created");
        [self resetBools];
        _isIdling = YES;
    }
    return self;
}

-(void)didLoadFromCCB {
    // Set up anything connected to Sprite Builder here
}

-(void)update:(CCTime)delta {
    // Called each update cycle
    // n.b. Lag and other factors may cause it to be called more or less frequently on different devices or sessions
    // delta will tell you how much time has passed since the last cycle (in seconds)
    
    // This sample method is called every update to handle character animation
    [self updateAnimations:delta];
}

-(void)updateAnimations:(CCTime)delta {
    // PUNCH
    if (_isPunching) {
        _punchTime += delta;
        if (_punchTime > 0.5) {
            _punchTime = 0;
            [self resetBools];
        }
    }
    // KICK
    if (_isKicking) {
        _kickTime += delta;
        if (_kickTime > 0.5) {
            _kickTime = 0;
            [self resetBools];
        }
    }
    // BLOCK
    if (_isBlocking) {
        _blockTime += delta;
        if (_blockTime > 0.5) {
            _blockTime = 0;
            [self resetBools];
            CCLOG(@"stopped blocking");
        }
    }
    
    // IDLE
    // The animation should be idle if the character was and is stationary
    // The character may only start idling if he or she was not already idling or falling
    if (!_isIdling && !_isFalling && !_isPunching && !_isKicking && !_isBlocking) {
        [self resetBools];
        _isIdling = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideIdling"];
        CCLOG(@"Should be side Idling now...");
    }
//    // JUMP
//    // The animation should be jumping if the character wasn't moving up, but now is
//    // The character may only start jumping if he or she was idling and isn't jumping
//    else if (_velYPrev == 0 && self.physicsBody.velocity.y > 0 && _isIdling && !_isJumping && !_isPunching && !_isKicking) {
//        [self resetBools];
//        _isJumping = YES;
//        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideJump"];
//    }
//    // FALLING
//    // The animation should be falling if the character's moving down, but was moving up or stalled
//    // The character may only start falling if he or she was jumping and isn't falling
//    else if (_velYPrev >= 0 && self.physicsBody.velocity.y < 0 && _isJumping && !_isFalling && !_isPunching && !_isKicking) {
//        [self resetBools];
//        _isFalling = YES;
//        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideFalling" tweenDuration:0.5f];
//    }
//    // LANDING
//    // The animation sholud be landing if the character's stopped moving down (hit something)
//    // The character may only start landing if he or she was falling and isn't landing
//    else if (_velYPrev < 0 && self.physicsBody.velocity.y >= 0 && _isFalling && !_isLanding && !_isPunching && !_isKicking) {
//        [self resetBools];
//        _isLanding = YES;
//        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideLand"];
//    }
    
    // We track the previous velocity, since it's important to determining how the character is and was moving for animations
    _velYPrev = self.physicsBody.velocity.y;
    
}

// This method is called before setting one to YES, so that only one is ever YES at a time
-(void)resetBools {
    _isIdling = NO;
    _isJumping = NO;
    _isFalling = NO;
    _isLanding = NO;
    _isPunching = NO;
    _isKicking = NO;
    _isBlocking = NO;
}


-(void)block {
    CCLOG(@"%d", _isIdling);
    if (_isIdling) {
        CCLOG(@"is idling");
        [self resetBools];
        _isBlocking = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimEnterSideBlock"];
    }
}

@end
