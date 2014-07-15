//
//  CountryListViewController.h
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 30/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol CountryListViewDelegate

-(void)UpdatedCountry;

@end

@interface CountryListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *CountryList;
    NSArray *countryNames;
    NSArray *countryCodes;
    NSString *selectedCountryCode;
    NSDictionary *countryNamesByCode;
    NSDictionary *countryCodesByName;
    MBProgressHUD *HUD;
}

@property(nonatomic,assign) id <CountryListViewDelegate> delegate;

@end
