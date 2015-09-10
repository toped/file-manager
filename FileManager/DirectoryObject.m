//
//  DirectoryObject.m
//  FileManager
//
//  Created by TopeD on 9/8/15.
//  Copyright (c) 2015 Tope Daramola. All rights reserved.
//

#import "DirectoryObject.h"

@implementation DirectoryObject


- (instancetype) initWithFileName:(NSString *)name filetype:(NSString *)type andFileAtt:(NSDictionary *)attributes {
    
    self = [super init];
    if (self) {
        _fileName = name;
        _fileType = type;
        _fileAttributes = attributes;
    }
    
    return self;
}

@end
