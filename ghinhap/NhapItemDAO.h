//
//  NhapItemDAO.h
//  ghinhap
//
//  Created by Quang Phuong on 7/20/15.
//  Copyright © 2015 fsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NhapItem.h"
#import "AppDelegate.h"

@interface NhapItemDAO : NSObject

- (NSMutableArray *)getFirstData;

- (NSMutableArray *)getAllData;

- (void)addItem: (NhapItem *) item;

- (void)removeItem: (NhapItem *) item;

@end
