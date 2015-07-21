//
//  ViewController.h
//  ghinhap
//
//  Created by quangpx on 7/10/15.
//  Copyright (c) 2015 fsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>{
    NSString *userName;
}

@property (nonatomic, strong) NSString *currentNhap;
@property (nonatomic, strong) NSString *homeNhap;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIToolbar *navToolBar;
@property (weak, nonatomic) IBOutlet UITextField *nhapName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

- (IBAction)addNewNhap:(id)sender;

@end

