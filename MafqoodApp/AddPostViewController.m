//
//  AddPostViewController.m
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 30/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import "AddPostViewController.h"


@interface AddPostViewController ()

@end

@implementation AddPostViewController
@synthesize delegate;

CGFloat compression = 0.9f;
CGFloat maxCompression = 0.1f;
int maxFileSize = 127*1024;

#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2)
        return;
    
    if (buttonIndex ==0)
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex==1)
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;   
    }

    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark -Handle Image Picker And Upload
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"Added Image");
    image = img;
    NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:0];
    [AddPostTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

-(void)TakePicture
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"اختر مصدر الصورة" delegate:self cancelButtonTitle:@"الغاء" destructiveButtonTitle:nil otherButtonTitles:@"الكاميرا",@"البوم الصور", nil];
//    action.destructiveButtonIndex=2;
    [action showInView:self.view];
}


#pragma mark - Data Integrity
-(Boolean)istwitterAccountCorrect:(NSString *)twitter
{
    if(![twitter isEqualToString:@""])
    {
        NSString *twitterRegEx = @"[a-zA-Z0-9_]+";
        
        NSPredicate *twitterlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", twitterRegEx];

        //Valid twitter Account
        if ([twitterlTest evaluateWithObject:twitter] == YES)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}
/**
 *  <#Description#>
 *
 *  @param emil <#emil description#>
 *
 *  @return <#return value description#>
 */
-(Boolean)isEmailCorrect:(NSString *)emil
{
    if(![emil isEqualToString:@""])
    {
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}+\\.[A-Za-z]{2,2}";
        NSString *emailRegEx2 = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        NSPredicate *emailTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx2];
        
        if ([emil rangeOfString:@"@."].location !=NSNotFound)
        {
            return NO;
        }
        
        //Valid email address
        if ([emailTest evaluateWithObject:emil] == YES || [emailTest2 evaluateWithObject:emil] == YES)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}
-(BOOL)isNumeric:(NSString*)inputString
{
    BOOL isValid=NO;
    if (inputString==nil)
        return isValid;
    
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}
-(BOOL)isInputDataValid
{
    NSString* email = [EmailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* twitter = [TwitterText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* phone = [PhoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* kik = [KikText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* title = [TitleText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* details = [Detailstext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (title==nil || [title length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"عنوان الاعلان فارغ!\n\nادخل بياناتك بشكل صحيح حتى يتمكن الاخرون من مساعدتك" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if (details==nil || [details isEqualToString:detailsPlaceHolder] || [details length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"فضلاً قم بتزويدنا ببعض التفاصيل.\n\nادخل بياناتك بشكل صحيح حتى يتمكن الاخرون من مساعدتك" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if (PostType == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"هل فقدت ام وجدت غرضً؟ فضلاً قم باختيار احدهم.\n\nادخل بياناتك بشكل صحيح حتى يتمكن الاخرون من مساعدتك" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    if ([phone length]>0)
    {
        NSLog(@"phone is not empty");
        if (![self isNumeric:phone])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"الهاتف المدخل غير صحيح.\n\nادخل بياناتك بشكل صحيح حتى يتمكن الاخرون من مساعدتك" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    if ([email length]>0)
    {
        if (![self isEmailCorrect:email])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"البريد الالكتروني المدخل غير صحيح.\n\nادخل بياناتك بشكل صحيح حتى يتمكن الاخرون من مساعدتك" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    if ([twitter length]>0)
    {
        if (![self istwitterAccountCorrect:twitter])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"حساب تويتر المدخل غير صحيح.\n\nادخل بياناتك بشكل صحيح حتى يتمكن الاخرون من مساعدتك" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    if ([phone length]==0 && [twitter  length]==0 && [email  length]==0 && [kik  length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"يجب عليك تعبئة وسيلة تواصل واحده على الاقل.\n\nادخل بياناتك بشكل صحيح حتى يتمكن الاخرون من مساعدتك" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}



#pragma mark - TextField Delegate
-(void)resetTableViewMask
{
    [UIView animateWithDuration:0.3 animations:^(void){
        AddPostTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [AddPostTableView resignFirstResponder];
    [textField resignFirstResponder];
    [self resetTableViewMask];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(textFieldDidBeginEditing:) withObject:sender waitUntilDone:NO];
        return;
    }

    AddPostTableView.contentInset =  UIEdgeInsetsMake(0, 0, 220, 0);
    
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *path = [AddPostTableView indexPathForCell:cell];
    
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         [AddPostTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
     }];
}

#pragma mark - TextView Dlegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:detailsPlaceHolder])
    {
        textView.text=@"";
        textView.alpha=1;
        AddPostTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0);
        
        UITableViewCell *cell = (UITableViewCell *)[[[textView superview] superview] superview];
        NSIndexPath *path = [AddPostTableView indexPathForCell:cell];
        
        [UIView animateWithDuration:0.3 animations:^(void)
         {
             NSLog(@"Should Scroll to section %d and row %d",path.section,path.row);
             
             [AddPostTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
         }];
        
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text=detailsPlaceHolder;
        textView.alpha=0.8;
    }
}

#pragma mark - My Methods
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

-(void)Objection
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
    NSArray *toRecipients = [NSArray arrayWithObject: @"MafqoodApp@gmail.com"];
    [controller setToRecipients:toRecipients];
    [controller setSubject:@"تم حظر حسابي"];
    [controller setMessageBody:[NSString stringWithFormat:@"\n\n\n-----------------------\n%@",[[PFUser currentUser] objectId]] isHTML:NO];

    [self presentViewController:controller animated:YES completion:nil];
    
    [Flurry logEvent:@"Action: Contact Us"];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[self delegate] postAdded];
    }
    else if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            [Flurry logEvent:@"Action: Objection"];
            [self Objection];
        }
    }
}
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud=nil;
}

-(void)AddPost
{
    if ([self isInputDataValid])
    {
        PFObject *usr =[PFUser currentUser];
        BOOL isBlocked = [[usr objectForKey:@"blocked"] boolValue];
        if (isBlocked)
        {
            [self.view endEditing:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"محظور" message:@"عفواً لقد تم حظر حسابك لوضعك محتوى مخالف او غير ملائم.\n\nاذا كنت ترا انه قد تم حظر حسابك بالخطأ، فضلا قد بمراسلتنا." delegate:self cancelButtonTitle:@"اخفاء" otherButtonTitles:@"راسلنا", nil];
            alert.tag=2;
            [alert show];
            return;
        }
        
        [self.view endEditing:YES];
        [self resetTableViewMask];
        
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self.navigationController.view addSubview:HUD];
        HUD.dimBackground=NO;
        HUD.delegate = self;
        
        
        [Flurry logEvent:@"Action: Should Add New Post"];
        NSString* email = [EmailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* twitter = [TwitterText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* phone = [PhoneText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* kik = [KikText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* location = [LocationText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* title = [TitleText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* details = [Detailstext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        PFObject *post = [PFObject objectWithClassName:@"Post"];
        [post setObject:title forKey:@"title"];
        [post setObject:details forKey:@"details"];
        [post setObject:[PFUser currentUser] forKey:@"author"];
        [post setObject:[[PFUser currentUser] objectForKey:@"country"]forKey:@"country"];
        
       
        [post setObject:PostType forKey:@"type"];
        
        NSMutableArray *objects=[[NSMutableArray alloc] init];
        
        if ([email length]>0)
        {
            NSLog(@"Adding Email");
            PFObject *contactEmail = [PFObject objectWithClassName:@"PostContact"];
            [contactEmail setObject:@"email" forKey:@"contactType"];
            [contactEmail setObject:email forKey:@"contactData"];
            [contactEmail setObject:post forKey:@"post"];
            [objects addObject:contactEmail];
        }
        if ([kik length]>0)
        {
            NSLog(@"Adding Email");
            PFObject *contactKik = [PFObject objectWithClassName:@"PostContact"];
            [contactKik setObject:@"kik" forKey:@"contactType"];
            [contactKik setObject:kik forKey:@"contactData"];
            [contactKik setObject:post forKey:@"post"];
            [objects addObject:contactKik];
        }
        if ([twitter length]>0)
        {
            NSLog(@"Adding twitter");
             PFObject *contactTwitter= [PFObject objectWithClassName:@"PostContact"];
            [contactTwitter setObject:@"twitter" forKey:@"contactType"];
            [contactTwitter setObject:twitter forKey:@"contactData"];
            [contactTwitter setObject:post forKey:@"post"];
            [objects addObject:contactTwitter];
        }
        if ([phone length]>0)
        {
            NSLog(@"Adding phone");
            PFObject *contactPhone = [PFObject objectWithClassName:@"PostContact"];
            [contactPhone setObject:@"phone" forKey:@"contactType"];
            [contactPhone setObject:phone forKey:@"contactData"];
            [contactPhone setObject:post forKey:@"post"];
            [objects addObject:contactPhone];
        }
        if ([location length]>0)
        {
            [post setObject:location forKey:@"location"];
        }

        
        
        if (image!=[UIImage imageNamed:@"placeholder"] && image!=nil)
        {
            NSData *imageData = UIImageJPEGRepresentation(image, compression);
            
            while ([imageData length] > maxFileSize && compression > maxCompression)
            {
                compression -= 0.1;
                imageData = UIImageJPEGRepresentation(image, compression);
            }
            \
            PFFile *imageFile = [PFFile fileWithName:@"Image.png" data:imageData];

            // Save PFFile
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error)
                {
                    [post setObject:imageFile forKey:@"image"];
                    [post setObject:[NSNumber numberWithBool:YES] forKey:@"hasimage"];
                    [PFObject saveAllInBackground:objects block:^(BOOL succeeded, NSError *error)
                    {
                        if (!error)
                        {
                            [HUD hide:YES];
                            [Flurry logEvent:@"Action: Post Added"];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"تم اضافة اعلانك بنجاح!" delegate:nil cancelButtonTitle:@"شكراً" otherButtonTitles:nil, nil];
                            alert.delegate=self;
                            alert.tag=1;
                            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                        }
                        else
                        {
                            [HUD hide:YES];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"فضلاً تأكد من وجود اتصال بالانترنت!" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
                            [alert show];
                            [Flurry logError:@"AddingPost" message:@"Cannot Add New Post" error:error];
                        }
                    }];
                }
                else
                {
                    [HUD hide:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"فضلاً تأكد من وجود اتصال بالانترنت!" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
                    [alert show];
                    [Flurry logError:@"AddingPost" message:@"Cannot Add New Post Image" error:error];
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            } progressBlock:nil];
        }
        else
        {
            
            [PFObject saveAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                if (!error)
                {
                    [HUD hide:YES];
                    [Flurry logEvent:@"Action: Post Added"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"تم اضافة اعلانك بنجاح!" delegate:nil cancelButtonTitle:@"شكراً" otherButtonTitles:nil, nil];
                    alert.delegate=self;
                    alert.tag=1;
                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                }
                else
                {
                    [HUD hide:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"فضلاً تأكد من وجود اتصال بالانترنت!" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
                    [alert show];
                    [Flurry logError:@"AddingPost" message:@"Cannot Add New Post" error:error];
                }
            }];
        }
    }
}

-(void)HideView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UiTableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
    else if (section==2)
    {
        return 2;
    }
    else if (section==3)
    {
        return 1;
    }
    else if (section==4)
    {
        return 4;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    if (section==0)
    {
        return nil;
        lbl.text = @"   الـــصــورة";
    }
    if (section==1)
    {
        lbl.text = @"   وجدت ام فقدت غرضاً؟";
    }
    if (section==2)
    {
        lbl.text = @"   البيانات";
    }
    if (section==3)
    {
        lbl.text = @"   اين فقدت / عثرت على الغرض؟";
    }
    if (section==4)
    {
        lbl.text = @"   وسائل الاتصال بك (وسيلة واحده على الاقل)";
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
    if (section==0)
    {
        return 0;
    }
    return  @"placeholder";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        return 300;
    }
    if (indexPath.section==2 && indexPath.row==1)
    {
        return 110;
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            
            UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostImageCell"];
            for (UIView *vi in cell.contentView.subviews)
            {
                [vi performSelector:@selector(removeFromSuperview)];
            }
            ItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 290, 290)];
            [ItemImageView setContentMode:UIViewContentModeScaleAspectFit];
            [cell.contentView addSubview:ItemImageView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            [ItemImageView setImage:image];
            return cell;
        }
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            UITableViewCell *cell;
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostTypeCell"];
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 265, 44)];
                [lbl setBackgroundColor:[UIColor clearColor]];
                [lbl setTextColor: [UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                [lbl setTextAlignment:NSTextAlignmentRight];
                [lbl setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [lbl setText:@"فقدت غرضاً"];
                [[cell contentView] addSubview:lbl];
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds] ;
                cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor] ;
                if ([PostType isEqualToString:@"lost"])
                {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [cell setTintColor:[UIColor colorWithRed:40.0/255.0 green:153.0/255.0 blue:147.0/255.0 alpha:1]];
                }
                else
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            return cell;
        }
        else if (indexPath.row==1)
        {
            UITableViewCell *cell;
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostTypeCell"];
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 265, 44)];
                [lbl setBackgroundColor:[UIColor clearColor]];
                [lbl setTextColor: [UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                [lbl setTextAlignment:NSTextAlignmentRight];
                [lbl setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [lbl setText:@"وجدت غرضاً"];
                [[cell contentView] addSubview:lbl];
                cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds] ;
                cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor] ;
                if ([PostType isEqualToString:@"found"])
                {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [cell setTintColor:[UIColor colorWithRed:40.0/255.0 green:153.0/255.0 blue:147.0/255.0 alpha:1]];
                }
                else
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            return cell;
        }
        
    }

    if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            UITableViewCell *cell = [AddPostTableView dequeueReusableCellWithIdentifier:@"TitleCell"];
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"];
                TitleText = [[UITextField alloc] initWithFrame:CGRectMake(10, 1, 280, 44)];
                [TitleText setContentMode:UIViewContentModeCenter];
                [TitleText setBackgroundColor:[UIColor clearColor]];
                [TitleText setTextColor: [UIColor colorWithRed:68.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1]];
                [TitleText setTextAlignment:NSTextAlignmentCenter];
                [TitleText setFont:[UIFont boldSystemFontOfSize:15.0f]];
                [TitleText setPlaceholder:@"العنوان، مثال: فقدت كاميرا كانون"];
                [TitleText setDelegate:self];
                [[cell contentView] addSubview:TitleText];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }
        if (indexPath.row==1)
        {
            UITableViewCell *cell = [AddPostTableView dequeueReusableCellWithIdentifier:@"DetailsCell"];
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailsCell"];
                Detailstext = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 95)];
                [Detailstext setBackgroundColor:[UIColor clearColor]];
                [Detailstext setTextColor: [UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                [Detailstext setFont:[UIFont systemFontOfSize:14.0f]];
                [Detailstext setText:detailsPlaceHolder];
                [Detailstext setDelegate:self];
                [[cell contentView] addSubview:Detailstext];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }        
    }
    
    if (indexPath.section==3)
    {
        if (indexPath.row==0)
        {
            UITableViewCell *cell = [AddPostTableView dequeueReusableCellWithIdentifier:@"LocationCell"];
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
                LocationText = [[UITextField alloc] initWithFrame:CGRectMake(10, 1, 280, 44)];
                [LocationText setContentMode:UIViewContentModeCenter];
                [LocationText setBackgroundColor:[UIColor clearColor]];
                [LocationText setTextColor: [UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                [LocationText setTextAlignment:NSTextAlignmentRight];
                [LocationText setFont:[UIFont systemFontOfSize:14.0f]];
                [LocationText setPlaceholder:@"مثال: جدة، حي الفيحاء بجوار مسجد الفاروق"];
                [LocationText setDelegate:self];
                [[cell contentView] addSubview:LocationText];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }
    }
    if (indexPath.section==4)
    {
        if (indexPath.row==0)
        {
            UITableViewCell *cell = [AddPostTableView dequeueReusableCellWithIdentifier:@"phoneCell"];
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phoneCell"];
                PhoneText = [[UITextField alloc] initWithFrame:CGRectMake(10, 1, 220, 44)];
                [PhoneText setBackgroundColor:[UIColor clearColor]];
                [PhoneText setTextColor: [UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                [PhoneText setTextAlignment:NSTextAlignmentLeft];
                [PhoneText setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [PhoneText setKeyboardType:UIKeyboardTypePhonePad];
                [PhoneText setDelegate:self];
                [PhoneText setPlaceholder:@"هاتف ثابت او جوال"];
                [[cell contentView] addSubview:PhoneText];
                
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 45, 44)];
                [lbl setBackgroundColor:[UIColor clearColor]];
                [lbl setText:@"هاتف:"];
                [lbl setTextColor:[UIColor darkGrayColor]];
                [lbl setTextAlignment:NSTextAlignmentRight];
                [lbl setFont:[UIFont boldSystemFontOfSize:14]];
                [[cell contentView] addSubview:lbl];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }
        else if (indexPath.row==1)
        {
            UITableViewCell *cell = [AddPostTableView dequeueReusableCellWithIdentifier:@"emailCell"];
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emailCell"];
                EmailText = [[UITextField alloc] initWithFrame:CGRectMake(10, 1, 220, 44)];
                [EmailText setBackgroundColor:[UIColor clearColor]];
                [EmailText setTextColor: [UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                [EmailText setTextAlignment:NSTextAlignmentLeft];
                [EmailText setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [EmailText setKeyboardType:UIKeyboardTypeEmailAddress];
                [EmailText setDelegate:self];
                [EmailText setPlaceholder:@"your@email.com"];
                [[cell contentView] addSubview:EmailText];
                
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 45, 44)];
                [lbl setBackgroundColor:[UIColor clearColor]];
                [lbl setText:@"بريد:"];
                [lbl setTextColor:[UIColor darkGrayColor]];
                [lbl setTextAlignment:NSTextAlignmentRight];
                [lbl setFont:[UIFont boldSystemFontOfSize:14]];
                [[cell contentView] addSubview:lbl];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }
        else if (indexPath.row==2)
        {
            UITableViewCell *cell = [AddPostTableView dequeueReusableCellWithIdentifier:@"kikCell"];
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kikCell"];
                KikText = [[UITextField alloc] initWithFrame:CGRectMake(10, 1, 220, 44)];
                [KikText setBackgroundColor:[UIColor clearColor]];
                [KikText setTextColor: [UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                [KikText setTextAlignment:NSTextAlignmentLeft];
                [KikText setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [KikText setKeyboardType:UIKeyboardTypeEmailAddress];
                [KikText setDelegate:self];
                [KikText setPlaceholder:@"Kik Messenger"];
                [[cell contentView] addSubview:KikText];
                
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 45, 44)];
                [lbl setBackgroundColor:[UIColor clearColor]];
                [lbl setText:@"كيك:"];
                [lbl setTextColor:[UIColor darkGrayColor]];
                [lbl setTextAlignment:NSTextAlignmentRight];
                [lbl setFont:[UIFont boldSystemFontOfSize:14]];
                [[cell contentView] addSubview:lbl];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }
        else if (indexPath.row==3)
        {
            UITableViewCell *cell = [AddPostTableView dequeueReusableCellWithIdentifier:@"twitterCell"];
            if (!cell)
            {
                cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twitterCell"];
                TwitterText = [[UITextField alloc] initWithFrame:CGRectMake(20, 1, 200, 44)];
                [TwitterText setBackgroundColor:[UIColor clearColor]];
                [TwitterText setTextColor: [UIColor colorWithRed:127.0/255.0 green:128.0/255.0 blue:130.0/255.0 alpha:1]];
                [TwitterText setTextAlignment:NSTextAlignmentLeft];
                [TwitterText setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [TwitterText setDelegate:self];
                [TwitterText setPlaceholder:@"حسابك في تويتر من غير الـ@"];
                [[cell contentView] addSubview:TwitterText];
                
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 45, 44)];
                [lbl setBackgroundColor:[UIColor clearColor]];
                [lbl setText:@"تويتر:"];
                [lbl setTextColor:[UIColor darkGrayColor]];
                [lbl setTextAlignment:NSTextAlignmentRight];
                [lbl setFont:[UIFont boldSystemFontOfSize:14]];
                [[cell contentView] addSubview:lbl];
                
                UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 45, 44)];
                [lbl2 setBackgroundColor:[UIColor clearColor]];
                [lbl2 setText:@"@"];
                [lbl2 setTextColor:[UIColor lightGrayColor]];
                [lbl2 setTextAlignment:NSTextAlignmentLeft];
                [lbl2 setFont:[UIFont boldSystemFontOfSize:14]];
                [[cell contentView] addSubview:lbl2];
                
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }
        
    }
    return nil;
}



// when user select a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    if (indexPath.section==0)
    {
        [self TakePicture];
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            PostType = @"lost";
        }
        else
        {
            PostType = @"found";
        }
        NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:1];
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    }
}


#pragma mark - View Lifecycle
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self resetTableViewMask];
}

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
        label.text = NSLocalizedString(@"اضافة اعلان",@"اضافة اعلان");
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"الغاء" style:UIBarButtonItemStylePlain target:self action:@selector(HideView)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"موافق" style:UIBarButtonItemStylePlain target:self action:@selector(AddPost)];

    detailsPlaceHolder = @"تفاصيل اضافية";

    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.allowsEditing= YES;
    imgPicker.delegate = self;
   imgPicker.navigationBar.tintColor = [UIColor whiteColor];

    image = [UIImage imageNamed:@"placeholder"];
    
    [Flurry logEvent:@"Page: Add Post" timed:YES];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
