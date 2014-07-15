//
//  LostAndFoundSmallCell.h
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 28/5/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostAndFoundSmallCell : UITableViewCell
{
    
}
@property(nonatomic,retain) IBOutlet UILabel *Title;
@property(nonatomic,retain) IBOutlet UIImageView *PostImage;
@property(nonatomic,retain) IBOutlet UILabel *Location;
@property(nonatomic,retain) IBOutlet UILabel *Date;
@property(nonatomic,retain) IBOutlet UIImageView *Type;
@property(nonatomic,retain) IBOutlet UIImageView *BackgroundImage;
@end
