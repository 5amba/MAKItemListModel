//
//  MAKItemListModel-Protected.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 11.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

@interface MAKBaseItemListModel ()

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

/** Add a new section with the given items.
 @param An array of items, which will be added to the new section. Provide nil to add an empty section.
 */
- (void)addSectionWithItems:(NSArray *)items;


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

@end
