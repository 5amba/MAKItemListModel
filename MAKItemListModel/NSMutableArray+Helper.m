//
//  NSArray+NSMutableArray.m
//  MAKToolKit
//
//  Created by Martin Klöpfel on 21.01.14.
//  Copyright (c) 2014 Martin Klöpfel. All rights reserved.
//

#import "NSMutableArray+Helper.h"

@implementation NSMutableArray (Helper)

- (BOOL)addObject:(id)object allowDuplicates:(BOOL)duplicates
{
    if (!object)
        return NO;
    
    if (!duplicates && [self containsObject:object])
        return NO;
    
    [self addObject:object];
    return YES;
}

- (BOOL)addObject:(id)object replaceDuplicates:(BOOL)replace
{
    if (!object)
        return NO;
    
    if (replace && [self containsObject:object])
    {
        [self replaceObjectAtIndex:[self indexOfObject:object] withObject:object];
        return YES;
    }
    
    [self addObject:object];
    
    return NO;
}

@end

