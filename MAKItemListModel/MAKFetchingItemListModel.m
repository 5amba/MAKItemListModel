//
//  MAKFetchingItemListModel.m
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 11.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKFetchingItemListModel.h"
#import "MAKFetchingItemListModel-Protected.h"

#import "NSMutableArray+Helper.h"


@implementation MAKFetchingItemListModel

- (void) dealloc
{
    [self cancelRequest];
}

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        self.loadingItems = [NSMutableArray new];
    }
    return self;
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
            if ([self.delegate respondsToSelector:@selector(model:didChangeLoadingStateAtIndexPaths:)])
                [self.delegate model:self didChangeLoadingStateAtIndexPaths:@[[self indexPathOfItem:item]]];
        
        return changed;
    }
    else
    {
        if ([self.loadingItems containsObject:item])
        {
            [self.loadingItems removeObject:item];
            
            if ([self.delegate respondsToSelector:@selector(model:didChangeLoadingStateAtIndexPaths:)])
                [self.delegate model:self didChangeLoadingStateAtIndexPaths:@[[self indexPathOfItem:item]]];
            
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

@end
