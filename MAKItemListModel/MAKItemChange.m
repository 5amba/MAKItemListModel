//
//  MAKItemChange.m
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 13.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKItemChange.h"


@implementation MAKItemChange

+ (MAKItemChange *)itemChangeWithItem:(id)item fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    MAKItemChange *itemChange = [MAKItemChange new];
    itemChange.item = item;
    itemChange.fromIndexPath = fromIndexPath;
    itemChange.toIndexPath = toIndexPath;
    return itemChange;
}

@end
