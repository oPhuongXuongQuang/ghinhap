//
//  NhapItemDAO.m
//  ghinhap
//
//  Created by Quang Phuong on 7/20/15.
//  Copyright © 2015 fsoft. All rights reserved.
//

#import "NhapItemDAO.h"
@import CoreData;

@interface NhapItemDAO()

- (NSManagedObjectContext *)managedObjectContext;

@end

@implementation NhapItemDAO

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }    
    return context;
}

- (NSMutableArray *)getFirstData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Nhap"];
    [request setFetchLimit:1];
    return [[context executeFetchRequest:request error:nil] mutableCopy];
}

- (NSMutableArray *)getAllData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Nhap"];
    return [[context executeFetchRequest:request error:nil] mutableCopy];
}

- (void)addItem: (NhapItem *) item
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObjectModel *managedObjectModel =
    [[context persistentStoreCoordinator] managedObjectModel];
    NSEntityDescription *entity =
    [[managedObjectModel entitiesByName] objectForKey:@"Nhap"];
    NSManagedObject *newNhap = [[NSManagedObject alloc]
                                  initWithEntity:entity insertIntoManagedObjectContext:context];
    
    [newNhap setValue:item.name forKey:@"name"];
    [newNhap setValue:item.createDate forKey:@"createDate"];
    [newNhap setValue:[NSNumber numberWithBool:item.isLocal] forKey:@"isLocal"];
    [newNhap setValue:item.owner forKey:@"owner"];
    
    NSError *error = nil;
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void)removeItem: (NhapItem *) item
{
    
}

- (BOOL)isNhapExist: (NSString *) nhapToCheck
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Nhap"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",nhapToCheck];
    [request setPredicate:predicate];
    NSMutableArray *result = [[context executeFetchRequest:request error:nil] mutableCopy];
    if(result.count != 0){
        return YES;
    }
    return NO;
}

@end
