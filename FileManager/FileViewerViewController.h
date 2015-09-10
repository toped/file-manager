//
//  FileViewerViewController.h
//  FileManager
//
//  Created by TopeD on 9/8/15.
//  Copyright (c) 2015 Tope Daramola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectoryObject.h"

@interface FileViewerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) DirectoryObject *fileToShow;

@end
