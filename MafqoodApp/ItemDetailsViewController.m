//
//  ItemDetailsViewController.m
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 29/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import "ItemDetailsViewController.h"

#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface ItemDetailsViewController ()

@end

@implementation ItemDetailsViewController

@synthesize Item;
#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Normal User
    if (actionSheet.tag==2)
    {
        if (buttonIndex==3)
            return;
        else if (buttonIndex==0)
        {
            [self TweetPost];
        }
        else if (buttonIndex==1)
        {
            [self ReportPost];
        }
    }
    // Admin User
    else
    {
        if (buttonIndex==5)
            return;
        else if (buttonIndex==0)
        {
            [self TweetPost];
        }
        else if (buttonIndex==1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"حظر اعلان" message:@"هل انت متاكد من رغبتك في حظر الاعلان؟" delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم", nil];
            alert.tag=1;
            [alert show];
        }
        else if (buttonIndex==2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"حذف الاعلان" message:@"هل انت متاكد من رغبتك في حذف الاعلان" delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم", nil];
            alert.tag=2;
            [alert show];
        }
        else if (buttonIndex==3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"حظر مسخدم" message:@"هل انت متاكد من رغبتك في حظر المستخدم" delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم", nil];
            alert.tag=3;
            [alert show];
        }
        else if (buttonIndex==4)
        {
            [self ReportPost];
        }
    }

}
#pragma mark - Show Action Menu

- (void)ShowOptionsSheet
{
    if ([[[PFUser currentUser] objectForKey:@"admin"] boolValue]==YES)
    {
        // Create the sheet with buttons hardcoded in initialiser
        UIActionSheet *sheet = [[UIActionSheet alloc]
                                initWithTitle:nil
                                delegate:self
                                cancelButtonTitle:@"الغاء"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"نشر على تويتر",@"حظر الاعلان",@"حذف الاعلان",@"حظر المستخدم",@"ابلاغ عن محتوى مخالف", nil];
        sheet.actionSheetStyle =UIActionSheetStyleDefault;
        sheet.destructiveButtonIndex=4;
        sheet.tag=1;
        [sheet showInView:self.view];
    }
    else
    {
        // Create the sheet with buttons hardcoded in initialiser
        UIActionSheet *sheet = [[UIActionSheet alloc]
                                initWithTitle:nil
                                delegate:self
                                cancelButtonTitle:@"الغاء"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"نشر على تويتر",@"ابلاغ عن محتوى مخالف", nil];
        sheet.actionSheetStyle =UIActionSheetStyleDefault;
        sheet.destructiveButtonIndex=1;
        sheet.tag=2;
        [sheet showInView:self.view];
    }
}

#pragma mark - My Methods
-(void)DeletePost
{
    PFQuery *q = [PFQuery queryWithClassName:@"PostContact"];
    [q whereKey:@"post" equalTo:self.Item];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        for (PFObject *obj in objects)
        {
            [obj deleteInBackground];
        }
     
    }];

    PFQuery *q2 = [PFQuery queryWithClassName:@"PostReport"];
    [q2 whereKey:@"post" equalTo:self.Item];
    [q2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         for (PFObject *obj in objects)
         {
             [obj deleteInBackground];
         }
     }];
    
    [self.Item deleteInBackground];
    
}
-(void)BlockPost
{
    [self.Item setObject:[NSNumber numberWithBool:YES] forKey:@"blocked"];
    [self.Item saveInBackground];
}
-(void)BlockUser
{
    [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:@"blocked"];
    [[PFUser currentUser] saveInBackground];
}

-(void)TweetPost
{

    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSLog(@"I can send tweets.");
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        // Settin The Initial Text
        [vc setInitialText:[NSString stringWithFormat:@"%@\n%@\n",[Item objectForKey:@"title"],@"@MafqoodApp"]]; //the message you want to post
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
                    break;
                    
                default:
                    break;
            }
        };
    }
    else
    {
        NSString *message = @"فضلاً تاكد من اعدادات تويتر في هاتفك!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)ReportTweetWasSent
{
    
    for (int x=0; x<Contact.count; x++)
    {
        PFObject *con = [Contact objectAtIndex:x];
        NSString *type = [con objectForKey:@"contactType"];
        NSString *data = [con objectForKey:@"contactData"];
        if ([type isEqualToString:@"email"])
        {
            NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:data,@"To",nil];
            [Flurry logEvent:@"Action: Tweet Sent To User" withParameters:parameters];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Block Post
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
            [self BlockPost];
    }
    // Delete Post
    else if (alertView.tag==2)
    {
        if (buttonIndex==1)
            [self DeletePost];
    }
    // Block User
    else if (alertView.tag==3)
    {
        if (buttonIndex==1)
            [self BlockUser];
    }
    // Report Post
    else
    {
        if (buttonIndex==1)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"PostReport"];
            [query whereKey:@"user" equalTo:[PFUser currentUser]];
            [query whereKey:@"post" equalTo:Item];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error)
                {
                    // The find succeeded.
                    if (objects.count==0)
                    {
                        PFObject *obj = [PFObject objectWithClassName:@"PostReport"];
                        [obj setObject:[PFUser currentUser] forKey:@"user"];
                        [obj setObject:Item forKey:@"post"];
                        [obj saveInBackground];
                        [Item incrementKey:@"reported"];
                        [Item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                         {
                             NSLog(@"Reported!");
                             NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:[Item objectId],@"PostID",nil];
                             [Flurry logEvent:@"Action: Post Reported" withParameters:parameters];
                         }];
                    }
                    else
                    {
                        NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:[Item objectId],@"PostID",nil];
                        [Flurry logEvent:@"Action: Post Already Reported" withParameters:parameters];
                    }
                } else
                {
                    // Log details of the failure
                    [Flurry logError:@"ReportingPost" message:@"Cannot Report Post" error:error];
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }
}
-(void)ReportPost
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ابلاغ عن محتوى مخالف" message:@"هل ترغب في الابلاغ عن هذا المحتوى كمحتوى مخالف او غير ملائم؟" delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم", nil];
    [alert show];
}

-(void)CallNumber:(NSString *)number
{
    NSLog(@"Calling %@",number);
    
    NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:number,@"Number",nil];
    [Flurry logEvent:@"Action: Calling A User Number" withParameters:parameters];
    
    NSString *num = [NSString stringWithFormat:@"tel://%@",number];
    NSURL *URL = [NSURL URLWithString:num];
    [webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)mailComposeController:(MFMailComposeViewController *) controller didFinishWithResult:(MFMailComposeResult) result error:(NSError *)error
{
    NSLog(@"Action");
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"تم ارسال الرسالة بنجاح!" delegate:nil cancelButtonTitle:@"شكراً" otherButtonTitles:nil, nil];
        [alert show];
        for (int x=0; x<Contact.count; x++)
        {
            PFObject *con = [Contact objectAtIndex:x];
            NSString *type = [con objectForKey:@"contactType"];
            NSString *data = [con objectForKey:@"contactData"];
            if ([type isEqualToString:@"email"])
            {
                NSDictionary *parameters =[NSDictionary dictionaryWithObjectsAndKeys:data,@"To",nil];
                [Flurry logEvent:@"Action: Email Sent To User" withParameters:parameters];
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}

-(void)SendEmail:( NSString *)ToEmail
{
    if (![MFMailComposeViewController canSendMail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا في الارسال" message:@"عفواً، لا يمكنك ارسال بريد الكتروني لعدم توفر اي حساب بريد الكتروني على هاتفك.\nيمكنك اضافة حسابات البريد الاكتروني عن طرق اعدادات الهاتف." delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];

    
//    UIImage *image = [UIImage imageNamed: @"lost"];
//    UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,42)];
//    iv.image = image;
//    iv.contentMode = UIViewContentModeCenter;
//    [[[controller viewControllers] lastObject] navigationItem].titleView = iv;
//    [[controller navigationBar] sendSubviewToBack:iv];
    
    
    controller.mailComposeDelegate = self;
    NSArray *toRecipients = [NSArray arrayWithObject: ToEmail];
    [controller setToRecipients:toRecipients];
    if ([[Item objectForKey:@"type"] isEqualToString:@"lost"])
    {
        [controller setSubject:@"لقد وجدت الغرض الخاص بك - تطبيق مفقود"];
    }
    else
    {
        [controller setSubject:@"شكرا لعثورك على الغرض الخاص بي - تطبيق مفقود"];        
    }

    [self presentViewController:controller animated:YES completion:nil];
}
-(void)SendKikMessage:(NSString *)ToUser
{
    // Currently it will only copy the kik username
    // provided you actually have your table view cell
    NSString *copyStringverse = ToUser;
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:copyStringverse];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kik" message:@"تم نسخ اسم المستخدم" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)SendTweet:(NSString *)ToUser
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSLog(@"I can send tweets.");
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        // Settin The Initial Text
        [vc setInitialText:[NSString stringWithFormat:@"@%@ ",ToUser]];
        NSURL *url = [NSURL URLWithString:@"https://twitter.com/MafqoodApp"];
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
                    [self ReportTweetWasSent];
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

#pragma mark - UiTableView

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if(indexPath.row % 2)
    //        [cell setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1]];
    //    else
    //        [cell setBackgroundColor:[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 2;
    }
    else if (section==1)
    {
        return 1;
    }
    else if (section==2)
    {
        if (!LoadedContact || (LoadedContact && Contact.count==0))
            return 1;
        
        return Contact.count;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    if (section==0)
    {
        lbl.text = @"   البيانات";
    }
    if (section==1)
    {
        lbl.text = @"   مكان الفقدان / العثور";
    }
    if (section==2)
    {
        lbl.text = @"   للتواصل مع الشخص المعلن:";
    }
    lbl.textColor = [UIColor darkGrayColor];
    lbl.shadowColor = [UIColor whiteColor];
    lbl.shadowOffset = CGSizeMake(0,1);
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentRight;
    lbl.alpha = 0.9;
    return lbl;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  @"placeholder";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==1)
    {
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [[Item objectForKey:@"details"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, 44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    if (indexPath.section==1 && indexPath.row==0)
    {
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [[Item objectForKey:@"location"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, 44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    }
    
    return 44.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            UITableViewCell *cell = [self.ItemDetails dequeueReusableCellWithIdentifier:@"TitleCell"];
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
            }
            cell.textLabel.text = [Item objectForKey:@"title"];
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else if (indexPath.row==1)
        {
            UITableViewCell *textCell;
            UILabel *label = nil;
            NSString *details;
            
            textCell = [self.ItemDetails dequeueReusableCellWithIdentifier:@"ItemDetails"];
            if (textCell == nil)
            {
                textCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemDetails"];
                label = [[UILabel alloc] initWithFrame:CGRectZero];
                [label setLineBreakMode:NSLineBreakByWordWrapping];
                [label setNumberOfLines:0];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                if ([Item objectForKey:@"details"] ==nil)
                {
                    [label setTextAlignment:NSTextAlignmentCenter];
                    [label setFont:[UIFont italicSystemFontOfSize:12.0f]];
                }
                else
                {
                    [label setTextAlignment:NSTextAlignmentRight];
                    [label setFont:[UIFont systemFontOfSize:14.0f]];
                }
                [[textCell contentView] addSubview:label];
            }
            
            if ([Item objectForKey:@"details"] ==nil)
            {
                details = @"لا توجد تفاصيل";
            }
            else
            {
                details = [Item objectForKey:@"details"];
            }
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [details sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            
            if (!label)
                label = (UILabel*)[textCell viewWithTag:1];
            
            [label setText:details];
            [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
            
            [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return textCell;
        }
        
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            UITableViewCell *textCell;
            UILabel *label = nil;
            NSString *details;
            
//            NSLog(@"%@",[Item objectForKey:@"location"]);
            
            textCell = [tableView dequeueReusableCellWithIdentifier:@"ValueCell"];
            if (textCell == nil)
            {
                // Create a temporary UIViewController to instantiate the custom cell.
                textCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ValueCell"];
            
                label = [[UILabel alloc] initWithFrame:CGRectZero];
                [label setLineBreakMode:NSLineBreakByWordWrapping];
                [label setMinimumScaleFactor:12.0f];
                [label setNumberOfLines:0];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                if ([Item objectForKey:@"location"] ==nil)
                {
                    [label setTextAlignment:NSTextAlignmentCenter];
                    [label setFont:[UIFont italicSystemFontOfSize:12.0f]];
                }
                else
                {
                    [label setTextAlignment:NSTextAlignmentRight];
                    [label setFont:[UIFont systemFontOfSize:14.0f]];
                }
                [[textCell contentView] addSubview:label];
            }
            
            if ([Item objectForKey:@"location"] ==nil)
            {
                details = @"لا توجد تفاصيل";
            }
            else
            {
                details = [Item objectForKey:@"location"];
            }
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [details sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            
            if (!label)
                label = (UILabel*)[textCell viewWithTag:1];
            
            [label setText:details];
            [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
            
            [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return textCell;
        }
        
    }
    if (indexPath.section==2)
    {
        if (!LoadedContact)
        {
            UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"WaitingCell"];
            if(!Cell)
            {
                Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WaitingCell"];
            }
            UIActivityIndicatorView *waiting = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
            [waiting startAnimating];
            [waiting setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
            [Cell.contentView addSubview:waiting];
            [Cell setUserInteractionEnabled:NO];
            return Cell;
        }
        else if(LoadedContact && Contact.count==0)
        {
            UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"NoContactCell"];
            if(!Cell)
            {
                Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoContactCell"];
            }
            Cell.textLabel.textAlignment=NSTextAlignmentCenter;
            Cell.textLabel.font = [UIFont italicSystemFontOfSize:12.0f];
            Cell.textLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1];
            Cell.textLabel.text = @"لا توجد بيانات اتصال";
            [Cell setUserInteractionEnabled:NO];
            return Cell;
        }
        
        CustomValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomValueCell"];
        if (cell == nil)
        {
            // Create a temporary UIViewController to instantiate the custom cell.
            UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:@"CustomValueCell" bundle:nil];
            // Grab a pointer to the custom cell.
            cell = (CustomValueCell *)temporaryController.view;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor] ;

        }
        
        PFObject *con = [Contact objectAtIndex:indexPath.row];
        cell.Details.text = [con objectForKey:@"contactData"];
        
        if ([[con objectForKey:@"contactType"] isEqualToString:@"phone"])
        {
            cell.Title.text = @"جوال:";
        }
        else if ([[con objectForKey:@"contactType"] isEqualToString:@"email"])
        {
            cell.Title.text = @"بريد:";
        }
        else if ([[con objectForKey:@"contactType"] isEqualToString:@"kik"])
        {
            cell.Title.text = @"كيك:";
        }
        else if ([[con objectForKey:@"contactType"] isEqualToString:@"twitter"])
        {
            cell.Title.text = @"تويتر:";
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        return cell;
    }
    return nil;
}


// when user select a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.ItemDetails deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==2)
    {
        PFObject *con = [Contact objectAtIndex:indexPath.row];
        NSString *type = [con objectForKey:@"contactType"];
        NSString *data = [con objectForKey:@"contactData"];
        
        if ([type isEqualToString:@"phone"])
        {
            [self CallNumber:data];
        }
        else if ([type isEqualToString:@"email"])
        {
            [self SendEmail:data];
        }
        else if ([type isEqualToString:@"twitter"])
        {
            [self SendTweet:data];
        }
        else if ([type isEqualToString:@"kik"])
        {
            [self SendKikMessage:data];
        }
        
    }
}


#pragma mark - View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        
        if ([[Item objectForKey:@"type"] isEqualToString:@"lost"])
        {
            label.text=@"فقدت التالي";
        }
        else if ([[Item objectForKey:@"type"] isEqualToString:@"found"])
        {
            label.text=@"وجدت التالي";
        }
        
        
        [label sizeToFit];
    }
    return self;
}


- (void)viewDidLoad
{
    
    Contact = [[NSArray alloc] init];
    LoadedContact = NO;
    webView = [[UIWebView alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"خيارات" style:UIBarButtonItemStylePlain target:self action:@selector(ShowOptionsSheet)];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PostContact"];
    [query whereKey:@"post" equalTo:Item];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if (self.ItemDetails && [self.ItemDetails respondsToSelector:@selector(reloadData)])
            {
                @try
                {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %d Contacts.", objects.count);
                    Contact = [[NSArray alloc] initWithArray:objects];
                    LoadedContact=YES;
                    [self.ItemDetails reloadData];
                }
                @catch (NSException *exception)
                {
                    ;
                }
            }
        } else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    [Flurry logEvent:@"Page: Item Details" timed:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
