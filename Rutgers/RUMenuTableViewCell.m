//
//  RUMenuTableViewCell.m
//  Rutgers
//
//  Created by Kyle Bailey on 6/3/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUMenuTableViewCell.h"

@implementation RUMenuTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor grey2Color];
        self.opaque = YES;
        self.contentView.opaque = YES;

        UIView *background = [[UIView alloc] init];
        
        background.backgroundColor = [UIColor selectedRedColor];
        
        self.selectedBackgroundView = background;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.channelImage = [[UIImageView alloc] initForAutoLayout];
        [self.contentView addSubview:self.channelImage];
        
        [self.channelImage autoSetDimensionsToSize:CGSizeMake(32, 30)];
        self.channelImage.contentMode = UIViewContentModeCenter;
        [self.channelImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.channelImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.channelTitleLabel = [[UILabel alloc] initForAutoLayout];
        [self.contentView addSubview:self.channelTitleLabel];

        [self.channelTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.channelImage withOffset:16];
        [self.channelTitleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.channelTitleLabel.font = [UIFont systemFontOfSize:16];
        self.channelTitleLabel.textColor = [UIColor whiteColor];
        self.channelImage.tintColor = [UIColor whiteColor];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.channelImage.tintColor = [UIColor blackColor];
    } else {
        self.channelImage.tintColor = [UIColor whiteColor];
    }
    // Configure the view for the selected state
}

@end