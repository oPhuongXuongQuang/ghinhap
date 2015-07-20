//
//  NhapItem.h
//  ghinhap
//
//  Created by Quang Phuong on 7/20/15.
//  Copyright © 2015 fsoft. All rights reserved.
//

#ifndef NhapItem_h
#define NhapItem_h


@interface NhapItem : NSObject

@property NSString *name;
@property NSDate *createDate;
@property BOOL isLocal;
@property NSString *owner;


- (id)initWithName:(NSString *)aName createDate:(NSDate *)aCreateDate isLocal:(BOOL)aIsLocal owner:(NSString *)aOwner;

@end

#endif /* NhapItem_h */
