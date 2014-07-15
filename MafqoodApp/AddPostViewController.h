//
//  AddPostViewController.h
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 30/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <MessageUI/MFMailComposeViewController.h>

@protocol AddPostViewDelegate

-(void)postAdded;

@end

typedef enum {
    ItemImageTypeCamera=0,
    ItemImageTypeLibrary
}ItemImageType;

@interface AddPostViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UITableView *AddPostTableView;
    UITextField *TitleText;
    UITextField *LocationText;
    UITextField *PhoneText;
    UITextField *EmailText;
    UITextField *KikText;
    UITextField *TwitterText;
    MBProgressHUD *HUD;
    UIImage *image;
    UIImageView *ItemImageView;
    
    int itemImageType;
    
    UIImagePickerController *imgPicker;
    
    UITextView *Detailstext;
    NSString *PostType;
    NSString *detailsPlaceHolder;
}
@property(nonatomic,assign) id <AddPostViewDelegate> delegate;

@end
