//
//  MAKItemListChanges.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 12.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAKItemChange.h"


@interface MAKItemListChanges : NSObject

@property (nonatomic, strong) NSArray *addedItems;

@property (nonatomic, strong) NSArray *movedItems;

@property (nonatomic, strong) NSArray *updatedItems;

@property (nonatomic, strong) NSArray *removedItems;


- (NSArray *)indexPathsOfAddedItems;
- (NSArray *)indexPathsOfUpdatedItems;
- (NSArray *)indexPathsOfRemovedItems;


+ (MAKItemListChanges *)itemListChangesWithAddedItems:(NSArray *)addedItems;
+ (MAKItemListChanges *)itemListChangesWithUpdatedItems:(NSArray *)updatedItems;
+ (MAKItemListChanges *)itemListChangesWithRemovedItems:(NSArray *)removedItems;

+ (MAKItemListChanges *)itemListChangesWithAddedItems:(NSArray *)addedItems
                                           movedItems:(NSArray *)movedItems
                                         updatedItems:(NSArray *)updatedItems
                                         removedItems:(NSArray *)removedItems;

@end
