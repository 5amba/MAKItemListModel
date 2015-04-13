//
//  MAKFetchingItemListModel.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 11.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKBaseItemListModel.h"


typedef NS_ENUM(NSUInteger, MAKLoadingType)
{
    MAKLoadingTypeNone,
    MAKLoadingTypeReload,
    MAKLoadingTypeAppend,
    MAKLoadingTypeUpdate
};


@class MAKFetchingItemListModel;


@protocol MAKFetchingItemListModelDelegate <MAKBaseItemListModelDelegate>

@optional
/** The model did start loading.
 @param model The model.
 */
- (void)modelDidStartLoading:(MAKFetchingItemListModel *)model;

/** The model did finisch loading.
 @param model The model.
 @param anythingChanged A Boolean value indicating whether anything has changed in the item list.
 */
- (void)modelDidFinishLoading:(MAKFetchingItemListModel *)model anythingChanged:(BOOL)anythingChanged;

/** The loading did fail with an error.
 @param model The model.
 @param error The specified error.
 */
- (void)model:(MAKFetchingItemListModel*)model loadingDidFailWithError:(NSError *)error;

- (void)model:(MAKFetchingItemListModel *)model didChangeLoadingStateAtIndexPaths:(NSArray *)indexPaths;

- (void)model:(MAKFetchingItemListModel *)model didChangeLoadingStateAtIndexPaths:(NSArray *)indexPaths;

@end


@interface MAKFetchingItemListModel : MAKBaseItemListModel

/** Register as delegate to get informed about current loading state, errors, etc.
 @see MAKFetchingItemListModelDelegate
 */
@property (nonatomic, weak) id<MAKFetchingItemListModelDelegate> delegate;

/// A Boolean value indicating whether the model is currently in loading state
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

@property (nonatomic, readonly) MAKLoadingType loadingType;

@property (nonatomic, readonly) BOOL moreItemsAvailable;

@property (nonatomic, readonly) BOOL dataInitialized;


#pragma mark - Loading additional information

/**
 @return An array of all items, which are in loading state.
 */
- (NSArray *)allLoadingItems;

/**
 @return The number of items, which are in loading state.
 */
- (NSUInteger)numberOfLoadingItems;

/** Get the loading state of a specified item.
 @param The item
 @return A Boolean value indicating whether the item is in loading state.
 */
- (BOOL)loadingStateForItem:(id)item;

/** Set the loading state of a specified item.
 @param item The item
 @param loading The loading state
 @return YES if the loading state was changed, otherwise NO.
 */
- (BOOL)setLoadingStateForItem:(id)item loadingState:(BOOL)loading;


#pragma mark - <Implement all the methods below in subclass>
#pragma mark - Load and update handling

/** Just do an update of existing items.<br>If not initialized yet, reloadItems will be called.
 @return YES, if the model start loading, otherwise NO (already loading).
 */
- (BOOL)updateItems;

/** Clear the current list and reload all items.
 @return YES, if the model start loading, otherwise NO (already loading).
 */
- (BOOL)reloadItems;

/** Load more items, if available and append them.
 @return YES, if the model start loading, otherwise NO (already loading).
 */
- (BOOL)loadMoreItems;

/** Cancel currently running load request
 */
- (void)cancelRequest;


#pragma mark - Item editing

/** Remove a specified item.
 @param item The item to remove.
 @param completionBlock This block will be executed on completion. The <code>success</code> parameter indicating whether the item was successfully removed.
 */
- (void)removeItem:(id)item completion:(void (^)(BOOL success))completionBlock;

/** Remove an item at the specified index path.
 @param indexPath The index path of the item to remove.
 @param completionBlock This block will be executed on completion. The <code>success</code> parameter indicating whether the item was successfully removed.
 */
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(BOOL success))completionBlock;

@end
