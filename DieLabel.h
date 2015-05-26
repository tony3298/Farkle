//
//  Die.h
//  Farkle
//
//  Created by Tony Dakhoul on 5/21/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DieLabel;

@protocol DieDelegate <NSObject>

//-(void)customView:(id)view didTapButton:(UIButton *)button;

-(void)dieLabel:(DieLabel *)die;

@end

@interface DieLabel : UILabel

@property (nonatomic, assign) id <DieDelegate> delegate;

@property BOOL selected;

@property CGPoint originalCenter;


-(void)rollDie;

@end
