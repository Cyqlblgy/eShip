//
//  BLCoreData.h
//  eShip
//
//  Created by Bin Lang on 5/21/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BLCoreData : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BLCoreData *)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
