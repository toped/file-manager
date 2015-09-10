//
//  FileViewerViewController.m
//  FileManager
//
//  Created by TopeD on 9/8/15.
//  Copyright (c) 2015 Tope Daramola. All rights reserved.
//

#import "FileViewerViewController.h"

@interface FileViewerViewController ()

@end

@implementation FileViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.webview.scalesPageToFit = YES;
    self.webview.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    NSURL *targetURL = [NSURL fileURLWithPath:self.filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    
    [self.webview loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)doSomething:(id)sender {
    
}

@end
