//
//  Player.m
//  Farkle
//
//  Created by Tony Dakhoul on 5/26/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import "Player.h"

@implementation Player

-(instancetype)initPlayerWithName:(NSString *)name {

    self = [super init];

    if (self){

        self.name = name;
        self.score = 0;
    }

    return self;
}

@end
