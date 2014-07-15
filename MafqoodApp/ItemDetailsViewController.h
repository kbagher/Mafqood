//
//  ItemDetailsViewController.h
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 29/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomValueCell.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>


@interface ItemDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
//    IBOutlet UITableView *ItemDetails;
    NSArray *Contact;
    BOOL LoadedContact;
    UIWebView *webView;
    
    NSString *userNumberToCall;
    
}
@property(nonatomic,assign) PFObject *Item;
@property(nonatomic,retain) IBOutlet UITableView *ItemDetails;
@end
