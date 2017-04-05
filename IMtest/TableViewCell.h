//
//  TableViewCell.h
//  IMtest
//
//  Created by MAC on 2017/4/5.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSVideoManager.h"

@interface TableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *URL;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, strong) ZSVideoManager *playerView;

@end
