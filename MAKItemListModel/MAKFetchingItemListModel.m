//
//  MAKFetchingItemListModel.m
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 11.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKFetchingItemListModel-Protected.h"

#import "NSMutableArray+Helper.h"


@implementation MAKFetchingItemListModel

- (void) dealloc
{
    [self cancelRequest];
}


#pragma mark - Loading additional information

- (NSArray *)allLoadingItems
{
    return [NSArray arrayWithArray:self.loadingItems];
}

- (NSUInteger)numberOfLoadingItems
{
    return self.loadingItems.count;
}

- (BOOL)loadingStateForItem:(id)item
{
    return [self.loadingItems containsObject:item];
}

- (BOOL)setLoadingStateForItem:(id)item loadingState:(BOOL)loading
{
    if (loading)
    {
        BOOL changed = [self.loadingItems addObject:item allowDuplicates:NO];
        
        if (changed)
            if ([self.delegates respondsToSelector:@selector(itemListModel:didChangeLoadingStateAtIndexPaths:)])
                [self.delegates itemListModel:self didChangeLoadingStateAtIndexPaths:@[[self indexPathOfItem:item]]];
        
        return changed;
    }
    else
    {
        if ([self.loadingItems containsObject:item])
        {
            [self.loadingItems removeObject:item];
            
            NSIndexPath *indexPath = [self indexPathOfItem:item];
            
            if (indexPath && [self.delegates respondsToSelector:@selector(itemListModel:didChangeLoadingStateAtIndexPaths:)])
                [self.delegates itemListModel:self didChangeLoadingStateAtIndexPaths:@[indexPath]];
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
}


#pragma mark - Load and update handling

- (BOOL)updateItems
{
    if (!self.sections.count)
        return [self reloadItems];
    return NO;
}

- (BOOL)reloadItems
{
    // implement this in subclass
    return NO;
}

- (BOOL)loadMoreItems
{
    // implement this in subclass
    return NO;
}

- (void)cancelRequest
{
    // implement this in subclass
}


#pragma mark - Item editing
#pragma mark - Remove items

- (void)removeItem:(id)item completion:(void (^)(BOOL success))completionBlock
{
    BOOL success = [super removeItem:item];
    
    if (completionBlock) completionBlock(success);
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(BOOL success))completionBlock
{
    BOOL success = [super removeItemAtIndexPath:indexPath];
    
    if (completionBlock) completionBlock(success);
}

#pragma mark - Remove items (overridden methods)

- (BOOL)removeItemAtIndexPath:(NSIndexPath *)indexPath notifyDelegate:(BOOL)notifyDelegate
{
    id item = [self itemAtIndexPath:indexPath];
    
    BOOL success = [super removeItemAtIndexPath:indexPath notifyDelegate:notifyDelegate];
    
    if (success)
    {
        if ([_loadingItems containsObject:item])
            [_loadingItems removeObject:item];
    }
    
    return success;
}

- (BOOL)removeAllItemsInSection:(NSUInteger)sectionIndex notifyDelegate:(BOOL)notifyDelegate
{
    NSMutableArray *section = [self sectionAtIndex:sectionIndex];
    
    BOOL success = [super removeAllItemsInSection:sectionIndex notifyDelegate:notifyDelegate];
    
    if (success)
    {
        for (id item in section)
        {
            if ([_loadingItems containsObject:item])
                [_loadingItems removeObject:item];
        }
    }
    
    return success;
}

- (BOOL)removeSectionAtIndex:(NSUInteger)index notifyDelegate:(BOOL)notifyDelegate
{
   NSMutableArray *section = self.sections[index];
    
    BOOL success = [super removeSectionAtIndex:index notifyDelegate:notifyDelegate];
    
    if (success)
    {
        for (id item in section)
        {
            if ([_loadingItems containsObject:item])
                [_loadingItems removeObject:item];
        }
    }
    
    return success;
}

- (BOOL)removeAllSectionsAndNotifyDelegate:(BOOL)notifyDelegate
{
    BOOL success = [super removeAllSectionsAndNotifyDelegate:notifyDelegate];
    if (success)
        [_loadingItems removeAllObjects];
}


#pragma mark - Private Setter

- (void)setLoading:(BOOL)loading
{
    BOOL loadingStateDidChange = self.isLoading != loading;
    
    _loading = loading;
    
    if (loadingStateDidChange)
    {
        if (loading && [self.delegates respondsToSelector:@selector(itemListModelDidStartLoading:)])
            [self.delegates itemListModelDidStartLoading:self];
        else if (!loading && [self.delegates respondsToSelector:@selector(itemListModelDidStopLoading:)])
            [self.delegates itemListModelDidStopLoading:self];
    }
}


#pragma mark - Getter / Lazy instantiation

- (NSMutableArray *)loadingItems
{
    if (!_loadingItems)
    {
        _loadingItems = [NSMutableArray new];
    }
    return _loadingItems;
}

@end
