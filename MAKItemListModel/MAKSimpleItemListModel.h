//
//  MAKSimpleItemListModel.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 11.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKBaseItemListModel.h"

@interface MAKSimpleItemListModel : MAKBaseItemListModel

- (BOOL)addItem:(id)item inSection:(NSUInteger)section notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)addItems:(NSArray *)items inSection:(NSUInteger)section notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)removeAllItemsInSection:(NSUInteger)section notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)replaceItem:(id)item withItem:(id)newItem notifyDelegate:(BOOL)notifyDelegate;

/** Add a new section with the given items.
 @param An array of items, which will be added to the new section. Provide nil to add an empty section.
 */
- (void)addSectionWithItems:(NSArray *)items notifyDelegate:(BOOL)notifyDelegate;


/** Remove a specified item.
 @param The item.
 @return YES if the item was removed, otherwise NO.
 */
- (BOOL)removeItem:(id)item notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)removeItems:(NSArray *)items notifyDelegate:(BOOL)notifyDelegate;

- (BOOL)removeItemAtIndexPath:(NSIndexPath *)indexPath notifyDelegate:(BOOL)notifyDelegate;

@end
