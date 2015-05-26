//
//  ViewController.m
//  Farkle
//
//  Created by Tony Dakhoul on 5/21/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import "ViewController.h"
#import "DieLabel.h"
#import "Player.h"

@interface ViewController () <DieDelegate>

@property (strong, nonatomic) IBOutletCollection(DieLabel) NSArray *dice;

@property UIDynamicAnimator *dynamicAnimator;

@property NSMutableArray *selectedDice;
@property NSMutableArray *scoreDice;

@property (weak, nonatomic) IBOutlet UIButton *rollButton;
@property (weak, nonatomic) IBOutlet UIButton *bankButton;

@property (weak, nonatomic) IBOutlet UILabel *userScore;
@property (weak, nonatomic) IBOutlet UILabel *diceRoller;

@property Player *currentPlayer;

@property NSInteger playerScore;
@property NSInteger displayScore;
@property NSInteger turnScore;

@property BOOL validDice;
@property BOOL scoredThisRoll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentPlayer = [self.selectedPlayers firstObject];

    [[self navigationItem] setTitle:self.currentPlayer.name];
    self.playerScore = self.currentPlayer.score;

    self.selectedDice = [NSMutableArray new];
    self.scoreDice = [NSMutableArray new];
    self.playerScore = 0;
    self.turnScore = 0;
    self.validDice = NO;
    self.scoredThisRoll = NO;

    self.bankButton.enabled = NO;

    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    for (DieLabel *die in self.dice) {
        die.delegate = self;
        die.userInteractionEnabled = NO;
    }

}

-(void)viewDidAppear:(BOOL)animated {

    for (DieLabel *die in self.dice) {
        die.originalCenter = die.center;
//        die.center = self.diceRoller.center;
    }
}

-(void)collectDice {

    self.rollButton.enabled = NO;

//    self.playerScore += self.turnScore;
    self.scoredThisRoll = NO;

    if (self.scoreDice.count > 0) {

        [self.scoreDice removeAllObjects];
    }

    for (DieLabel *die in self.dice) {

        if (!die.selected) {

            die.userInteractionEnabled = YES;

            [UIView animateWithDuration:0.5 animations:^{

                die.center = self.diceRoller.center;
            } completion:^(BOOL finished) {

                if(![self.selectedDice containsObject:die]) {

                    [die rollDie];
                }
            }];
        } else {

            die.userInteractionEnabled = NO;
        }
    }
}

-(void)animateRoll {

    NSLog(@"start roll animation");

    if (self.dynamicAnimator.behaviors.count != 0) {

        [self.dynamicAnimator removeAllBehaviors];
    }

    CGPoint point;
    UISnapBehavior *snapBehavior;

    for (DieLabel *die in self.dice) {

        point = CGPointMake(die.originalCenter.x, die.originalCenter.y);
        snapBehavior = [[UISnapBehavior alloc] initWithItem:die snapToPoint:point];
        [self.dynamicAnimator addBehavior:snapBehavior];
    }
}


-(IBAction)onRollButtonPressed:(id)sender {

    [self collectDice];

    self.displayScore += self.turnScore;

    [self performSelector:@selector(animateRoll) withObject:nil afterDelay:0.5];
}

- (IBAction)onBankButtonPressed:(UIButton *)sender {

    self.currentPlayer.score = self.displayScore;

    [self nextPlayer];
}

-(void)dieLabel:(id)die {

    DieLabel *dieLabel = die;

    if ([self.selectedDice containsObject:die]) {

        [self.selectedDice removeObject:die];
        [self.scoreDice removeObject:die];
        dieLabel.backgroundColor = [UIColor blackColor];
        dieLabel.selected = NO;

        [self checkScore];

        if (self.selectedDice.count == 0) {
            self.rollButton.enabled = NO;
            self.validDice = NO;
        }

    } else {

        [self.selectedDice addObject:die];
        [self.scoreDice addObject:die];

        dieLabel.backgroundColor = [UIColor redColor];
        dieLabel.selected = YES;

        [self checkScore];
    }

    NSLog(@"validDice: %d", self.validDice);
    NSLog(@"scoredThisTurn: %d", self.scoredThisRoll);

    if (self.selectedDice.count == 6) {

        if (self.scoredThisRoll && !self.validDice) {
            //next player's turn
            NSLog(@"You scored this turn and can roll");

        } else if (!self.scoredThisRoll) {

            [self nextPlayer];

            NSLog(@"Farkle: Next player's turn");

        } else {
            //player can go again

            NSLog(@"Go again");

            for (DieLabel *die in self.dice) {

                [UIView animateWithDuration:0.5 animations:^{

                    die.center = self.diceRoller.center;
                } completion:^(BOOL finished) {

                    die.selected = NO;
                    die.backgroundColor = [UIColor blackColor];
                    die.userInteractionEnabled = YES;

                    [die rollDie];
                }];
            }

            self.displayScore += self.turnScore;

            [self.selectedDice removeAllObjects];
            [self.scoreDice removeAllObjects];
            self.scoredThisRoll = NO;
            self.validDice = NO;
            self.rollButton.enabled = NO;

            [self performSelector:@selector(animateRoll) withObject:nil afterDelay:0.5];
        }

    } else {

        if (self.scoredThisRoll && self.validDice) {

            self.rollButton.enabled = YES;
        } else {
            
            self.rollButton.enabled = NO;
        }
    }
}

-(void)nextPlayer {

}

-(void)checkScore {

    NSInteger howManyOnes = 0;
    NSInteger howManyTwos = 0;
    NSInteger howManyThrees = 0;
    NSInteger howManyFours = 0;
    NSInteger howManyFives = 0;
    NSInteger howManySixes = 0;

    NSInteger score = 0;
//    NSString *diceValues;

    for (DieLabel *die in self.scoreDice) {

        if (die.tag == 1) {

            NSLog(@"1");

            howManyOnes++;
        } else if (die.tag == 2) {

            NSLog(@"2");

            howManyTwos++;
        } else if (die.tag == 3) {
            NSLog(@"3");
            howManyThrees++;
        } else if (die.tag == 4) {
            NSLog(@"4");
            howManyFours++;
        } else if (die.tag == 5) {
            NSLog(@"5");
            howManyFives++;
        } else {
            NSLog(@"6");
            howManySixes++;
        }
    }

    score += [self checkOnes:howManyOnes];
    score += [self checkFives:howManyFives];
    score += [self checkTwos:howManyTwos];
    score += [self checkThrees:howManyThrees];
    score += [self checkFours:howManyFours];
    score += [self checkSixes:howManySixes];

    self.turnScore = score;

    NSInteger displayScore = self.displayScore + self.turnScore;

    self.userScore.text = [NSString stringWithFormat:@"%li", (long)displayScore];

    if (displayScore >= 500) {
        self.bankButton.enabled = YES;
    }

    if (score != 0) {
        self.scoredThisRoll = YES;
    } else {
        self.scoredThisRoll = NO;
    }

    if (howManyTwos % 3 != 0 || howManyThrees %3 != 0 || howManyFours %3 != 0 || howManySixes %3 != 0) {
        self.validDice = NO;
    } else {
        self.validDice = YES;
    }
}

-(NSInteger)checkOnes:(NSInteger)howManyOnes {

    NSInteger score = 0;

    self.validDice = YES;

    if (howManyOnes %3 == 0) {

        if (howManyOnes == 3) {
            score = 1000;
        }

        if (howManyOnes == 6) {
            score = 2000;
        }
    } else if (howManyOnes - 3 > 0){

        if (howManyOnes == 4) {
            score = 1100;
        } else {
            score = 1200;
        }
    } else {

        if (howManyOnes == 1) {
            score = 100;
        } else {
            score = 200;
        }
    }

    return score;
}

-(NSInteger)checkTwos:(NSInteger)howManyTwos {

    NSInteger score = 0;

    if (howManyTwos > 0) {

        if (howManyTwos >= 3 && howManyTwos < 6) {
            score = 200;
        }

        if (howManyTwos == 6) {
            score = 400;
        }
    }

    return score;
}

-(NSInteger)checkThrees:(NSInteger)howManyThrees {

    NSInteger score = 0;

    if (howManyThrees > 0) {

        if (howManyThrees >= 3 && howManyThrees < 6) {
            score = 300;
        }

        if (howManyThrees == 6) {
            score = 600;
        }
    }

    return score;
}

-(NSInteger)checkFours:(NSInteger)howManyFours {

    NSInteger score = 0;

    if (howManyFours > 0) {

        if (howManyFours == 3 && howManyFours < 6) {
            score = 400;
        }

        if (howManyFours == 6) {
            score = 800;
        }
    }

    return score;
}

-(NSInteger)checkFives:(NSInteger)howManyFives {

    NSInteger score = 0;

    self.validDice = YES;

    if (howManyFives %3 == 0) {

        if (howManyFives == 3) {
            score = 500;
        }

        if (howManyFives == 6) {
            score = 1000;
        }
    } else if (howManyFives - 3 > 0){

        if (howManyFives == 4) {
            score = 550;
        } else {
            score = 600;
        }
    } else {

        if (howManyFives == 1) {
            score = 50;
        } else {
            score = 100;
        }
    }

    return score;
}

-(NSInteger)checkSixes:(NSInteger)howManySixes {

    NSInteger score = 0;

    if (howManySixes > 0) {

        if (howManySixes >= 3 && howManySixes < 6) {
            score = 600;
        }

        if (howManySixes == 6) {
            score = 1200;
        }
    }

    return score;
}

-(NSInteger)bankScore {



    return 0;
}

@end