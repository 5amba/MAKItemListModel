//
//  MAKItemListModel-Protected.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 11.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKBaseItemListModel.h"

#import "MAKMultiDelegate.h"


@interface MAKBaseItemListModel ()

@property (nonatomic, strong) MAKMultiDelegate<MAKBaseItemListModelDelegate> *delegates;

/// The array, which contains the arrays of all sections.<br>For internal use only!
@property (nonatomic, strong) NSMutableArray* sections;

/// The array of all selected items<br>For internal use only!
@property (nonatomic, strong) NSMutableArray* selectedItems;


/** Get the section of a specified index.
 @param The index
 @returns The Array of the section at the specified index. Or nil if there is no section at the specified index.
 */
- (NSMutableArray *)sectionAtIndex:(NSUInteger)index;


#pragma mark - Item editing
#pragma mark - Add items

/** Add a new section with the given items.
 @param An array of items, which will be added to the new section. Provide nil to add an empty section.
 */
- (void)addSectionWithItems:(NSArray *)items;


- (BOOL)addSection:(NSMutableArray *)section;
- (BOOL)addSection:(NSMutableArray *)section notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)addSections:(NSArray *)sections;
- (BOOL)addSections:(NSArray *)sections notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)insertSection:(NSMutableArray *)section atIndex:(NSUInteger)index;
- (BOOL)insertSection:(NSMutableArray *)section atIndex:(NSUInteger)index notifyDelegate:(BOOL)notifyDelegate;



- (BOOL)addItem:(id)item toSection:(NSUInteger)sectionIndex;
- (BOOL)addItem:(id)item toSection:(NSUInteger)sectionIndex notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)addItems:(NSArray *)items toSection:(NSUInteger)sectionIndex;
- (BOOL)addItems:(NSArray *)items toSection:(NSUInteger)sectionIndex notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath;
- (BOOL)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath notifyDelegate:(BOOL)notifyDelegate;






#pragma mark - Remove items

/** Remove a specified item.
 @param The item.
 @return YES if the item was removed, otherwise NO.
 */
- (BOOL)removeItem:(id)item;
- (BOOL)removeItem:(id)item notifyDelegate:(BOOL)notifyDelegate;


- (BOOL)removeItems:(NSArray *)items;
- (BOOL)removeItems:(NSArray *)items notifyDelegate:(BOOL)notifyDelegate;


- (BOOL)removeItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)removeItemAtIndexPath:(NSIndexPath *)indexPath notifyDelegate:(BOOL)notifyDelegate;


- (BOOL)removeAllItemsInSection:(NSUInteger)sectionIndex;
- (BOOL)removeAllItemsInSection:(NSUInteger)sectionIndex notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)removeSectionAtIndex:(NSUInteger)index;
- (BOOL)removeSectionAtIndex:(NSUInteger)index notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)removeAllSections;
- (BOOL)removeAllSectionsAndNotifyDelegate:(BOOL)notifyDelegate;

@end
