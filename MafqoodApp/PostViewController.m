//
//  FirstViewController.m
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 27/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import "PostViewController.h"
#import "OpenUDID.h"
#import "LostAndFoundCell.h"
#import "AddPostViewController.h"
#import "CountryListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LostAndFoundSmallCell.h"
#import "AppDelegate.h"

@interface PostViewController ()

@end

@implementation PostViewController

#pragma mark - AdFalcon

#pragma mark - My Methods
-(NSString *) formattedDateRelativeToNow:(NSDate *)date
{
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:date]];
    
	NSInteger dayDiff = (int)[midnight timeIntervalSinceNow] / (60*60*24);
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
	if(dayDiff == 0)
		[dateFormatter setDateFormat:@"اليوم"];
	else if(dayDiff == -1)
		[dateFormatter setDateFormat:@"بالأمس"];
	else if(dayDiff == -2)
		[dateFormatter setDateFormat:@"يومان"];
	else if(dayDiff == -3)
		[dateFormatter setDateFormat:@"٣ ايام"];
	else if(dayDiff == -4)
		[dateFormatter setDateFormat:@"٤ ايام"];
	else if(dayDiff == -5)
		[dateFormatter setDateFormat:@"٥ ايام"];
	else if(dayDiff == -6)
		[dateFormatter setDateFormat:@"٦ ايام"];
	else if(dayDiff >= -14 && dayDiff <= -7)
		[dateFormatter setDateFormat:@"اسبوع"];
	else if(dayDiff >= -21 && dayDiff < -14)
		[dateFormatter setDateFormat:@"اسبوعان"];
	else if(dayDiff >= -28 && dayDiff < -21)
		[dateFormatter setDateFormat:@"٣ اسابيع"];
	else if(dayDiff >= -90 && dayDiff < -28)
		[dateFormatter setDateFormat:@"شهر"];
	else if(dayDiff >= -180 && dayDiff <-90)
		[dateFormatter setDateFormat:@"٣ اشهر"];
	else if(dayDiff >= -365 && dayDiff <-180)
		[dateFormatter setDateFormat:@"٦ اشهر"];
	else if(dayDiff < -365)
		[dateFormatter setDateFormat:@"سنة"];
    
	return [dateFormatter stringFromDate:date];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelectorOnMainThread:@selector(GetAllPosts) withObject:nil waitUntilDone:NO];
}
-(void)NotificationRecieved
{
    CurrentPage=0;
    [self GetAllPosts];
}
-(void)postAdded
{
    CurrentPage=0;
    [self performSelector:@selector(GetAllPosts) withObject:nil afterDelay:.5];
}
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [HUD removeFromSuperview];
    HUD=nil;
}

-(void)UpdatedCountry
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self GetAllPosts];
}

-(void)ShowSettings
{
    SettingsViewController *set = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:set];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)GetAllPosts
{
    [HUD hide:YES];
    if (CurrentPage==0)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self.navigationController.view addSubview:HUD];
        HUD.dimBackground=NO;
        HUD.delegate = self;
    }

    if (!isUserAuthanticated)
    {
        [self Login];
        return;
    }
    else
        [Flurry setUserID:[OpenUDID value]];

    
    if ([[PFUser currentUser] objectForKey:@"country"] ==nil || [[[PFUser currentUser] objectForKey:@"country"] isEqualToString:@""])
    {
        [HUD hide:YES];
        CountryListViewController *co = [[CountryListViewController alloc] initWithNibName:@"CountryListViewController" bundle:nil];
        co.delegate=self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:co];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }

    if (isGettingDataFromServer)
        return;
    
    isGettingDataFromServer=YES;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.ShowAllCountries==NO)
    {
        [query whereKey:@"country" equalTo:[[PFUser currentUser] objectForKey:@"country"]];
    }
    
    [query whereKey:@"blocked" notEqualTo:[NSNumber numberWithBool:YES]];
    [query orderByDescending:@"createdAt"];
    query.limit=PageSize;
    query.skip = CurrentPage * PageSize;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d Posts.", objects.count);
            [Flurry logEvent:@"Action: Retrieved Posts Successfully"];
            [HUD hide:YES];
            isGettingDataFromServer=NO;
            if (CurrentPage==0)
            {
                PostsArray = [[NSMutableArray alloc] init];
                for (PFObject *obj in objects)
                {
                    PFObject *auth = [obj objectForKey:@"author"];
                    if (![[auth objectForKey:@"blocked"] boolValue]==YES)
                    {
                        [PostsArray addObject:obj];
                    }
                }
                CurrentPage++;
                if (objects.count==0)
                {
                [noLosts.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                    noLosts = [[NoLostsViewController alloc] initWithNibName:@"NoLostsViewController" bundle:nil];
                    [self.view addSubview:noLosts.view];
                }
                else
                    [noLosts.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
            }
            else
            {
                [noLosts.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                
                for (PFObject *obj in objects)
                {
                    PFObject *auth = [obj objectForKey:@"author"];
                    if (![[auth objectForKey:@"blocked"] boolValue]==YES)
                    {
                        [PostsArray addObject:obj];
                    }
                }
                CurrentPage++;
            }
            if (objects.count==0 || objects.count < PageSize)
            {
                ServerHasMoreData = NO;
            }
            else
                ServerHasMoreData=YES;
                
            [PostsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        } else
        {
            // Log details of the failure
            [Flurry logError:@"GettingPosts" message:@"Cannot Get Posts From Server" error:error];
            [HUD hide:YES];
            isGettingDataFromServer=NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"فضلاً تأكد من وجود اتصال بالانترنت!" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)Register
{
    PFUser *user = [PFUser user];
    user.username = [OpenUDID value];
    user.password = [OpenUDID value];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [Flurry logEvent:@"Action: User Registered"];
            [HUD hide:YES];
            NSLog(@"User Registered");
            isUserAuthanticated=YES;
            [self GetAllPosts];
        } else {
//            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"User Registeration Error");
            [Flurry logError:@"RegisteringUser" message:@"Cannot Register User" error:error];
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ" message:@"فضلاً تأكد من وجود اتصال بالانترنت!" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
            [alert show];
            return ;
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

-(void)AddPost
{
    NSLog(@"Add Post");
    AddPostViewController *AddPost = [[AddPostViewController alloc] initWithNibName:@"AddPostViewController" bundle:nil];
    AddPost.delegate=self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:AddPost];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)Login
{
    NSLog(@"%@",[OpenUDID value]);
    [PFUser logInWithUsernameInBackground:[OpenUDID value] password:[OpenUDID value]
                                    block:^(PFUser *user, NSError *error) {
                                        if (user)
                                        {
                                            [Flurry logEvent:@"Action: User Logged ID"];
                                            [HUD hide:YES];
                                            NSLog(@"User Loged in");
                                            isUserAuthanticated=YES;
                                            [self GetAllPosts];
                                        } else {
                                            NSLog(@"Signing Up A user");
                                            [self Register];
                                            // The login failed. Check error to see why.
                                        }
                                    }];
}


#pragma mark - UiTableView

// this is used to hide the empty extra cells from the stupid table view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self numberOfSectionsInTableView:tableView] == (section+1))
    {
        return [UIView new];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==PostsArray.count)
    {
        return 44;
    }
    else
    {
        PFObject *post = [PostsArray objectAtIndex:indexPath.section];
        if ([[post objectForKey:@"hasimage"] boolValue] == YES)
        {
            NSLog(@"has Image height");
            return 367;
        }
    }
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (ServerHasMoreData && PostsArray.count!=0)
    {
        return PostsArray.count+1;
    }
    return PostsArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // Check if this is the load more cell
    if(indexPath.section==PostsArray.count)
    {
        UITableViewCell *ld = [PostsTableView dequeueReusableCellWithIdentifier:@"LoadMore"];
        if (!ld)
        {
            ld = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadMore"];
        }
        ld.textLabel.text=@"المزيـــــد...";
        ld.textLabel.textAlignment = NSTextAlignmentCenter;
        ld.textLabel.font = [UIFont boldSystemFontOfSize:14];
        ld.textLabel.textColor = [UIColor lightGrayColor];
        ld.textLabel.backgroundColor = [UIColor clearColor];
        [ld setSelectionStyle:UITableViewCellSelectionStyleGray];
        ld.tag=1;
        
        // set cell background image
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        ld.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SmallCell"]];
//        cell.BackgroundImage.image = [UIImage imageNamed:@"SmallCell"];
        
        return ld;
    }
    
    
    PFObject *post = [PostsArray objectAtIndex:indexPath.section];
    BOOL hasImage=NO;
    
    if ([[post objectForKey:@"hasimage"] boolValue] == YES)
    {
        NSLog(@"Has Image");
        hasImage=YES;
    }
   
    if (hasImage)
    {
        LostAndFoundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LostAndFoundCell"];
        if (cell == nil)
        {
            // Create a temporary UIViewController to instantiate the custom cell.
            UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:@"LostAndFoundCell" bundle:nil];
            // Grab a pointer to the custom cell.
            cell = (LostAndFoundCell *)temporaryController.view;
        }
        
        if (cell.contentView.subviews.count==7)
        {
            [[cell.contentView.subviews objectAtIndex:5] removeFromSuperview];
        }
        
        // set cell background image
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
        cell.BackgroundImage.image = [UIImage imageNamed:@"BigCell"];
        
        PFImageView *creature = [[PFImageView alloc] initWithFrame:CGRectMake(20, 14, 280, 280)];
        [creature setContentMode:UIViewContentModeScaleAspectFit];
        creature.image = [UIImage imageNamed:@"placeholder"]; // placeholder image
        PFFile *file = [post objectForKey:@"image"];
        creature.file = (PFFile *)file;
        [creature loadInBackground];
        [cell.contentView insertSubview:creature belowSubview:cell.Type];
        
        if ([[post objectForKey:@"type"] isEqualToString:@"lost"])
        {
            cell.Type.image = [UIImage imageNamed:@"LostFlag"];
        }
        else
        {
            cell.Type.image = [UIImage imageNamed:@"FoundFlag"];
        }
        
        cell.Date.text = [self formattedDateRelativeToNow:post.createdAt];
        cell.Title.text=[post objectForKey:@"title"];
        cell.Location.text = [post objectForKey:@"location"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }

    LostAndFoundSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LostAndFoundSmallCell"];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:@"LostAndFoundSmallCell" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (LostAndFoundSmallCell *)temporaryController.view;
    }

    if ([[post objectForKey:@"type"] isEqualToString:@"lost"])
    {
        cell.Type.image = [UIImage imageNamed:@"LostFlag"];
    }
    else
    {
        cell.Type.image = [UIImage imageNamed:@"FoundFlag"];
    }
    
    // set cell background image
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    cell.BackgroundImage.image = [UIImage imageNamed:@"SmallCell"];
    
    
    cell.Date.text = [self formattedDateRelativeToNow:post.createdAt];
    cell.Title.text=[post objectForKey:@"title"];
    cell.Location.text = [post objectForKey:@"location"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}

// when user select a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==PostsArray.count)
    {
        UITableViewCell *cell = [PostsTableView cellForRowAtIndexPath:indexPath];
        if (cell.tag==0)
        {
            cell=nil;
            return;
        }
        cell.textLabel.text=@"";
        UIActivityIndicatorView *act=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
        [act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [act startAnimating];
        [cell.contentView addSubview:act];
        cell.tag= 0;
        [PostsTableView deselectRowAtIndexPath: indexPath animated:YES];
        [self GetAllPosts];
    }
    else
    {
        [PostsTableView deselectRowAtIndexPath:indexPath animated:YES];
        ItemDetailsViewController *v = [[ItemDetailsViewController alloc] initWithNibName:@"ItemDetailsViewController" bundle:nil];
        v.Item = [PostsArray objectAtIndex:indexPath.section];
        [self.navigationController pushViewController:v animated:YES];
    }
}


#pragma mark - View LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"المفقودات";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // INitializing Variables
    PostsArray = [[NSMutableArray alloc] init];
    CurrentPage=0;
    ServerHasMoreData = YES;
    isUserAuthanticated=NO;
    isGettingDataFromServer=NO;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barLogo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"اعدادات" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSettings)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"اضافة" style:UIBarButtonItemStylePlain target:self action:@selector(AddPost)];

    
    
    // Calling Initial Methods
    [self GetAllPosts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationRecieved) name:@"RefreshTheData" object:nil];
    
    [Flurry logEvent:@"Page: PostView" timed:YES];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"memory!");
    // Dispose of any resources that can be recreated.
}

@end
