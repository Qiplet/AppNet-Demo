//
//  QIPEntryTableViewCell.m
//  AppNetDemo
//
//  Created by David Butts on 5/29/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import "PostTableViewCell.h"

@interface PostTableViewCell()


@end

@implementation PostTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
