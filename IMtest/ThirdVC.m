//
//  ThirdVC.m
//  IMtest
//
//  Created by MAC on 2017/3/29.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "ThirdVC.h"
#import "TableViewCell.h"

@interface ThirdVC ()<UITableViewDataSource, UITableViewDelegate, ZSVideoManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) TableViewCell *currentPlayerCell;

@end

@implementation ThirdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 300;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"];

    _arr = @[@"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4", @"https://sslydjimg.jaadee.com/uploads/videos/2016/06/5760eecccef.mp4", @"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4", @"https://sslydjimg.jaadee.com/uploads/videos/2016/06/5760eecccef.mp4", @"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4", @"https://sslydjimg.jaadee.com/uploads/videos/2016/06/5760eecccef.mp4", @"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4", @"https://sslydjimg.jaadee.com/uploads/videos/2016/06/5760eecccef.mp4", @"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4", @"https://sslydjimg.jaadee.com/uploads/videos/2016/06/5760eecccef.mp4", @"http://wvideo.spriteapp.cn/video/2016/0215/56c1809735217_wpd.mp4", @"https://sslydjimg.jaadee.com/uploads/videos/2016/06/5760eecccef.mp4"];

}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.playerView.delegate = self;
    cell.URL = _arr[indexPath.row];
    cell.playerView.controlButton.tag = indexPath.row;
    
    return cell;
}

- (void)playOrPauseCurrentVideo:(ZSVideoManager *)manager indexRow:(NSInteger)buttonTag {
    if (_currentPlayerCell.playerView.playStatus == playStatusPlay) {
        [_currentPlayerCell.playerView stopPlay];
    }
    
    self.currentPlayerCell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:buttonTag inSection:0]];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *playCell = (TableViewCell *)cell;
    
    if (playCell.playerView.playStatus == playStatusPlay) {
        [playCell.playerView stopPlay];
        NSLog(@"1");
    }
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

@end
