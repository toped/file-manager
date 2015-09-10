//
//  HomeViewController.m
//  FileManager
//
//  Created by TopeD on 8/25/15.
//  Copyright (c) 2015 Tope Daramola. All rights reserved.
//

#import "DirectoryViewController.h"
#import "NavigatorTableViewCell.h"
#import "FileViewerViewController.h"
#import "DirectoryObject.h"
#import "ZipArchive.h"

@interface DirectoryViewController ()

@end

@implementation DirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set the title of the main view
    self.navigationItem.title = @"File Navigator";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self
            action:@selector(dismissKeyboard)];
    
    self.tap.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:_tap];
    
    
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    //Set up navigation bar button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Set up toolbar
    [self disableToolBarButtons];

    
    if (self.currentDirectory == nil) {
        //Get contents of Application directory (files)
        /*NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];*/
        //Get contents of Documents directory (files)
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSError *error;
        NSString *documentsFolderPath = [paths firstObject];
        
        NSString *newDoc1 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists"];
        NSString *newDoc2 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists/gist1.txt"];
        NSString *newDoc3 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists/gist2.txt"];
        NSString *newDoc4 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists/gist3.cpp"];
        NSString *newDoc5 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists/gist4"];
        
        NSString *newDoc6 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists/Scraps"];
        NSString *newDoc7 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists/Scraps/scrap1.txt"];
        NSString *newDoc8 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists/Scraps/scrap2.txt"];
        NSString *newDoc9 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists/Scraps/scrap3.txt"];
        NSString *newDoc10 = [documentsFolderPath stringByAppendingPathComponent:@"/Gists/Scraps/Graphics"];
        
        //strings
        NSString *gist1 = @"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...";
        NSString *gist2 = @"Etiam ullamcorper quis enim eget scelerisque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas eu lacus aliquam, condimentum nisi vel, volutpat augue. Vestibulum a elementum nisl. Aliquam vel magna vitae tortor fringilla luctus. Sed ultricies mauris ligula, non posuere metus auctor fermentum. Nulla facilisi. Aenean molestie lacus ac venenatis rhoncus. Interdum et malesuada fames ac ante ipsum primis in faucibus. In vel rhoncus tellus. Suspendisse ac gravida est. In hac habitasse platea dictumst. Mauris consequat mauris quis imperdiet vulputate.";
        NSString *gist3 = @"int fib(int n){ \n if ( n == 0 ) \n\t return 0; \n if ( n == 1 ) \n\t return 1; \n\n return fib(n-1) + fib(n-2); \n }";
        NSString *gist4 = @"During three post-event meetings with senior administration officials, the Crisis Action Team and law enforcement, Mississippi State President Mark E. Keenum today announced a new initiative designed to enhance the safety and security of the institution in the wake of last week’s active shooter scare on MSU’s Starkville campus.";
        NSString *scrap1 = @"The saddest aspect of life right now is that science gathers knowledge faster than society gathers wisdom.";
        NSString *scrap2 = @"People aren’t either wicked or noble. They’re like chef’s salads, with good things and bad things chopped and mixed together in a vinaigrette of confusion and conflict.";
        NSString *scrap3 = @"A life spent making mistakes is not only more honorable, but more useful than a life spent doing nothing.";
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:newDoc1]){
            [[NSFileManager defaultManager] createDirectoryAtPath:newDoc1 withIntermediateDirectories:YES attributes:@{ NSFilePosixPermissions : @(0777) } error:&error]; //Create /Gists
            [gist1 writeToFile:newDoc2 atomically:YES encoding:NSUTF8StringEncoding error:&error]; //Create gist1
            [gist2 writeToFile:newDoc3 atomically:YES encoding:NSUTF8StringEncoding error:&error]; //Create gist4
            [gist3 writeToFile:newDoc4 atomically:YES encoding:NSUTF8StringEncoding error:&error]; //Create gist3
            [gist4 writeToFile:newDoc5 atomically:YES encoding:NSUTF8StringEncoding error:&error]; //Create gist4
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:newDoc6]){
            [[NSFileManager defaultManager] createDirectoryAtPath:newDoc6 withIntermediateDirectories:YES attributes:@{ NSFilePosixPermissions : @(0777) } error:&error]; //Create /Scraps
            [scrap1 writeToFile:newDoc7 atomically:YES encoding:NSUTF8StringEncoding error:&error]; //Create scrap1
            [scrap2 writeToFile:newDoc8 atomically:YES encoding:NSUTF8StringEncoding error:&error]; //Create scrap2
            [scrap3 writeToFile:newDoc9 atomically:YES encoding:NSUTF8StringEncoding error:&error]; //Create scrap3
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:newDoc10]){
            [[NSFileManager defaultManager] createDirectoryAtPath:newDoc10 withIntermediateDirectories:YES attributes:@{ NSFilePosixPermissions : @(0777) } error:&error]; //Create /Graphics
        }
        
        //populate direcory
        self.currentDirectory = documentsFolderPath;
        [self populateDirectoryWithPath:self.currentDirectory];
        NSLog(@"The current directory is: %@", documentsFolderPath);
    }
    else {
        //populate direcory
        [self populateDirectoryWithPath:self.currentDirectory];
        NSLog(@"The current directory is: %@", self.currentDirectory);
    }


}

-(void)dismissKeyboard {
    
    [self.fileSearchBar resignFirstResponder];
    
}

- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    self.tap.cancelsTouchesInView = YES;
}

- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    self.tap.cancelsTouchesInView = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source methods

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
- ( NSInteger )numberOfSectionsInTableView:( UITableView *)tableView {
    //only one section in table
    return 1;
}


/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- ( NSInteger )tableView:( UITableView *)tableView numberOfRowsInSection:( NSInteger )section {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (!_isFiltered) {
        return [self.directoryContents count];
    }
    else {
        return [self.directoryContentsFiltered count];
    }
    
    
    return [ array count ];

}


/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- ( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"NavigatorTableViewCell";
    
    NavigatorTableViewCell *cell = (NavigatorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DirectoryObject *directoryObject = [self getDirectoryObjectAtIndexPathRow:indexPath];
    
    [[cell fileNameLabel] setText:[directoryObject fileName]];
    [[cell fileSizeLabel] setText:[NSByteCountFormatter stringFromByteCount:[[directoryObject fileAttributes] fileSize]
                                                                 countStyle:NSByteCountFormatterCountStyleFile]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    [[cell dateModifiedLabel] setText:[NSString stringWithFormat:@"Last Modified: %@", [formatter stringFromDate:[[directoryObject fileAttributes] fileModificationDate]]]];
    
    
    //Set up icon for given file type 
    if ([[directoryObject fileType] isEqualToString:@"directory"]) {
        cell.fileIcon.image = [UIImage imageNamed:@"folder_icon.png"];
    }
    else if ([[directoryObject fileType] isEqualToString:@"pdf"]) {
        cell.fileIcon.image = [UIImage imageNamed:@"pdf_icon.png"];
    }
    else if ([[directoryObject fileType] isEqualToString:@"txt"]) {
        cell.fileIcon.image = [UIImage imageNamed:@"txt_icon.png"];
    }
    else {
        cell.fileIcon.image = [UIImage imageNamed:@"file_icon.png"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (!tableView.editing) {
        
        DirectoryObject *directoryObject = [self getDirectoryObjectAtIndexPathRow:indexPath];
        
        if ([[directoryObject fileType] isEqualToString:@"directory"]) {
            
            // Create and push another instance of DirectoryViewController
            // Be sure to set the current directory.
            DirectoryViewController *targetController = [[DirectoryViewController alloc] init];
            
            NSString *selectedDirectory = [self.currentDirectory stringByAppendingPathComponent:[directoryObject fileName]];
            
            [targetController setCurrentDirectory:selectedDirectory];
            [self.navigationController pushViewController:targetController animated:YES];
            
        }
        else if ([[directoryObject fileType] isEqualToString:@"zip"]) {
            
            // do something to handle zip files
            
        }
        else {
            
            // Create and push FileViewerViewController
            FileViewerViewController *viewer = [[FileViewerViewController alloc] init];
            
            [viewer setFileToShow:directoryObject];
            [viewer setFilePath:[self.currentDirectory stringByAppendingPathComponent:[directoryObject fileName]]];
            [self.navigationController pushViewController:viewer animated:YES];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    if ([self.fileTableView indexPathForSelectedRow]) {
        [self enableToolBarButtons];
    }
    
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.fileTableView indexPathForSelectedRow]) {
        [self enableToolBarButtons];
    }
    else{
        [self disableToolBarButtons];
    }
    
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}


#pragma mark - Searchbar delegate methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        self.isFiltered = NO;
    }
    else{
        self.isFiltered = YES;
    }
    
    self.directoryContentsFiltered = [[NSMutableArray alloc] init];
    
    for (DirectoryObject *item in self.directoryContents) {
        
        NSString *filename = [item fileName];
        
        
        if ([[filename lowercaseString] hasPrefix:[searchText lowercaseString]]) {
            [self.directoryContentsFiltered addObject:item];
        }
    }
    
    [self.fileTableView reloadData];
}



-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    if(editing) {
        //Do something for edit mode
        [self.fileTableView setEditing: YES animated: YES];
    }
    
    else {
        //Do something for non-edit mode
        [self.fileTableView setEditing: NO animated: YES];
        [self disableToolBarButtons];
    }
    
}

/**
 *  Enables all items on toolbar
 */
-(void) enableToolBarButtons {
    
    [self.deleteBtn setEnabled:YES];
    [self.actionBtn setEnabled:YES];
    
    if ([[self.fileTableView indexPathsForSelectedRows] count] > 1 )
        [self.renameBtn setEnabled:NO];
    else
        [self.renameBtn setEnabled:YES];
    
    [self.zipBtn setEnabled:YES];
    
}


/**
 *  Diables all items on toolbar
 */
-(void) disableToolBarButtons {
    
    [self.deleteBtn setEnabled:NO];
    [self.actionBtn setEnabled:NO];
    [self.renameBtn setEnabled:NO];
    [self.zipBtn setEnabled:NO];
    
}


/**
 *  This returns a DirectoryObject* for a given index based on whether a user is searching or not.
 *
 *  @param indexPath Index path of object to be returned.
 *
 *  @return a DirectoryObject* for a given index based on whether a user is searching or not.
 */
-(DirectoryObject *)getDirectoryObjectAtIndexPathRow:(NSIndexPath *) indexPath {
    
    DirectoryObject *directoryObject = nil;
    
    if (!_isFiltered) {
        directoryObject = [self.directoryContents objectAtIndex:indexPath.row];
        
    }
    else {
        directoryObject = [self.directoryContentsFiltered objectAtIndex:indexPath.row];
    }
    
    return directoryObject;
}

/**
 *  This method is used to init the Directory with contents of a specified directory. Populates self.directoryContents
 *
 *  @param directoryPath Path to the directory
 */
-(void) populateDirectoryWithPath:(NSString *)directoryPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSLog(@"Documents Directory is:\n%@", directoryPath);
    NSLog(@"Directory Contents:\n%@", [fileManager contentsOfDirectoryAtPath:directoryPath error:&error]);
    
    self.directoryContents = [[NSMutableArray alloc] init];
    NSMutableArray *directoryList = [[NSMutableArray alloc] init];
    directoryList = [[fileManager contentsOfDirectoryAtPath:directoryPath error:&error] mutableCopy];
    
    //Get contents of Documents directory (folders)
    for(NSString *file in directoryList) {
        
        BOOL isDir = false;
        NSString *path = [directoryPath stringByAppendingPathComponent:file];
        
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        
        if(isDir) {
            
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            
            DirectoryObject *directoryObject = [[DirectoryObject alloc] initWithFileName:file filetype:@"directory" andFileAtt:attributes];
            [self.directoryContents addObject:directoryObject];
            
        }
        else {
            
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            
            DirectoryObject *directoryObject = [[DirectoryObject alloc] initWithFileName:file filetype:[file pathExtension] andFileAtt:attributes];
            [self.directoryContents addObject:directoryObject];
            
        }
    }
    
}

#pragma mark - File manipulation methods
/**
 *  Appends a digit to file name if it already exits in the self.current location. If the file name does not extist, the original string is returned
 *
 *  @param filename NSString containing the filen ame that should be appended
 *
 *  @return NSString containg a file name that is unique to the current location
 */
- (NSString *) appendDigitTofileName:(NSString *) filename {
    
    int fileCount = 0;
    NSString *pathExtension = [filename pathExtension];
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@" \\([^()]*\\)." options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString *trimmedFileName = [[filename lastPathComponent] stringByDeletingPathExtension];
    
    
    for (DirectoryObject* item in self.directoryContents) {
        
        NSString *modifiedString = [regex stringByReplacingMatchesInString:[item fileName] options:0 range:NSMakeRange(0, [[item fileName] length]) withTemplate:@"."];
        NSLog(@"Modified String: %@", modifiedString);

        
        if ([modifiedString isEqualToString:filename]) {
            fileCount++;
        }
    }
    
    if(fileCount > 0) {
        return [NSString stringWithFormat:@"%@ (%d).%@", trimmedFileName, fileCount, pathExtension];
    }
    else {
        return filename;
    }
}


/**
 *  Creates a new directory in a specified location
 *
 *  @param location The path to the directory that the new directory should be placed in
 *  @param name     The name of the new directory
 *
 *  @return NSString containing the path to the newly created directory
 */
- (NSString *) createDirectoryInDirectory:(NSString *) location withDirectoryName:(NSString *) name{
    
    NSError *error;
    NSString *dir = [self appendDigitTofileName:name];
    NSString *dirPath = [location stringByAppendingPathComponent:dir];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                              withIntermediateDirectories:YES
                                               attributes:@{ NSFilePosixPermissions : @(0777) }
                                                    error:&error];
    
    
    return dirPath;
}

/**
 *  Deletes a file or directory
 *
 *  @param path The path to the file or directory to be deleted. If a file is to be deleted, the filename and extension should be included in the path.
 *
 *  @return YES if a file at the specified path has beed deleted, or NO if the file has not been deleted.
 */
- (BOOL) deleteFileOrDirectoryWithPath:(NSString *) path {
    
    BOOL deleted = true;
    NSError *error;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {		//Does file exist?
        
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {	//Delete it
            deleted = false;
            NSLog(@"Delete file error: %@", error);
        }
    }
    
    return deleted;
}


/**
 *  Handles users' action of tapping the delete button on the bottom toolbar.
 *
 *  @param sender The calling Obj-C object (of any type). For all intents and purposes, this should be a UIButton.
 *  @see -(BOOL) deleteFileOrDirectoryWithPath(NSString *) path
 */
- (IBAction)deleteAction:(id)sender {
    
    //Get selected rows
    NSArray *indexPathArray = [self.fileTableView indexPathsForSelectedRows];
    
    for(NSIndexPath *indexPath in indexPathArray) {
        
        DirectoryObject *directoryObject = [self getDirectoryObjectAtIndexPathRow:indexPath];

        NSString *filePath = [self.currentDirectory stringByAppendingPathComponent:[directoryObject fileName]];
        
        [self deleteFileOrDirectoryWithPath:filePath];
    }
    
    //repopulate direcory
    [self populateDirectoryWithPath:self.currentDirectory];
    [self.fileTableView reloadData];
    [self setEditing:NO animated:YES];
    
}


/**
 *  Zipps file(s) or folder(s) and refreshes self.currentDirectory
 *
 *  @param sender The calling Obj-C object (of any type). For all intents and purposes, this should be a UIButton
 */
- (IBAction)zipAction:(id)sender {
    
    //Get selected rows
    NSArray *indexPathArray = [self.fileTableView indexPathsForSelectedRows]; //Array of NSIndexPaths
    
    //Check if more than one file is selected
    if ([indexPathArray count] == 1) {
        
        DirectoryObject *directoryObject = [self getDirectoryObjectAtIndexPathRow:[indexPathArray firstObject]];
        
        if ([[directoryObject fileType] isEqualToString:@"directory"]) {
            
            // Zip Directory
            NSString *defaultPathComponent = [self appendDigitTofileName:[NSString stringWithFormat:@"%@.zip", [directoryObject fileName]]];
            NSString *zipPath = [self.currentDirectory stringByAppendingPathComponent:defaultPathComponent];
            
            NSString *inputPath = [self.currentDirectory stringByAppendingPathComponent:[directoryObject fileName]];
            
            [ZipArchive createZipFileAtPath:zipPath
                    withContentsOfDirectory:inputPath];
            
        }
        else{
            
            // Zip File
            NSString *defaultPathComponent = [self appendDigitTofileName:@"Archive.zip"];
            NSString *zipPath = [self.currentDirectory stringByAppendingPathComponent:defaultPathComponent];
            
            NSArray *inputPath = @[[self.currentDirectory stringByAppendingPathComponent:[directoryObject fileName]]];
            
            [ZipArchive createZipFileAtPath:zipPath
                           withFilesAtPaths:inputPath];
        }
        
    }
    else {
        
        /*Note : Use of a temp directory because the ZipArchive class method, [ZipArchive createZipFileAtPath:zipPath withFilesAtPaths:inputPath], breaks when a multiple selection contains a directory*/
        
        // Create a temporary directory
        NSString *tempDir = [self createDirectoryInDirectory:self.currentDirectory
                                           withDirectoryName:@"96d5s2e2r5156adfa30rv5g1abfjnakjnfghbga"];
        
        // Copy zip items to temp directory
        for(NSIndexPath *index in indexPathArray) {
            
            DirectoryObject *directoryObject = [self.directoryContents objectAtIndex:index.row];
            NSString *filePath = [self.currentDirectory stringByAppendingPathComponent:[directoryObject fileName]];
            
            [[NSFileManager defaultManager] copyItemAtURL:[[NSURL alloc] initFileURLWithPath:filePath]
                                                    toURL:[[NSURL alloc] initFileURLWithPath:[tempDir stringByAppendingPathComponent:[directoryObject fileName]]]
                                                    error:nil];
        }
        
        // Zip Directory
        NSString *defaultPathComponent = [self appendDigitTofileName:@"Archive.zip"];
        NSString *zipPath = [self.currentDirectory stringByAppendingPathComponent:defaultPathComponent];
        
        NSString *inputPath = tempDir;
        
        [ZipArchive createZipFileAtPath:zipPath
                withContentsOfDirectory:inputPath];
        
        // Delete temp directory
        [self deleteFileOrDirectoryWithPath:tempDir];
        
    }
    
    //repopulate direcory
    [self populateDirectoryWithPath:self.currentDirectory];
    [self.fileTableView reloadData];
    [self setEditing:NO animated:YES];
    
    
}


/**
 *  <#Description#>
 *
 *  @param sender <#sender description#>
 */
- (IBAction)renameAction:(id)sender {
    
    UIAlertView *todoAlert = [[UIAlertView alloc] initWithTitle:@"Hold on a sec'"
                                                        message:@"I haven't implemented this part yet"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay, okay"
                                              otherButtonTitles: nil];
    
    [todoAlert show];
}

/**
 *  Presents and ActivityViewcontroller that allows the user to share a file. Note that folders cannot be shared unless they are zipped first.
 *
 *  @param sender The calling Obj-C object (of any type). For all intents and purposes, this should be a UIButton.
 */
- (IBAction)fileShareAction:(id)sender {
    
    //Get selected rows
    NSArray *indexPathArray = [self.fileTableView indexPathsForSelectedRows];
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    
    
    for(NSIndexPath *indexPath in indexPathArray) {
        
        DirectoryObject *directoryObject = [self getDirectoryObjectAtIndexPathRow:indexPath];
        
        
        NSString *filePath = [self.currentDirectory stringByAppendingPathComponent:[directoryObject fileName]];
        NSURL *file = [NSURL fileURLWithPath:filePath];
        [activityItems addObject:file];
        
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                             applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter];
    
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}



@end
