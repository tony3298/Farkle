//
//  Die.m
//  Farkle
//
//  Created by Tony Dakhoul on 5/21/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import "DieLabel.h"

@implementation DieLabel

- (id) initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onDieTapped)];
//    gestureRecognizer.numberOfTapsRequired = 1;
//    gestureRecognizer.numberOfTouchesRequired = 1;

    [self addGestureRecognizer:gestureRecognizer];
    self.userInteractionEnabled = YES;

    self.selected = NO;

    return self;
    
}

-(void)onDieTapped {

//    NSLog(@"Tap");
    [self.delegate dieLabel:self];

}

-(void)rollDie {

    NSInteger number = (arc4random() % 6) + 1;

    self.text = [NSString stringWithFormat:@"%li", number];
    self.tag = number;

}
@end
