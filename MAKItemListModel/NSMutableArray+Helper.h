//
//  NSArray+NSMutableArray.h
//  MAKToolKit
//
//  Created by Martin Klöpfel on 21.01.14.
//  Copyright (c) 2014 Martin Klöpfel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Helper)

/** Inserts a given object at the end of the array.
 @param duplicates If set to NO duplicates can't be add.
 @return YES if the object was added, otherwise NO.
 */
- (BOOL)addObject:(id)object allowDuplicates:(BOOL)duplicates;

/** Inserts a given object at the end of the array or replaces a duplicate if the paramter <code>replace</code> is set to YES.
 @param replace Should replace duplicates?
 @return YES if the object replaced a duplicate, otherwise NO.
 */
- (BOOL)addObject:(id)object replaceDuplicates:(BOOL)replace;

@end
