//
//  ViewController.m
//  ghinhap
//
//  Created by quangpx on 7/10/15.
//  Copyright (c) 2015 fsoft. All rights reserved.
//

#import "ViewController.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "UIBarButtonItem+Badge.h"
#import "SWRevealViewController.h"
#import "NhapItem.h"
#import "NhapItemDAO.h"
#import "SidebarViewController.h"

@interface ViewController(){
    UIWebView* _webView;
    UIBarButtonItem *cancelButton;
}

- (NSString *)getHomeNhap;

- (BOOL)isNhapExist:(NSString *)nhapToCheck;

- (void)addNewAndReload:(NSString *)newNhap;

- (void)addToNhapList:(NSString *)newNhap;

- (void)cancelAction;

- (void)updateBadge;

@end

@implementation ViewController

@synthesize toolBar;
@synthesize navToolBar;
@synthesize nhapName;
@synthesize shareButton;
@synthesize menuButton;
@synthesize homeNhap;
@synthesize currentNhap;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userName = @"User";
    cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
//    [cancelButton setTintColor:[UIColor clearColor]];
//    cancelButton.accessibilityFrame = CGRectMake(0, 0, 0, 0);
    
    //Add sidebar effect
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [menuButton setTarget: self.revealViewController];
        [menuButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    NSString *fullURL = @"http://ghinhap.com/";
    NSURL *url = nil;
    
    // Get home nhap from user's first input
    homeNhap = [self getHomeNhap];
    [nhapName setTag:0];
    [nhapName setDelegate:self];
    url = [NSURL URLWithString:[fullURL stringByAppendingString:homeNhap]];
    NSString *cacheFile = [homeNhap stringByAppendingString:@".htm"];
    if (currentNhap.length != 0) {
        // Get current Nhap
        url = [NSURL URLWithString:[fullURL stringByAppendingString:currentNhap]];
        cacheFile = [currentNhap stringByAppendingString:@".htm"];
        [nhapName setText:currentNhap];
    } else {
        [nhapName setText:homeNhap];
    }
    _webView = [[UIWebView alloc] init];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],cacheFile];
    NSURLRequest *requestObj;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        requestObj = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
        NSData *responseData = [NSURLConnection sendSynchronousRequest: requestObj
                                             returningResponse:nil
                                                         error: nil];
        NSString *htmlBody = [[NSString alloc] initWithData:responseData
                                                   encoding:NSUTF8StringEncoding];
        [_webView loadHTMLString:htmlBody baseURL:url];
//        [_webView loadData:responseData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:url];
    } else {
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        [urlData writeToFile:filePath atomically:YES];
        requestObj = [NSURLRequest requestWithURL:url];
        
        [_webView loadRequest:requestObj];
        
    }
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    _webView.frame = CGRectMake(screenBound.origin.x, screenBound.origin.y + 60, screenBound.size.width, screenBound.size.height);
    
    [_webView setUserInteractionEnabled: YES];
    
    [self.view addSubview:_webView];
    
    [self.view addSubview:toolBar];
    [self.view addSubview:navToolBar];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(toggleSaveButton)
//                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [nhapName addTarget:nil action:@selector(nhapNameActive) forControlEvents:UIControlEventEditingDidBegin];
    [nhapName addTarget:nil action:@selector(nhapNameEndActive) forControlEvents:UIControlEventEditingDidEnd];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetBadge:) name:@"ResetBadge" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_webView reload];
}

- (void)viewWillAppear:(BOOL)animated{
    [self addKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self removeKeyboardNotifications];
}

//call this from viewWillAppear
-(void)addKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//call this from viewWillDisappear
- (void)removeKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)toggleSaveButton {
    
}

- (BOOL)nhapNameActive{
    [nhapName setTextAlignment:NSTextAlignmentLeft];
    [shareButton setStyle:UIBarButtonItemStylePlain];
    [shareButton setTitle:@"Cancel"];
    return YES;
}

- (void)cancelAction{
    [nhapName resignFirstResponder];
}

- (BOOL)nhapNameEndActive{
    [nhapName setTextAlignment:NSTextAlignmentCenter];
    shareButton.enabled = YES;
    if(nhapName.text.length == 0){
        [nhapName setText:homeNhap];
    }
    return NO;
}

- (void)keyboardWillShow:(NSNotification*)aNotification{
    
}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    
}

- (NSString *)getHomeNhap
{
    NhapItemDAO *dao = [[NhapItemDAO alloc]init];
    
    NSMutableArray *data = [dao getFirstData];
    NhapItem *firstData = [data objectAtIndex:0];
    return firstData.name;
}

- (IBAction)addNewNhap:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Enter your Nhap"
                                                   delegate:self
                                          cancelButtonTitle:@"Go"
                                          otherButtonTitles:@"Cancel",nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alert.tag = 1;
    [alert show];
    [[alert textFieldAtIndex:0] setReturnKeyType:UIReturnKeyDone];
    [[alert textFieldAtIndex:0] setDelegate:self];
    [[alert textFieldAtIndex:0] setTag:1];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Is this my Alert View?
    if (alertView.tag == 1) {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
            NSString *newNhap = [[alertView textFieldAtIndex:0]text];
            [self addNewAndReload:newNhap];
        }
        else {
            
        }
    }
    else { //Other Alert
        
    }
}

- (void)addNewAndReload:(NSString *)newNhap{
    if([newNhap stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
    {
        nhapName.text = newNhap;
        [self reloadWebviewWithNewNhap:newNhap];
        if(![self isNhapExist:newNhap])
        {
            [self addToNhapList:newNhap];
            [self updateBadge];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSidebarView" object:nil userInfo:nil];
        }
    }
}

- (void)reloadWebviewWithNewNhap:(NSString*)newNhap{
    NSString *fullURL = @"http://ghinhap.com/";
    fullURL = [fullURL stringByAppendingString:newNhap];
    NSURL *url = [NSURL URLWithString:fullURL];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:requestObj];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        [textField resignFirstResponder];
    }
    else if(textField.tag == 0){
        [textField resignFirstResponder];
        [self addNewAndReload:textField.text];
    }
    return YES;
}

- (BOOL)isNhapExist:(NSString *)nhapToCheck{
    NhapItemDAO *dao = [[NhapItemDAO alloc]init];
    return [dao isNhapExist:nhapToCheck];
}

- (void)addToNhapList:(NSString *)newNhap{
    NSDate *today = [NSDate date];
    NhapItem *item = [[NhapItem alloc]initWithName:newNhap createDate:today isLocal:YES owner:userName];
    NhapItemDAO *dao = [[NhapItemDAO alloc]init];
    [dao addItem:item];
}

- (void)resetBadge:(NSNotification *)notification
{
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [menuButton setBadgeValue:0];
    [UIView commitAnimations];
}

- (void)updateBadge
{
    int badgeNumber = [menuButton.badgeValue intValue];
    badgeNumber++;
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    menuButton.badgeValue = [NSString stringWithFormat:@"%d",badgeNumber];
    menuButton.badgeBGColor = [UIColor redColor];
    menuButton.badgeOriginX = 20;
    [UIView commitAnimations];
}

@end

