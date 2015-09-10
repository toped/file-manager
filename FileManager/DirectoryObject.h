//
//  DirectoryObject.h
//  FileManager
//
//  Created by TopeD on 9/8/15.
//  Copyright (c) 2015 Tope Daramola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DirectoryObject : NSObject

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) NSDictionary *fileAttributes;
@property (nonatomic) bool isEmpty;


- (instancetype) initWithFileName:(NSString *)name filetype:(NSString *)type andFileAtt:(NSDictionary *)attributes;


@end
