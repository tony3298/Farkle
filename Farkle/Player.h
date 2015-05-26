//
//  Player.h
//  Farkle
//
//  Created by Tony Dakhoul on 5/26/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property NSString *name;
@property NSInteger score;

-(instancetype)initPlayerWithName:(NSString *)name;

@end
