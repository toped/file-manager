//
//  HomeViewController.h
//  FileManager
//
//  Created by TopeD on 8/25/15.
//  Copyright (c) 2015 Tope Daramola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *fileSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *fileTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *renameBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *zipBtn;

@property (strong, nonatomic) NSString *currentDirectory;
@property (strong, nonatomic) NSMutableArray *directoryContents;
@property (strong, nonatomic) NSMutableArray *directoryContentsFiltered;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic) BOOL isFiltered;

@end
