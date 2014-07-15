//
//  LostAndFoundCell.m
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 29/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import "LostAndFoundCell.h"

@implementation LostAndFoundCell

@synthesize Title,Type,Location,Date,BackgroundImage;

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
