//
//  MAKSectionChange.m
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 20.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKSectionChange.h"

@implementation MAKSectionChange

+ (MAKSectionChange *)sectionChangeWithSection:(NSArray *)section fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    MAKSectionChange *sectionChange = [MAKSectionChange new];
    sectionChange.section = section;
    sectionChange.fromIndex = fromIndex;
    sectionChange.toIndex = toIndex;
    return sectionChange;
}

@end
