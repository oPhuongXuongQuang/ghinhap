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
    SCNetworkReachabilityRef _netReachRef;
}

- (void)addToNhapList:(NSString *)newNhap;

- (void)updateBadge;

@end

@implementation ViewController


@synthesize toolBar;
@synthesize navToolBar;
@synthesize nhapName;
@synthesize shareButton;
@synthesize menuButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userName = @"User";
    
    //Add sidebar effect
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [menuButton setTarget: self.revealViewController];
        [menuButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSString *fullURL = @"http://ghinhap.com/test";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    _webView = [[UIWebView alloc] init];
    [_webView loadRequest:requestObj];
    _webView.frame = CGRectMake(screenBound.origin.x, screenBound.origin.y + 60, screenBound.size.width, screenBound.size.height);
    
    [_webView setUserInteractionEnabled: YES];
    
    [self.view addSubview:_webView];
    
    [self.view addSubview:toolBar];
    [self.view addSubview:navToolBar];
    
    [nhapName setText:@"test"];
    
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
    shareButton.enabled = NO;
    return YES;
}

- (BOOL)nhapNameEndActive{
    [nhapName setTextAlignment:NSTextAlignmentCenter];
    shareButton.enabled = YES;
    if(nhapName.text.length == 0){
        [nhapName setText:@"test"];
    }
    return NO;
}

- (void)keyboardWillShow:(NSNotification*)aNotification{
    
}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    
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
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Is this my Alert View?
    if (alertView.tag == 1) {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
            NSString *newNhap = [[alertView textFieldAtIndex:0]text];
            [self reloadWebviewWithNewNhap:newNhap];
            nhapName.text = newNhap;
            [self addToNhapList:newNhap];
            [self updateBadge];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSidebarView" object:nil userInfo:nil];
        }
        else {
            
        }
    }
    else { //Other Alert
        
    }
}

- (void)reloadWebviewWithNewNhap:(NSString*)newNhap{
    NSString *fullURL = @"http://ghinhap.com/";
    [fullURL stringByAppendingString:newNhap];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:requestObj];
//    [_webView reload];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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

