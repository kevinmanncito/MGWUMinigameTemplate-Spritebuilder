//
//  Opponent.m
//  MGWUMinigameTemplate
//
//  Created by Kevin Mann on 8/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Opponent.h"

@implementation Opponent {
    float _duckTime;
    BOOL _isIdling;
    BOOL _isDucking;
}

-(id)init {
    self = [super init];
    if (self) {
        CCLOG(@"Opponent created");
        [self resetBools];
    }
    return self;
}

-(void)didLoadFromCCB {
}

-(void)onEnter {
    [super onEnter];
}

-(void)update:(CCTime)delta {
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
    
    if (!_isIdling) {
        CCLOG(@"Back to idling");
        [self resetBools];
        _isIdling = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"SideIdling"];
    }
    
}

-(void)resetBools {
    CCLOG(@"resetBools");
    _isIdling = NO;
    _isDucking = NO;
}

-(void)duck {
    CCLOG(@"ducking");
    if (_isIdling) {
        [self resetBools];
        _isDucking = YES;
        _duckTime = 0;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideDuck"];
        CCLOG(@"actually ducking");
    }
}

@end
