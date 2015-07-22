//
//  FirstViewController.m
//  ghinhap
//
//  Created by Quang Phuong on 7/20/15.
//  Copyright © 2015 fsoft. All rights reserved.
//

#import "FirstViewController.h"
#import "NhapItem.h"
#import "NhapItemDAO.h"
#import "ViewController.h"

@interface FirstViewController (){
    UITextField *nhapHomeName;
    UIButton *createButton;
}

- (void)addToNhapList:(NSString *)homeNhap;

@end

@implementation FirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nhapHomeName = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    nhapHomeName.center = self.view.center;
    
    nhapHomeName.borderStyle = UITextBorderStyleRoundedRect;
    nhapHomeName.font = [UIFont systemFontOfSize:15];
    nhapHomeName.autocorrectionType = UITextAutocorrectionTypeNo;
    nhapHomeName.keyboardType = UIKeyboardTypeDefault;
    nhapHomeName.returnKeyType = UIReturnKeyDone;
    nhapHomeName.clearButtonMode = UITextFieldViewModeWhileEditing;
    nhapHomeName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nhapHomeName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:nhapHomeName];
    
    nhapHomeName.delegate = self;
    
//    CGRect buttonFrame = nhapHomeName.frame;
//    createButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    createButton.frame = CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y + 30, buttonFrame.size.width, buttonFrame.size.height);
//    [createButton setTitle:@"Đi tới nháp!" forState:UIControlStateNormal];
//    [createButton setTintColor:[UIColor blackColor]];
//    [self.view addSubview:createButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self addToNhapList:nhapHomeName.text];
    
    [self performSegueWithIdentifier:@"homeView" sender:self];
    
    return YES;
}

- (void)addToNhapList:(NSString *)homeNhap{
    NSDate *today = [NSDate date];
    NhapItem *item = [[NhapItem alloc]initWithName:homeNhap createDate:today isLocal:YES owner:@"User"];
    NhapItemDAO *dao = [[NhapItemDAO alloc]init];
    [dao addItem:item];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.view endEditing:YES];
    if([segue.identifier isEqualToString:@"homeView"]){
//        ViewController *homeView = segue.destinationViewController;
//        [homeView setHomeNhap:nhapHomeName.text];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
