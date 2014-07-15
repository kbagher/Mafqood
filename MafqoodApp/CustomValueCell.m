//
//  CustomValueCell.m
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 30/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import "CustomValueCell.h"

@implementation CustomValueCell
@synthesize Title,Details;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
