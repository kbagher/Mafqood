//
//  SettingsViewController.m
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 1/5/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

#pragma mark - Motion Detect
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake && [[[PFUser currentUser] objectForKey:@"admin"]boolValue]==YES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"عرض جميع الدول؟" delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم", nil];
        alert.tag=1;
        [alert show];
    }
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}
//#pragma mark - AdFalcon
//-(void) loadAdFalcon
//{
//    adView = [[ADFAdView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-48, 320, 48)];
//    
//    
//    //Create instance of ADFTargetingParams to store all needed info about user and application, all this informations are optional
//    ADFTargetingParams * params = [[ADFTargetingParams alloc] init];
//    //Determine ad keywords i.e. if you set sport, AdFalcon network will retreive ads related to sport
//    //     params.keywords = [[[NSArray alloc] initWithObjects:@"sport", nil] autorelease];
//    //     params.search = @"";//Not supported yet
//    
//    //Create intanse of ADFUserInfo
//    ADFUserInfo * user = [[ADFUserInfo alloc] init];
//    params.userInfo = user;
//    //     user.gender = kADFUserInfoGenderMale;
//    
//    //This property used to determine a language of ad
//    user.language = @"ar";
//    
//    //     //Convert NSString date to NSDate
//    //     NSString *dateString = @"21.11.1984";
//    //     NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//    //     [dateFormatter setDateFormat:@"dd.MM.yyyy"];
//    //     NSDate *dateFromString = [[[NSDate alloc] init] autorelease];
//    //     dateFromString = [dateFormatter dateFromString:dateString];
//    
//    //Add birthdate or Age
//    //     user.birthdate = dateFromString;
//    //     user.age = 27;
//    
//    //Location information
//    //    user.countryCode = @"SA";
//    //     user.areaCode = @"962";
//    //     user.postalCode = @"11121";
//    
//    //     //If you uses gps location you could pass user location information
//    //     user.locationLatitude = 31.956641;
//    //     user.locationLongitude = 35.847037;
//    //     user.locationAccuracyInMeters = 100;
//    
//    //    params.additionalInfo = [[NSMutableDictionary alloc] init];
//    
//    //[params.additionalInfo setValue:@"t" forKey:@"R_AdType"];
//    
//    //If you want to enable logging
//    adView.logging = NO;
//    
//    //If you want to use test mode
//    adView.testing = NO;
//    
//    //If you want to modify refresh duration
//    //the minimum available duration is 15 seconds
//    adView.refreshDuration = 15;
//    
//    //initialize AdFalcon view and loading ads
//    [adView initializeWithAdUnit:kADFAdViewAdUnitSize320x48 //Size of ad if you set a size for adView not match to the Ad unit size; the SDK will modify it to actual size
//     
//                          siteId:ADFALCON_SITE_ID//siteID ID from AdFalcon web site
//     
//                          params:params //User information
//     
//              rootViewController:self //rootViewController
//     
//               enableAutorefresh:YES //if you want to auto refresh for add set this value to YES other wise you will do this operation manully using refreshAd method
//     
//                        delegate:self //Optional
//     
//     ];
//    
//    //Add AdFalcon view
//    [self.view addSubview:adView];
//    [adView refreshAd];
//}
//
//-(void)loadView
//{
//    NSLog(@"Load View");
//    [super loadView];
//    [self loadAdFalcon];
//}

-(NSString *)GetAppVersionAndBuild
{
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return @"2.1";
}

-(void)hideView
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)UpdatedCountry
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTheData" object:self];
    [self hideView];
}


#pragma mark - My Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Show All Countries
    if (alertView.tag==1)
    {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        // Clicked Yes
        if (buttonIndex==1)
        {
            delegate.ShowAllCountries=YES;
        }
        // Clicked No
        else
        {
            delegate.ShowAllCountries=NO;
        }
    }
}
-(void)AppShared:(AppShareType)ShareType
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"شكراً لك على مشاركة التطبيق :)" delegate:nil cancelButtonTitle:@"شـــكراً" otherButtonTitles:nil, nil];
    [alert show];
    if (ShareType==AppShareTypeFacebook)
    {
        [Flurry logEvent:@"Action: Facebook App Share"];
    }
    else if (ShareType==AppShareTypeTwitter)
    {
        [Flurry logEvent:@"Action: Twitter App Share"];
    }

}
#pragma mark Share on twitter
/**
 *  Share the ap with ypur friends using twitter
 */
-(void)ShareOnTwitter
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSLog(@"I can send tweets.");
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        // Settin The Initial Text
        [vc setInitialText:@"تطبيق 'مـفـقـود' سيساعدك على استرجاع اغراضك المفقودة بشكل سريع و مبسط!"];
        NSURL *url = [NSURL URLWithString:@APP_URL];
        [vc addURL:url];
        // Display Tweet Compose View Controller Modally
        [self presentViewController:vc animated:YES completion:nil];
        
        vc.completionHandler = ^(TWTweetComposeViewControllerResult result)
        {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    break;
                    
                case TWTweetComposeViewControllerResultDone:
                    [self AppShared:AppShareTypeTwitter];
                    break;
                    
                default:
                    break;
            }
        };
    }
    else
    {
        // Show Alert View When The Application Cannot Send Tweets
        NSString *message = @"فضلاً تاكد من اعدادات تويتر في هاتفك!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
        [alertView show];
    }
}

-(BOOL)CheckDeviceVersion:(float)CheckForVersion
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= CheckForVersion)
    {
        return YES;
    }
    return NO;
}

#pragma mark Share on facebook
-(void)ShareOnFacebok
{
    if (![self CheckDeviceVersion:6.0])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"خاصية مشاركة التطبيق على الفيسبوك لا تدعم نسخه نظام هاتفك :(" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    SLComposeViewController *mySLComposerSheet;
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [mySLComposerSheet setInitialText:@"تطبيق 'مـفـقـود' سيساعدك على استرجاع اغراضك المفقودة بشكل سريع و مبسط!"]; //the message you want to post
        [mySLComposerSheet addImage:[UIImage imageNamed:@"Mafqood-Icon-1024"]]; //an image you could post
        [mySLComposerSheet addURL:[NSURL URLWithString:@APP_URL]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"فضلاً تاكد من اعدادات فيسبوك في هاتفك!" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
        [alert show];
    }
    
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                [self AppShared:AppShareTypeFacebook];
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
    }];
}

#pragma mark General Methods
-(void)SupportUs
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"كيف تستفيد من مفقود" message:@"كمستخدم\nيمكنك الاستفادة من تطبيق مفقود عن طريق الاعلان عن مفقوداتك او الاعلان عن مفقودات الاخرين.\n\nكجهة مثل(مجمع سكني، مول او جهة عمل)\nيمكنك الاستفادة من مفقود عن طريق استخدامه كمنصه الكترونية لك للاعلان عن مفقودات مجتمعك بشكل مجاني." delegate:nil cancelButtonTitle:@"شكراً جزيلاً :)" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)ShowUpdateCountry
{
    [Flurry logEvent:@"Action: Update Country From Settings"];    
    CountryListViewController *con = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" bundle:nil];
    con.delegate=self;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"اعدادات"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    [self.navigationController pushViewController:con animated:YES];
}

-(void)OpenTwitterPage
{
    [Flurry logEvent:@"Action: Follow Us On Twitter"];
    
    NSURL *url = [NSURL URLWithString:@"twitter://user?screen_name=MafqoodApp"];
    
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/MafqoodApp"]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *) controller didFinishWithResult:(MFMailComposeResult) result error:(NSError *)error
{
    NSLog(@"Action");
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"عتم ارسال الرسالة بنجاح!" delegate:nil cancelButtonTitle:@"شكراً" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}

-(void)ContactUs
{
    if (![MFMailComposeViewController canSendMail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا في الارسال" message:@"عفواً، لا يمكنك ارسال بريد الكتروني لعدم توفر اي حساب بريد الكتروني على هاتفك.\nيمكنك اضافة حسابات البريد الاكتروني عن طرق اعدادات الهاتف." delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    NSArray *toRecipients = [NSArray arrayWithObject: @"MafqoodApp@gmail.com"];
    [controller setToRecipients:toRecipients];
    [controller setTitle:@"راسلنا"];
    
    [controller setMessageBody:[NSString stringWithFormat:@"\n\n\n-----------------------\n%@",[[PFUser currentUser] objectId]] isHTML:nil];

    [self presentViewController:controller animated:YES completion:nil];
    
    [Flurry logEvent:@"Action: Contact Us"];
    
}

#pragma mark - UiTableView

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    if (section==2)
    {
        lbl.text = [NSString stringWithFormat:@"الاصدار  %@",[self GetAppVersionAndBuild]];
    }
    else
        return nil;
    
    lbl.textColor = [UIColor darkGrayColor];
    lbl.shadowColor = [UIColor whiteColor];
    lbl.shadowOffset = CGSizeMake(0,1);
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.alpha = 0.9;
    return lbl;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section!=2)
    {
        return nil;
    }
    return  @"placeholder";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    if (section==1)
    {
        return 2;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [SettingTableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];
    }
    
    if (indexPath.section==0)
    {
        cell.textLabel.text = @"اعدادات الدولة";
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text = @"راسلنا";
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else if (indexPath.row==1)
        {
            cell.textLabel.text = @"اتبعنا على تويتر";
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text = @"كيف تستفيد من مفقود";
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        if (indexPath.row==1)
        {
            cell.textLabel.text = @"انشر التطبيق على تويتر";
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        if (indexPath.row==2)
        {
            cell.textLabel.text = @"انشر التطبيق على فيسبوك";
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

// when user select a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SettingTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0 && indexPath.row==0)
    {
        [self ShowUpdateCountry];
    }
    if (indexPath.section==1 && indexPath.row==0)
    {
        [self ContactUs];
    }
    if (indexPath.section==1 && indexPath.row==1)
    {
        [self OpenTwitterPage];
    }
    if (indexPath.section==2 && indexPath.row==0)
    {
        [self SupportUs];
    }
    if (indexPath.section==2 && indexPath.row==1)
    {
        [self ShareOnTwitter];
    }
    if (indexPath.section==2 && indexPath.row==2)
    {
        [self ShareOnFacebok];
    }
}

#pragma mark - View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"اعدادات",@"اعدادات");
        [label sizeToFit];
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

//    self.navigationItem.title=@"اعدادات";
    
    [Flurry logEvent:@"Page: Settings" timed:YES];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"اغلاق" style:UIBarButtonItemStylePlain target:self action:@selector(hideView)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
