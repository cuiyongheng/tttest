//
//  TableViewCell.m
//  IMtest
//
//  Created by MAC on 2017/4/5.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}


- (void)createView {
    _playerView = [[ZSVideoManager alloc] init];
    _playerView.backgroundColor = [UIColor whiteColor];
    //    _playerView.enlargeButton.hidden = YES;
    [self.contentView addSubview:_playerView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playerView.frame = CGRectMake(0, 0, WIDTH, 300);
}

- (void)setURL:(NSString *)URL {
    _URL = URL;
    _playerView.videoUrl = URL;
}

- (void)setImg:(NSString *)img {
    _img = img;
    _playerView.imageUrl = img;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
