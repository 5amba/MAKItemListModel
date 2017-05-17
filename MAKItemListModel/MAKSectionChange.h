//
//  MAKSectionChange.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 20.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAKSectionChange : NSObject

@property (nonatomic, strong) NSArray *section;

@property (nonatomic) NSUInteger *fromIndex;

@property (nonatomic) NSUInteger *toIndex;


+ (MAKSectionChange *)sectionChangeWithSection:(NSArray *)section fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
