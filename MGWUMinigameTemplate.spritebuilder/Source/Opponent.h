//
//  Opponent.h
//  MGWUMinigameTemplate
//
//  Created by Kevin Mann on 8/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Opponent : CCNode

-(void)jump;

-(void)duck;

-(void)punch;

-(void)kick;

-(NSDictionary *)getStatus;

@end
