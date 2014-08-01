//
//  RUMenuTableViewCell.m
//  Rutgers
//
//  Created by Kyle Bailey on 6/3/14.
//  Copyright (c) 2014 Rutgers. All rights reserved.
//

#import "RUMenuTableViewCell.h" 

@interface RUMenuTableViewCell ()
@property (nonatomic) UIView *leftPadView;
@end

@implementation RUMenuTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
       // self.contentView.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

       // self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        self.channelImage = [UIImageView newAutoLayoutView];
        self.channelImage.tintColor = [UIColor menuDeselectedColor];

        [self.contentView addSubview:self.channelImage];
        
        [self.channelImage autoSetDimensionsToSize:CGSizeMake(32, 30)];
        self.channelImage.contentMode = UIViewContentModeTopLeft;
        
        [self.channelImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.channelImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        
        self.channelTitleLabel = [UILabel newAutoLayoutView];
        [self.contentView addSubview:self.channelTitleLabel];

        [self.channelTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.channelImage withOffset:16];
        [self.channelTitleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.channelTitleLabel.font = [UIFont systemFontOfSize:17];
        self.channelTitleLabel.textColor = [UIColor menuDeselectedColor];
        
        
        self.leftPadView = [UIView newAutoLayoutView];
        [self.contentView addSubview:self.leftPadView];
        
        [self.leftPadView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeRight];
        [self.leftPadView autoSetDimension:ALDimensionWidth toSize:5];
        
        self.leftPadView.backgroundColor = [UIColor selectedRedColor];
        self.leftPadView.hidden = YES;
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    if (!self.selected) {
        [self applyStyleForHighlightedState:highlighted];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self applyStyleForHighlightedState:selected];
}

-(void)applyStyleForHighlightedState:(BOOL)state{
    if (state) {
       // self.backgroundColor = [UIColor grey1Color];
        self.leftPadView.hidden = NO;
        self.channelImage.tintColor = [UIColor whiteColor];
        self.channelTitleLabel.textColor = [UIColor whiteColor];
    } else {
       // self.backgroundColor = [UIColor grey2Color];
        self.channelImage.tintColor = [UIColor menuDeselectedColor];
        self.channelTitleLabel.textColor = [UIColor menuDeselectedColor];
        self.leftPadView.hidden = YES;
    }
}


@end
