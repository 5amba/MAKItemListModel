//
//  MAKBaseItemListModel.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 11.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import <UIKit/UIKit.h> //UIKit because, we use the UICollectionViewAdditions of NSIndexPath.

#import "MAKItemListChanges.h"
#import "MAKItemChange.h"


//TODO: doc
extern const NSUInteger MAKUnlimitedSelection;


/** Base class for handling a bunch of items in multiple sections.
 *
 * The capabilities are for example: update/reload/append items and get access on items in the list
 */
@class MAKBaseItemListModel;


@protocol MAKBaseItemListModelDelegate <NSObject>

@optional

/** The model did update items (added, removed, moved, update).
 @param model The model.
 @param changes // TODO:
 */
- (void)itemListModel:(MAKBaseItemListModel *)itemListModel didUpdateItemsWithChanges:(MAKItemListChanges *)changes;


- (BOOL)itemListModel:(MAKBaseItemListModel *)itemListModel canSelect:(NSArray *)indexPaths;
- (void)itemListModel:(MAKBaseItemListModel *)itemListModel didChangeSelectionStateAtIndexPaths:(NSArray *)indexPaths;

@end


@interface MAKBaseItemListModel : NSObject

/** Register as delegate to get informed about current items updates, selection state, etc.
 @see MAKItemListModelDelegate
 */
- (void)addDelegate:(id<MAKBaseItemListModelDelegate>)delegate;

- (void)removeDelegate:(id)delegate;

- (void)removeAllDelegates;


@property (nonatomic, readonly) NSUInteger numberOfSelectableItems;



#pragma mark - Item access

/**
 @return An array of arrays, which represents the sections. Or nil if there are no sections.
 */
- (NSArray *)allSections;

/**
 @return The number of sections.
 */
- (NSUInteger)numberOfSections;

/**
 @return An array of all items in the specified section. Or nil if there is no section.
 */
- (NSArray *)itemsOfSection:(NSUInteger)section;

/**
 @return The number of items in the specified section.
 */
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;

/** Get a certain item
 @param indexPath The index path.
 @return The item at the specified index path.
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

/** Get the index of a specified item.
 @param The item
 @return The index path of the first object that is equal to the given item. Returns nil, if none of the objects in each section is equal to the specified item.
 */
- (NSIndexPath *)indexPathOfItem:(id)item;


#pragma mark - Item selection

/**
 @return An array of all selected items.
 */
- (NSArray *)allSelectedItems;

/**
 @return The number of selected items.
 */
- (NSUInteger)numberOfSelectedItems;

/**
 @return YES if specified item is selected, otherwise NO.
 */
- (BOOL)selectionStateForItem:(id)item;

/** Select or deselect a specified item.
 @param selected Provie YES to select the specified item and NO to deselect.
 @param The item.
 @return YES if the selection state was changed, otherwise NO.
 */
- (BOOL)setSelectionState:(BOOL)selected forItem:(id)item;

/** Toggle the selection state of a specified item.
 @param The item.
 @return The new selection state.
 */
- (BOOL)toggleSelectionStateForItem:(id)item;

/** Select a bunch of items.
 @param items An array of items to select.
 */
- (void)selectItems:(NSArray *)items;

/** Deselect all currently selected items.
 */
- (void)deselectAllItems;

/** Deselect a bunch of items.
 @param items An array of items to deselect.
 */
- (void)deselectItems:(NSArray *)items;

@end
