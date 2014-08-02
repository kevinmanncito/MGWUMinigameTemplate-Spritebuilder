//
//  Opponent.m
//  MGWUMinigameTemplate
//
//  Created by Kevin Mann on 8/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Opponent.h"

@implementation Opponent {
    float _velYPrev; // this tracks the previous velocity, it's used for animation
    float _duckTime;
    float _punchTime;
    float _kickTime;
    BOOL _isIdling; // these BOOLs track what animations have been triggered.  By default, they're set to NO
    BOOL _isJumping;
    BOOL _isFalling;
    BOOL _isLanding;
    BOOL _isDucking;
    BOOL _isPunching;
    BOOL _isKicking;
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

-(void)onEnter {
    [super onEnter];
    // Create anything you'd like to draw here
}

-(void)update:(CCTime)delta {
    // Called each update cycle
    // n.b. Lag and other factors may cause it to be called more or less frequently on different devices or sessions
    // delta will tell you how much time has passed since the last cycle (in seconds)
    
    // This sample method is called every update to handle character animation
    [self updateAnimations:delta];
}

-(void)updateAnimations:(CCTime)delta {
    
    if (_isDucking) {
        _duckTime += delta;
        CCLOG(@"duck time: %f", _duckTime);
        if (_duckTime > 0.90) {
            [self resetBools];
        }
    }
    
    if (_isPunching) {
        _punchTime += delta;
        if (_punchTime > 0.90) {
            [self resetBools];
        }
    }
    
    if (_isKicking) {
        _kickTime += delta;
        if (_kickTime > 0.90) {
            [self resetBools];
        }
    }
    
    // IDLE
    // The animation should be idle if the character was and is stationary
    // The character may only start idling if he or she was not already idling or falling or ducking
    if (!_isIdling && !_isFalling && !_isDucking && !_isPunching && !_isKicking && !_isJumping && !_isLanding) {
        CCLOG(@"Back to idling");
        [self resetBools];
        _isIdling = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideIdling"];
    }
//    // JUMP
//    // The animation should be jumping if the character wasn't moving up, but now is
//    // The character may only start jumping if he or she was idling and isn't jumping
//    else if (_velYPrev == 0 && self.physicsBody.velocity.y > 0 && _isIdling && !_isJumping) {
//        [self resetBools];
//        _isJumping = YES;
//        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideJump"];
//    }
//    // FALLING
//    // The animation should be falling if the character's moving down, but was moving up or stalled
//    // The character may only start falling if he or she was jumping and isn't falling
//    else if (_velYPrev >= 0 && self.physicsBody.velocity.y < 0 && _isJumping && !_isFalling) {
//        [self resetBools];
//        _isFalling = YES;
//        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideFalling" tweenDuration:0.5f];
//    }
//    // LANDING
//    // The animation sholud be landing if the character's stopped moving down (hit something)
//    // The character may only start landing if he or she was falling and isn't landing
//    else if (_velYPrev < 0 && self.physicsBody.velocity.y >= 0 && _isFalling && !_isLanding) {
//        [self resetBools];
//        _isLanding = YES;
//        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideLand"];
//    }
//    
//    // We track the previous velocity, since it's important to determining how the character is and was moving for animations
//    _velYPrev = self.physicsBody.velocity.y;
    
}

// This method is called before setting one to YES, so that only one is ever YES at a time
-(void)resetBools {
    _isIdling = NO;
    _isJumping = NO;
    _isFalling = NO;
    _isLanding = NO;
    _isDucking = NO;
    _isPunching = NO;
    _isKicking = NO;
}

// This method tells the character to jump by giving it an upward velocity.
// It's been added to a physics node in the main scene, like the penguins Peeved Penguins, so it will fall automatically!
-(void)jump {
    self.physicsBody.velocity = ccp(0,122);
}

-(void)duck {
    CCLOG(@"ducking");
    if (_isIdling) {
        CCLOG(@"actually ducking");
        [self resetBools];
        _isDucking = YES;
        _duckTime = 0;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideDuck"];
    }
}

-(void)print_duck_status {
    CCLOG(@"_isDucking: %d", _isDucking);
}

-(void)punch {
    if (_isIdling) {
        [self resetBools];
        _isPunching = YES;
        _punchTime = 0;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSidePunch"];
    }
}

-(void)kick {
    if (_isIdling) {
        [self resetBools];
        _isKicking = YES;
        _kickTime = 0;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideKick"];
    }
}

-(NSDictionary *)getStatus {
    
    if (_isKicking) {
        NSDictionary *status = @{
                                 @"status": @"kicking",
                                 @"time": [NSNumber numberWithFloat:_kickTime]
                                 };
        return status;
    } else if (_isPunching) {
        NSDictionary *status = @{
                                 @"status": @"punching",
                                 @"time": [NSNumber numberWithFloat:_punchTime]
                                 };
        return status;
    } else if (_isDucking) {
        NSDictionary *status = @{
                                 @"status": @"ducking",
                                 @"time": [NSNumber numberWithFloat:_duckTime]
                                 };
        return status;
    } else if (_isIdling || _isLanding) {
        NSDictionary *status = @{
                                 @"status": @"idling",
                                 @"time": @0
                                 };
        return status;
    } else {
        NSDictionary *status = @{
                                 @"status": @"jumping",
                                 @"time": @0
                                 };
        return status;
    }
}

@end
