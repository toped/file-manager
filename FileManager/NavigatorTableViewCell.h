//
//  ScheduleTableViewCell.h
//  EventSchedule
//
//  Created by CTOstudent on 1/6/15.
//  Copyright (c) 2015 CTOstudent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigatorTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *fileNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateModifiedLabel;
@property (nonatomic, strong) IBOutlet UILabel *fileSizeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *fileIcon;



@end
