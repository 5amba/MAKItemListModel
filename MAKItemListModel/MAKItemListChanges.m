//
//  MAKItemListChanges.m
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 12.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKItemListChanges.h"

@implementation MAKItemListChanges

#pragma mark - Public helper methods

- (NSArray *)indexPathsOfAddedItems
{
    if (![self.addedItems isKindOfClass:[NSArray class]] || self.addedItems.count == 0)
        return nil;
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    
    for (MAKItemChange *itemChange in self.addedItems)
    {
        if (itemChange.toIndexPath)
            [indexPaths addObject:itemChange.toIndexPath];
    }
    
    return indexPaths.count ? [NSArray arrayWithArray:indexPaths] : nil;
}

- (NSArray *)indexPathsOfUpdatedItems
{
    if (![self.updatedItems isKindOfClass:[NSArray class]] || self.updatedItems.count == 0)
        return nil;
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    
    for (MAKItemChange *itemChange in self.updatedItems)
    {
        if (itemChange.fromIndexPath)
            [indexPaths addObject:itemChange.fromIndexPath];
        else if (itemChange.toIndexPath)
            [indexPaths addObject:itemChange.toIndexPath];
    }
    
    return indexPaths.count ? [NSArray arrayWithArray:indexPaths] : nil;
}

- (NSArray *)indexPathsOfRemovedItems
{
    if (![self.removedItems isKindOfClass:[NSArray class]] || self.removedItems.count == 0)
        return nil;
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    
    for (MAKItemChange *itemChange in self.removedItems)
    {
        if (itemChange.fromIndexPath)
            [indexPaths addObject:itemChange.fromIndexPath];
    }
    
    return indexPaths.count ? [NSArray arrayWithArray:indexPaths] : nil;
}

#pragma mark - Class methods

+ (MAKItemListChanges *)itemListChangesWithAddedItems:(NSArray *)addedItems
{
    if (addedItems && ![addedItems isKindOfClass:[NSArray class]])
        return nil;
    
    MAKItemListChanges *itemListChanges = [MAKItemListChanges new];
    itemListChanges.addedItems = addedItems;
    return itemListChanges;
}

+ (MAKItemListChanges *)itemListChangesWithUpdatedItems:(NSArray *)updatedItems
{
    if (updatedItems && ![updatedItems isKindOfClass:[NSArray class]])
        return nil;
    
    MAKItemListChanges *itemListChanges = [MAKItemListChanges new];
    itemListChanges.updatedItems = updatedItems;
    return itemListChanges;
}

+ (MAKItemListChanges *)itemListChangesWithRemovedItems:(NSArray *)removedItems
{
    if (removedItems && ![removedItems isKindOfClass:[NSArray class]])
        return nil;
    
    MAKItemListChanges *itemListChanges = [MAKItemListChanges new];
    itemListChanges.removedItems = removedItems;
    return itemListChanges;
}


+ (MAKItemListChanges *)itemListChangesWithAddedItems:(NSArray *)addedItems
                                           movedItems:(NSArray *)movedItems
                                         updatedItems:(NSArray *)updatedItems
                                         removedItems:(NSArray *)removedItems
{
    if ((addedItems && ![addedItems isKindOfClass:[NSArray class]]) ||
        (movedItems && ![movedItems isKindOfClass:[NSArray class]]) ||
        (updatedItems && ![updatedItems isKindOfClass:[NSArray class]]) ||
        (removedItems && ![removedItems isKindOfClass:[NSArray class]]))
        return nil;
    
    MAKItemListChanges *itemListChanges = [MAKItemListChanges new];
    itemListChanges.addedItems = addedItems;
    itemListChanges.movedItems = movedItems;
    itemListChanges.updatedItems = updatedItems;
    itemListChanges.removedItems = removedItems;
    return itemListChanges;
}


@end
