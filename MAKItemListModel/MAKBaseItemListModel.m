//
//  MAKBaseItemListModel.m
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 11.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKBaseItemListModel.h"
#import "MAKBaseItemListModel-Protected.h"

#import "NSMutableArray+Helper.h"


const NSUInteger MAKUnlimitedSelection = NSUIntegerMax;


@implementation MAKBaseItemListModel

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        self.sections = [NSMutableArray new];
    }
    return self;
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
            if ([self.delegate respondsToSelector:@selector(model:didChangeLoadingStateAtIndexPaths:)])
                [self.delegate model:self didChangeSelectionStateAtIndexPaths:@[[self indexPathOfItem:item]]];
        
        return changed;
    }
    else
    {
        if ([self.selectedItems containsObject:item])
        {
            [self.selectedItems removeObject:item];
            
            if ([self.delegate respondsToSelector:@selector(model:didChangeLoadingStateAtIndexPaths:)])
                [self.delegate model:self didChangeSelectionStateAtIndexPaths:@[[self indexPathOfItem:item]]];
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (BOOL)toogleSelectionStateForItem:(id)item
{
    if ([self.selectedItems containsObject:item])
    {
        [self.selectedItems removeObject:item];
        
        if ([self.delegate respondsToSelector:@selector(model:didChangeLoadingStateAtIndexPaths:)])
            [self.delegate model:self didChangeSelectionStateAtIndexPaths:@[[self indexPathOfItem:item]]];
        
        return NO;
    }
    else
    {
        [self.selectedItems addObject:item];
        
        if ([self.delegate respondsToSelector:@selector(model:didChangeLoadingStateAtIndexPaths:)])
            [self.delegate model:self didChangeSelectionStateAtIndexPaths:@[[self indexPathOfItem:item]]];
        
        return YES;
    }
}

- (void)selectItems:(NSArray *)items
{
    NSMutableArray* indexPaths = [NSMutableIndexSet new];
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
    
    if ([self.delegate respondsToSelector:@selector(model:didChangeLoadingStateAtIndexPaths:)])
        [self.delegate model:self didChangeSelectionStateAtIndexPaths:[NSArray arrayWithArray:indexPaths]];
}

- (void)deselectAllItems
{
    [self deselectItems:[NSArray arrayWithArray:self.selectedItems]];
}

- (void)deselectItems:(NSArray *)items
{
    NSMutableArray* indexPaths = [NSMutableIndexSet new];
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
    
    if ([self.delegate respondsToSelector:@selector(dataListModel:selectionChangedAtIndexes:)])
        [self.delegate model:self didChangeSelectionStateAtIndexPaths:[NSArray arrayWithArray:indexPaths]];
}


#pragma mark - Protected methods

- (NSMutableArray *)sectionAtIndex:(NSUInteger)index
{
    if (index < self.sections.count)
        return [self.sections objectAtIndex:index];
    return nil;
}

#pragma mark - Item editing


- (void)addSectionWithItems:(NSArray *)items
{
    if (!items)
        [self.sections addObject:[NSMutableArray new]];
    
    if (![items isKindOfClass:[NSArray class]])
    {
        //TODO: throw exeption
        return;
    }
    
    [self.sections addObject:[NSMutableArray arrayWithArray:items]];
}


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
    
    if (notifyDelegate && [self.delegate respondsToSelector:@selector(modelDidUpdateItems:changes:)])
    {
        MAKItemChange *itemChange = [MAKItemChange itemChangeWithItem:item fromIndexPath:indexPath toIndexPath:nil];
        [self.delegate modelDidUpdateItems:self changes:[MAKItemListChanges itemListChangesWithRemovedItems:@[itemChange]]];
    }
    
    return YES;
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
