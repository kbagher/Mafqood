//
//  FirstViewController.h
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 27/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailsViewController.h"
#import "CountryListViewController.h"
#import "MBProgressHUD.h"
#import "AddPostViewController.h"
#import "SettingsViewController.h"
#import "NoLostsViewController.h"
#import <QuartzCore/QuartzCore.h>




@interface PostViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,CountryListViewDelegate,MBProgressHUDDelegate,AddPostViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *PostsTableView;
    NSMutableArray *PostsArray;
    int CurrentPage;
    MBProgressHUD *HUD;
    NoLostsViewController *noLosts;
    
    BOOL ServerHasMoreData;
    BOOL isUserAuthanticated;
    BOOL isGettingDataFromServer;
}
@end
