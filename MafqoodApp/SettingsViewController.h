//
//  SettingsViewController.h
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 1/5/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CountryListViewController.h"
#import <Twitter/Twitter.h>


typedef enum
{
    AppShareTypeFacebook=1,
    AppShareTypeTwitter
}AppShareType;

@interface SettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,CountryListViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *SettingTableView;
}

@end
