//
//  QIPEntryTableViewCell.h
//  NetAppDemo
//
//  Created by David Butts on 5/29/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end
