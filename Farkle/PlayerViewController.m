//
//  PlayerViewController.m
//  Farkle
//
//  Created by Tony Dakhoul on 5/26/15.
//  Copyright (c) 2015 Tony Dakhoul. All rights reserved.
//

#import "PlayerViewController.h"
#import "Player.h"
#import "ViewController.h"

@interface PlayerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;

@property NSMutableArray *players;
@property NSMutableArray *selectedPlayers;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playButton.enabled = NO;

    Player *tony = [[Player alloc]initPlayerWithName:@"Tony"];
    Player *player2 = [[Player alloc]initPlayerWithName:@"Player 2"];

    self.players = [[NSMutableArray alloc]initWithObjects:tony, player2, nil];
    self.selectedPlayers = [NSMutableArray new];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.players.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    Player *player = self.players[indexPath.row];

    cell.textLabel.text = player.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Score: %li", player.score];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    Player *player = self.players[indexPath.row];

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {

        cell.accessoryType = UITableViewCellAccessoryNone;

        [self.selectedPlayers removeObject:player];
    } else {

        NSLog(@"Add player");

        [self.selectedPlayers addObject:player];

        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    NSLog(@"%li", self.selectedPlayers.count);

    if (self.selectedPlayers.count > 1) {
        
        self.playButton.enabled = YES;
    } else {

        self.playButton.enabled = NO;
    }
}
- (IBAction)onAddButtonTapped:(UIButton *)sender {

    if (![self.textField.text isEqualToString:@""]) {

        Player *player = [[Player alloc]initPlayerWithName:self.textField.text];

        [self.players addObject:player];
        [self.tableView reloadData];
    }
}

- (IBAction)onPlayButtonTapped:(UIBarButtonItem *)sender {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    ViewController *vc = segue.destinationViewController;

    vc.selectedPlayers = self.selectedPlayers;
}
@end
