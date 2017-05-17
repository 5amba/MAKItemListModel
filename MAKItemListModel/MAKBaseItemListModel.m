//
//  MAKBaseItemListModel.m
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 11.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKBaseItemListModel-Protected.h"

#import "NSMutableArray+Helper.h"


const NSUInteger MAKUnlimitedSelection = NSUIntegerMax;


@implementation MAKBaseItemListModel

- (void)addDelegate:(id<MAKBaseItemListModelDelegate>)delegate
{
    [self.delegates addDelegate:delegate];
}

- (void)removeDelegate:(id<MAKBaseItemListModelDelegate>)delegate
{
    [self.delegates removeDelegate:delegate];
}

- (void)removeAllDelegates
{
    [self.delegates removeAllDelegates];
}

#pragma mark - Item access

- (NSArray *)allSections
{
    if (self.sections.count == 0)
        return nil;
    
    NSMutableArray *sections = [NSMutableArray new];
    
    for (NSMutableArray *sectionArray in self.sections)
        [sections addObject:[NSArray arrayWithArray:sectionArray]];
    
    return [NSArray arrayWithArray:sections];
}

- (NSUInteger)numberOfSections
{
    return self.sections.count;
}

- (NSArray *)itemsOfSection:(NSUInteger)section
{
    NSMutableArray *sectionArray = [self sectionAtIndex:section];
    
    if (sectionArray.count == 0)
        return nil;
    
    return [NSArray arrayWithArray:sectionArray];
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
    NSMutableArray *sectionArray = [self sectionAtIndex:section];
    return sectionArray.count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![indexPath isKindOfClass:[NSIndexPath class]])
        return nil; // TODO: exeption?
    
    NSMutableArray *sectionArray = [self sectionAtIndex:indexPath.section];
    
    if (indexPath.item < sectionArray.count)
        return [sectionArray objectAtIndex:indexPath.item];
    return nil;
}

- (NSIndexPath *)indexPathOfItem:(id)item
{
    NSUInteger numberOfSections = [self numberOfSections];
    
    for (NSUInteger section = 0; section < numberOfSections; section++)
    {
        NSMutableArray *sectionArray = [self sectionAtIndex:section];
        NSUInteger index = [sectionArray indexOfObject:item];
        if (index != NSNotFound)
            return [NSIndexPath indexPathForItem:index inSection:section];
    }
    
    return nil;
}


#pragma mark - Item selection

- (NSArray *)allSelectedItems
{
    return [NSArray arrayWithArray:self.selectedItems];
}

- (NSUInteger)numberOfSelectedItems
{
    return self.selectedItems.count;
}

- (BOOL)selectionStateForItem:(id)item
{
    return [self.selectedItems containsObject:item];
}

- (BOOL)setSelectionState:(BOOL)selected forItem:(id)item
{
    if (selected)
    {
        BOOL changed = [self.selectedItems addObject:item allowDuplicates:NO];
        
        if (changed)
            if ([self.delegates respondsToSelector:@selector(itemListModel:didChangeLoadingStateAtIndexPaths:)])
                [self.delegates itemListModel:self didChangeSelectionStateAtIndexPaths:@[[self indexPathOfItem:item]]];
        
        return changed;
    }
    else
    {
        if ([self.selectedItems containsObject:item])
        {
            [self.selectedItems removeObject:item];
            
            if ([self.delegates respondsToSelector:@selector(itemListModel:didChangeLoadingStateAtIndexPaths:)])
                [self.delegates itemListModel:self didChangeSelectionStateAtIndexPaths:@[[self indexPathOfItem:item]]];
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (BOOL)toggleSelectionStateForItem:(id)item
{
    if ([self.selectedItems containsObject:item])
    {
        [self.selectedItems removeObject:item];
        
        if ([self.delegates respondsToSelector:@selector(itemListModel:didChangeLoadingStateAtIndexPaths:)])
            [self.delegates itemListModel:self didChangeSelectionStateAtIndexPaths:@[[self indexPathOfItem:item]]];
        
        return NO;
    }
    else
    {
        [self.selectedItems addObject:item];
        
        if ([self.delegates respondsToSelector:@selector(itemListModel:didChangeLoadingStateAtIndexPaths:)])
            [self.delegates itemListModel:self didChangeSelectionStateAtIndexPaths:@[[self indexPathOfItem:item]]];
        
        return YES;
    }
}

- (void)selectItems:(NSArray *)items
{
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (id item in items)
    {
        if (![self.selectedItems containsObject:item])
        {
            NSIndexPath *indexPath = [self indexPathOfItem:item];
            if (indexPath)
                [indexPaths addObject:indexPath];
            [self.selectedItems addObject:item];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(itemListModel:didChangeLoadingStateAtIndexPaths:)])
        [self.delegates itemListModel:self didChangeSelectionStateAtIndexPaths:[NSArray arrayWithArray:indexPaths]];
}

- (void)deselectAllItems
{
    [self deselectItems:[NSArray arrayWithArray:self.selectedItems]];
}

- (void)deselectItems:(NSArray *)items
{
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (id item in items)
    {
        if ([self.selectedItems containsObject:item])
        {
            NSIndexPath *indexPath = [self indexPathOfItem:item];
            if (indexPath)
                [indexPaths addObject:indexPath];
            [self.selectedItems removeObject:item];
        }
    }
    
    if ([self.delegates respondsToSelector:@selector(itemListModel:selectionChangedAtIndexes:)])
        [self.delegates itemListModel:self didChangeSelectionStateAtIndexPaths:[NSArray arrayWithArray:indexPaths]];
}


#pragma mark - Protected methods

- (NSMutableArray *)sectionAtIndex:(NSUInteger)index
{
    if (index < self.sections.count)
        return [self.sections objectAtIndex:index];
    return nil;
}

#pragma mark - Item editing
#pragma mark - Add items

- (BOOL)addSectionWithItems:(NSArray *)items
{
    if (!items || ![items isKindOfClass:[NSArray class]] || items.count == 0)
        return NO; //TODO: exeption?
    
    [self addSection:[NSMutableArray arrayWithArray:items]];
}

- (BOOL)addSection:(NSMutableArray *)section
{
    if (!section || ![section isKindOfClass:[NSMutableArray class]])
        return NO; //TODO: exeption?
    
    [self addSection:section notifyDelegate:YES];
}

- (BOOL)addSection:(NSMutableArray *)section notifyDelegate:(BOOL)notifyDelegate
{
    if (!section || ![section isKindOfClass:[NSMutableArray class]])
        return NO; //TODO: exeption?

    [self addSections:@[section] notifyDelegate:notifyDelegate];
}

- (BOOL)addSections:(NSArray *)sections
{
    if (!sections || ![sections isKindOfClass:[NSArray class]] || sections.count == 0)
        return NO; //TODO: exeption?
    
    [self addSections:sections notifyDelegate:YES];
}

- (BOOL)addSections:(NSArray *)sections notifyDelegate:(BOOL)notifyDelegate
{
    if (!sections || ![sections isKindOfClass:[NSArray class]] || sections.count == 0)
        return NO; //TODO: exeption?
    
    NSMutableArray *sectionChanges = [NSMutableArray new];
    
    for (NSMutableArray *section in sections)
    {
        if (![section isKindOfClass:[NSMutableArray class]])
            return NO; //TODO: exeption?
        [sectionChanges addObject:[MAKSectionChange sectionChangeWithSection:sections fromIndex:NSNotFound toIndex:self.sections.count]];
        [self.sections addObject:section];
    }
    
    if (notifyDelegate && sectionChanges.count && [self.delegates respondsToSelector:@selector(itemListModel:didUpdateItemsWithChanges:)])
        [self.delegates itemListModel:self didUpdateItemsWithChanges:[MAKItemListChanges itemListChangesWithAddedSections:[NSArray arrayWithArray:sectionChanges]]];
    
    return YES;
}

- (BOOL)insertSection:(NSMutableArray *)section atIndex:(NSUInteger)index
{
    return [self insertSection:section atIndex:index notifyDelegate:YES];
}

- (BOOL)insertSection:(NSMutableArray *)section atIndex:(NSUInteger)index notifyDelegate:(BOOL)notifyDelegate
{
    if (!section || ![section isKindOfClass:[NSMutableArray class]])
        return NO; //TODO: exeption?
    
    if (index < 0 || index > self.sections.count)
        return NO; //TODO: exeption?
    
    [self.sections insertObject:section atIndex:index];
    
    if (notifyDelegate && [self.delegates respondsToSelector:@selector(itemListModel:didUpdateItemsWithChanges:)])
    {
        MAKSectionChange *sectionChange = [MAKSectionChange sectionChangeWithSection:section fromIndex:NSNotFound toIndex:index];
        [self.delegates itemListModel:self didUpdateItemsWithChanges:[MAKItemListChanges itemListChangesWithAddedSections:@[sectionChange]]];
    }
    
    return YES;
}

- (BOOL)addItem:(id)item toSection:(NSUInteger)sectionIndex
{
    return [self addItem:item toSection:sectionIndex notifyDelegate:YES];
}

- (BOOL)addItem:(id)item toSection:(NSUInteger)sectionIndex notifyDelegate:(BOOL)notifyDelegate
{
    return [self addItems:@[item] toSection:sectionIndex notifyDelegate:notifyDelegate];
}

- (BOOL)addItems:(NSArray *)items toSection:(NSUInteger)sectionIndex
{
    return [self addItems:items toSection:sectionIndex notifyDelegate:YES];
}

- (BOOL)addItems:(NSArray *)items toSection:(NSUInteger)sectionIndex notifyDelegate:(BOOL)notifyDelegate
{
    if (!items || ![items isKindOfClass:[NSArray class]] || items.count == 0)
        return NO; //TODO: exeption?
    
    NSMutableArray *section = [self sectionAtIndex:sectionIndex];
    if (!section)
        return NO; //TODO: exeption?

    NSMutableArray *itemChanges = [NSMutableArray new];
    
    for (id item in items)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:section.count inSection:sectionIndex];
        [itemChanges addObject:[MAKItemChange itemChangeWithItem:item fromIndexPath:nil toIndexPath:indexPath]];
        [section addObject:item];
    }
    
    if (notifyDelegate && itemChanges.count && [self.delegates respondsToSelector:@selector(itemListModel:didUpdateItemsWithChanges:)])
        [self.delegates itemListModel:self didUpdateItemsWithChanges:[MAKItemListChanges itemListChangesWithAddedItems:[NSArray arrayWithArray:itemChanges]]];
    
    return YES;
}

- (BOOL)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    return [self insertItem:item atIndexPath:indexPath notifyDelegate:YES];
}

- (BOOL)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath notifyDelegate:(BOOL)notifyDelegate
{
    if (!item)
        return NO; //TODO: exeption?
    
    NSMutableArray *section = [self sectionAtIndex:indexPath.section];
    if (!section)
        return NO; //TODO: exeption?
    
    if (indexPath.row < 0 || indexPath.row > section.count)
        return NO; //TODO: exeption?
    
    [section insertObject:item atIndex:indexPath.row];
    
    if (notifyDelegate && [self.delegates respondsToSelector:@selector(itemListModel:didUpdateItemsWithChanges:)])
    {
        MAKItemChange *itemChange = [MAKItemChange itemChangeWithItem:item fromIndexPath:nil toIndexPath:indexPath];
        [self.delegates itemListModel:self didUpdateItemsWithChanges:[MAKItemListChanges itemListChangesWithAddedItems:@[itemChange]]];
    }
    
    return YES;
}


#pragma mark - Remove items

- (BOOL)removeItem:(id)item
{
    [self removeItem:item notifyDelegate:YES];
}

- (BOOL)removeItem:(id)item notifyDelegate:(BOOL)notifyDelegate
{
    return [self removeItemAtIndexPath:[self indexPathOfItem:item] notifyDelegate:notifyDelegate];
}

- (BOOL)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeItemAtIndexPath:indexPath notifyDelegate:YES];
}

- (BOOL)removeItemAtIndexPath:(NSIndexPath *)indexPath notifyDelegate:(BOOL)notifyDelegate
{
    id item = [self itemAtIndexPath:indexPath];
    
    if (!item)
        return NO;
    
    NSMutableArray *section = [self sectionAtIndex:indexPath.section];
    [section removeObjectAtIndex:indexPath.row];
    
    if ([_selectedItems containsObject:item])
        [_selectedItems removeObject:item];
    
    if (notifyDelegate && [self.delegates respondsToSelector:@selector(itemListModel:didUpdateItemsWithChanges:)])
    {
        MAKItemChange *itemChange = [MAKItemChange itemChangeWithItem:item fromIndexPath:indexPath toIndexPath:nil];
        [self.delegates itemListModel:self didUpdateItemsWithChanges:[MAKItemListChanges itemListChangesWithRemovedItems:@[itemChange]]];
    }
    
    return YES;
}

- (BOOL)removeAllItemsInSection:(NSUInteger)sectionIndex
{
    return [self removeAllItemsInSection:sectionIndex notifyDelegate:YES];
}

- (BOOL)removeAllItemsInSection:(NSUInteger)sectionIndex notifyDelegate:(BOOL)notifyDelegate
{
    NSMutableArray *section = [self sectionAtIndex:sectionIndex];
    if (!section || section.count == 0)
        return NO;
    
    NSMutableArray *itemChanges = [NSMutableArray new];
    for (NSInteger i = 0; i<section.count; i++)
    {
        id item = section[i];
        MAKItemChange *itemChange = [MAKItemChange itemChangeWithItem:item fromIndexPath:[NSIndexPath indexPathForRow:i inSection:sectionIndex] toIndexPath:nil];
        [itemChanges addObject:itemChange];
        
        if ([_selectedItems containsObject:item])
            [_selectedItems removeObject:item];
    }
    
    [section removeAllObjects];
    
    if (notifyDelegate && itemChanges.count && [self.delegates respondsToSelector:@selector(itemListModel:didUpdateItemsWithChanges:)])
        [self.delegates itemListModel:self didUpdateItemsWithChanges:[MAKItemListChanges itemListChangesWithRemovedItems:[NSArray arrayWithArray:itemChanges]]];
    
    return YES;
}

- (BOOL)removeSectionAtIndex:(NSUInteger)index
{
    return [self removeSectionAtIndex:index notifyDelegate:YES];
}

- (BOOL)removeSectionAtIndex:(NSUInteger)index notifyDelegate:(BOOL)notifyDelegate
{
    if (self.sections.count == 0 && index < self.sections.count)
        return NO;
    
    NSMutableArray *section = self.sections[index];
    for (id item in section)
    {
        if ([_selectedItems containsObject:item])
            [_selectedItems removeObject:item];
    }
    
    MAKSectionChange *sectionChange = [MAKSectionChange sectionChangeWithSection:[self itemsOfSection:index] fromIndex:index toIndex:NSNotFound];
    [self.sections removeObjectAtIndex:index];
    
    if (notifyDelegate && [self.delegates respondsToSelector:@selector(itemListModel:didUpdateItemsWithChanges:)])
        [self.delegates itemListModel:self didUpdateItemsWithChanges:[MAKItemListChanges itemListChangesWithRemovedSections:@[sectionChange]]];
    
    return YES;
}

- (BOOL)removeAllSections
{
    return [self removeAllSectionsAndNotifyDelegate:YES];
}

- (BOOL)removeAllSectionsAndNotifyDelegate:(BOOL)notifyDelegate
{
    if (self.sections.count == 0)
        return NO;
    
    NSMutableArray *sectionChanges = [NSMutableArray new];
    for (NSInteger i = 0; i<self.sections.count; i++)
    {
        MAKSectionChange *sectionChange = [MAKSectionChange sectionChangeWithSection:self.sections[i] fromIndex:i toIndex:NSNotFound];
        [sectionChanges addObject:sectionChange];
    }
    
    [self.sections removeAllObjects];
    [_selectedItems removeAllObjects];
    
    if (notifyDelegate && sectionChanges.count && [self.delegates respondsToSelector:@selector(itemListModel:didUpdateItemsWithChanges:)])
        [self.delegates itemListModel:self didUpdateItemsWithChanges:[MAKItemListChanges itemListChangesWithRemovedSections:[NSArray arrayWithArray:sectionChanges]]];
    
    return YES;
}


#pragma mark - Getter / Lazy instantiation

- (MAKMultiDelegate *)delegates
{
    if (!_delegates)
    {
        _delegates = [MAKMultiDelegate new];
    }
    return _delegates;
}

- (NSMutableArray *)sections
{
    if (!_sections)
    {
        _sections = [NSMutableArray new];
    }
    return _sections;
}

- (NSMutableArray *)selectedItems
{
    if (!_selectedItems)
    {
        _selectedItems = [NSMutableArray new];
    }
    return _selectedItems;
}




// TODO: implement numberOfSelectableItems
//- (void) selectItems:(NSArray*)items
//{
//    NSMutableIndexSet* indexSet = [NSMutableIndexSet new];
//    for (id item in items)
//    {
//        if (![self.selectedItems containsObject:item])
//        {
//            int index = [self indexOfItem:item];
//            if (index != NSNotFound)
//                [indexSet addIndex:index];
//            [self.selectedItems addObject:item];
//        }
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(dataListModel:selectionChangedAtIndexes:)])
//        [self.delegate dataListModel:self selectionChangedAtIndexes:indexSet];
//}
//
//- (BOOL) setSelected:(id)item selected:(BOOL)selected
//{
//    BOOL changed = FALSE;
//    NSMutableIndexSet* changedIndexes = [NSMutableIndexSet new];
//    if (selected)
//    {
//        if (self.numberOfSelectableItems == 1)
//        {
//            if (![self.selectedItems containsObject:item])
//            {
//                if (self.selectedItems.count > 0)
//                    [changedIndexes addIndex:[self indexOfItem:self.selectedItems[0]]];
//                [self.selectedItems removeAllObjects];
//                [self.selectedItems addObject:item];
//                changed = TRUE;
//            }
//        }
//        else if (self.selectedItems.count < self.numberOfSelectableItems || self.numberOfSelectableItems == kUnlimitedSelection)
//        {
//            if (![self.selectedItems containsObject:item])
//            {
//                [self.selectedItems addObject:item];
//                changed = TRUE;
//            }
//        }
//    }
//    else
//    {
//        if ([self.selectedItems containsObject:item])
//        {
//            [self.selectedItems removeObject:item];
//            changed = TRUE;
//        }
//    }
//    
//    if (changed)
//    {
//        int index = [self indexOfItem:item];
//        [changedIndexes addIndex:index];
//        if (index != NSNotFound)
//        {
//            if ([self.delegate respondsToSelector:@selector(dataListModel:selectionChangedAtIndexes:)])
//                [self.delegate dataListModel:self selectionChangedAtIndexes:changedIndexes];
//        }
//    }
//    
//    return changed;
//}

@end
