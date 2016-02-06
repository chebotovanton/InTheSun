//
//  FirstViewController.m
//  InTheSun
//
//  Created by Anton Chebotov on 06/02/16.
//  Copyright © 2016 Anton Chebotov. All rights reserved.
//

#import "AMMusicViewController.h"
#import <MediaPlayer/MediaPlayer.h>

static NSString * kSongCellIdentifier = @"songCell";

@interface AMMusicViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) IBOutlet UITableView *contentTableView;

@end

@implementation AMMusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = [self createItems];
    [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSongCellIdentifier];
}

- (NSArray *)createItems
{
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    return songs;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kSongCellIdentifier];
    MPMediaItem *rowItem = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = rowItem.title;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end