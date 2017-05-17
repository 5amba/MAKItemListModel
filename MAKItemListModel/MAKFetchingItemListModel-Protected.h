//
//  MAKFetchingItemListModel-Protected.h
//  MAKItemListModel
//
//  Created by Martin Kloepfel on 15.12.14.
//  Copyright (c) 2015 Martin Kloepfel. All rights reserved.
//

#import "MAKFetchingItemListModel.h"
#import "MAKBaseItemListModel-Protected.h"


@interface MAKFetchingItemListModel ()

@property (nonatomic, strong) MAKMultiDelegate<MAKFetchingItemListModelDelegate> *delegates;

// redeklaration to get write permission for internal use
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic) MAKLoadingType loadingType;
@property (nonatomic) BOOL moreItemsAvailable;
@property (nonatomic) BOOL dataInitialized;

/// The array of all items, which are in loading state<br>For internal use only!
@property (nonatomic, strong) NSMutableArray* loadingItems;

@end
