//
//  SecondViewController.h
//  Tabby
//
//  Created by Michael Arbuckle on 9/21/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "DevicesHTTPClient.h"

@interface ActivityViewController  : UIViewController <UITableViewDataSource, UITableViewDelegate,
    UISearchBarDelegate, NSFetchedResultsControllerDelegate,DevicesHTTPClientDelegate>
    
    @property (nonatomic, strong) UITableView *tableView;
    @property (nonatomic, strong) UISearchBar *searchBar;
    @property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
    
    @end

 

