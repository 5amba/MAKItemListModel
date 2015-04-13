//
//  MAKItemChange.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 13.04.15.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAKItemChange : NSObject

@property (nonatomic, strong) id item;

@property (nonatomic, strong) NSIndexPath *fromIndexPath;

@property (nonatomic, strong) NSIndexPath *toIndexPath;


+ (MAKItemChange *)itemChangeWithItem:(id)item fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end
