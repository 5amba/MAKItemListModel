//
//  MAKItemListChanges.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 12.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAKSectionChange.h"
#import "MAKItemChange.h"


@interface MAKItemListChanges : NSObject

@property (nonatomic, strong) NSArray *addedSections;

@property (nonatomic, strong) NSArray *movedSections;

@property (nonatomic, strong) NSArray *updatedSections;

@property (nonatomic, strong) NSArray *removedSections;

@property (nonatomic, strong) NSArray *addedItems;

@property (nonatomic, strong) NSArray *movedItems;

@property (nonatomic, strong) NSArray *updatedItems;

@property (nonatomic, strong) NSArray *removedItems;


- (NSIndexSet *)indexSetOfAddedSections;
- (NSIndexSet *)indexSetOfUpdatedSections;
- (NSIndexSet *)indexSetOfRemovedSections;

- (NSArray *)indexPathsOfAddedItems;
- (NSArray *)indexPathsOfUpdatedItems;
- (NSArray *)indexPathsOfRemovedItems;

+ (MAKItemListChanges *)itemListChangesWithAddedSections:(NSArray *)addedSections;
+ (MAKItemListChanges *)itemListChangesWithUpdatedSections:(NSArray *)updatedSections;
+ (MAKItemListChanges *)itemListChangesWithRemovedSections:(NSArray *)removedSections;

+ (MAKItemListChanges *)itemListChangesWithAddedItems:(NSArray *)addedItems;
+ (MAKItemListChanges *)itemListChangesWithUpdatedItems:(NSArray *)updatedItems;
+ (MAKItemListChanges *)itemListChangesWithRemovedItems:(NSArray *)removedItems;

+ (MAKItemListChanges *)itemListChangesWithAddedItems:(NSArray *)addedItems
                                           movedItems:(NSArray *)movedItems
                                         updatedItems:(NSArray *)updatedItems
                                         removedItems:(NSArray *)removedItems;

@end
