//
//  CountryListViewController.m
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 30/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import "CountryListViewController.h"

@interface CountryListViewController ()

@end

@implementation CountryListViewController
@synthesize delegate;

#pragma mark - My Methods
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    HUD=nil;
    [HUD removeFromSuperview];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self.navigationController.view addSubview:HUD];
        HUD.dimBackground=NO;
        HUD.delegate = self;
        
        PFObject *obj = [PFUser currentUser];
        [obj setObject:selectedCountryCode forKey:@"country"];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (!error)
            {
                [HUD hide:YES];
                [[self delegate] UpdatedCountry];
            }
            else
            {
                [HUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"عفواً، حدث خطاً" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
            }
        }];
    }
}

-(void)UpdateUserCity
{
    if (selectedCountryCode==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"فضلاً قم باختيار دولتك!" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"%@\n%@\n\n%@",@"جميع المفقودات التي ستعلن عنها سيتم وضعها تحت قسم",[countryNamesByCode objectForKey:selectedCountryCode],@"يمكنك تغيير بياناتك من خلال اعدادات التطبيق"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    alert.tag=1;
    alert.delegate=self;
    [alert show];
}

#pragma mark - UiTableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return countryNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;//= [CountryList dequeueReusableCellWithIdentifier:@"CountryCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CountryCell"];
    }
    cell.textLabel.text = [countryNames objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[countryCodes objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    if (selectedCountryCode!=nil)
    {
        if ([selectedCountryCode isEqualToString:[countryCodes objectAtIndex:indexPath.row]])
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [cell setTintColor:[UIColor colorWithRed:40.0/255.0 green:153.0/255.0 blue:147.0/255.0 alpha:1]];
        }
    }
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    
    return cell;
}

// when user select a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CountryList deselectRowAtIndexPath:indexPath animated:YES];
    selectedCountryCode = [countryCodes objectAtIndex:indexPath.row];
    [CountryList reloadData];
}

#pragma mark - View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:18.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"اختر دولتك", @"اختر دولتك");
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


//    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        [self setEdgesForExtendedLayout:UIRectEdgeBottom];

    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"];
    countryNamesByCode = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
    for (NSString *code in [countryNamesByCode allKeys])
    {
        [codesByName setObject:code forKey:[countryNamesByCode objectForKey:code]];
    }
    countryCodesByName = [codesByName copy];
    
    NSArray *names = [countryNamesByCode allValues];
    countryNames = [names sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableArray *codes = [NSMutableArray arrayWithCapacity:[names count]];
    for (NSString *name in countryNames)
    {
        [codes addObject:[countryCodesByName objectForKey:name]];
    }
    countryCodes = [codes copy];
    
//    self.navigationItem.title = @"اختر دولتك";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"موافق" style:UIBarButtonItemStylePlain target:self action:@selector(UpdateUserCity)];

    [Flurry logEvent:@"Page: Update Country" timed:YES];
    
    if ([[PFUser currentUser] isAuthenticated])
    {
        selectedCountryCode = [[PFUser currentUser] objectForKey:@"country"];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
