//
//  ViewController.m
//  IMtest
//
//  Created by MAC on 2017/3/29.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "IFAccelerometer.h"
#import <MWPhotoBrowser.h>
#import <UIImageView+WebCache.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UMSocialNetwork/UMSocialNetwork.h>
#import <UShareUI/UShareUI.h>
#import "NextVC.h"
#import "ThirdVC.h"
#import <LPDQuoteImagesView.h>

@interface ViewController ()<MWPhotoBrowserDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *photoArr;

@property (nonatomic, strong) NSMutableArray *photobrowserArr;

@property (nonatomic, strong) NSMutableDictionary *seleteDic;

@property (nonatomic, strong) UIView *photoView;

@end

@implementation ViewController

{
    MWPhotoBrowser *browser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.photoArr = [NSMutableArray arrayWithObjects:@"https://imgssl.jaadee.com/images/201703/thumb_img/33743_d8dfd577f0a.jpg",
                     @"https://imgssl.jaadee.com/images/201703/thumb_img/33742_d8dfd4f125c.jpg",
                     @"https://imgssl.jaadee.com/images/201703/thumb_img/33741_d8dfd478ff0.jpg",
                     @"https://imgssl.jaadee.com/images/201703/thumb_img/33740_d8dfd26c19a.jpg",
                     @"https://imgssl.jaadee.com/images/201703/thumb_img/33738_d8dfcea5629.jpg", nil];
    
    self.photobrowserArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *url in _photoArr) {
        [_photobrowserArr addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url]]];
    }
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(shareAction:)];
    
    self.seleteDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 400, 100, 100);
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *photobutton = [UIButton buttonWithType:UIButtonTypeCustom];
    photobutton.frame = CGRectMake(250, 400, 100, 100);
    photobutton.backgroundColor = [UIColor redColor];
    [photobutton addTarget:self action:@selector(photobutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photobutton];
    
    _photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 500, WIDTH, 100)];
    _photoView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_photoView];
}

- (void)pushNext:(UIButton *)button {
    NextVC *nextVC = [[NextVC alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell.imageView sd_setImageWithURL:self.photoArr[indexPath.row]];
    // Optionally set the current visible photo before displaying
    
    return cell;
}

//- (void)accelerateWithX:(NSNumber *)x withY:(NSNumber *)y withZ:(NSNumber *)z withTimeInterval:(NSTimeInterval)timeInterval
//{
//    NSLog(@"%@------%@-------%@-------%f------%f", x, y, z,timeInterval);
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isEditing) {
        // 编辑中 选中
        
        [self.seleteDic setObject:indexPath forKey:self.photoArr[indexPath.row]];
        
    } else {
        browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        //    browser.autoPlayOnAppear = NO; // Auto-play first video
        
        // Customise selection images to change colours if required
        //    browser.customImageSelectedIconName = @"ImageSelected.png";
        //    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
        
        // Manipulate
        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];
        //    [browser setCurrentPhotoIndex:2];
        
        // Present
        [self.navigationController pushViewController:browser animated:YES];
        [browser setCurrentPhotoIndex:indexPath.row];
    }
}


#pragma mark - photoPicker
- (void)photobutton:(UIButton *)button {
//    //1.初始化一个XMNPhotoPickerController
//    XMNPhotoPickerController *photoPickerC = [[XMNPhotoPickerController alloc] initWithMaxCount:9 delegate:nil];
//    //3.取消注释下面代码,使用代理方式回调,代理方法参考XMNPhotoPickerControllerDelegate
//    //    photoPickerC.photoPickerDelegate = self;
//    
//    //3..设置选择完照片的block 回调
//    __weak typeof(*&self) wSelf = self;
//    [photoPickerC setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
//        __weak typeof(*&self) self = wSelf;
//        NSLog(@"picker images :%@ \n\n assets:%@",images,assets);
//        
//        //!!!如果需要自定义大小的图片 使用下面方法
//        //        [[XMNPhotoManager sharedManager] getThumbnailWithAsset:<# asset in assets #> size:<# your size #> completionBlock:^(UIImage * _Nullable image) {
//        //
//        //        }];
//        
////        self.assets = [assets copy];
////        [self.collectionView reloadData];
//        //XMNPhotoPickerController 确定选择,并不会自己dismiss掉,需要自己dismiss
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    //4.设置选择完视频的block回调
//    [photoPickerC setDidFinishPickingVideoBlock:^(UIImage *coverImage, XMNAssetModel * asset) {
//        __weak typeof(*&self) self = wSelf;
//        NSLog(@"picker image :%@\n\n asset:%@\n\n",coverImage,asset);
////        self.assets = @[asset];
////        [self.collectionView reloadData];
//        //XMNPhotoPickerController 确定选择,并不会自己dismiss掉,需要自己dismiss
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    //5.设置用户取消选择的回调 可选
//    [photoPickerC setDidCancelPickingBlock:^{
//        NSLog(@"photoPickerC did Cancel");
//        //此处不需要自己dismiss
//    }];
//    
//    //6. 显示photoPickerC
//    [self presentViewController:photoPickerC animated:YES completion:nil];
    
    
    LPDQuoteImagesView *quoteImagesView =[[LPDQuoteImagesView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) withCountPerRowInView:5 cellMargin:12];
    //初始化view的frame, view里每行cell个数， cell间距（上方的图片1 即为quoteImagesView）
    
    quoteImagesView.maxSelectedCount = 6;
    //最大可选照片数
    
    quoteImagesView.collectionView.scrollEnabled = NO;
    //view可否滑动
    
    quoteImagesView.navcDelegate = self;    //self 至少是一个控制器。
    //委托（委托controller弹出picker，且不用实现委托方法）
    
    [_photoView addSubview:quoteImagesView];
    //把view加到某一个视图上，就什么都不用管了！！！！
    
    
}




#pragma mark - edit
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [self.seleteDic removeObjectForKey:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)edit:(UIBarButtonItem *)button {
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    
    if (!self.tableView.isEditing) {
        NSArray *array = [self.seleteDic allKeys];
        [self.photoArr removeObjectsInArray:array];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[self.seleteDic allValues]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationAutomatic];
}







#pragma mark - photoBrowser
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photobrowserArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photobrowserArr.count) {
        return [self.photobrowserArr objectAtIndex:index];
    }
    return nil;
}








#pragma mark - shareAction
- (void)shareAction:(UIBarButtonItem *)button {
    //    [self UMShare];
    
    [self initActivityVC];
}

- (void)initActivityVC {
    
    UIImage *imageToShare = [UIImage imageNamed:@"和田玉@2x.png"];
    UIImage *imageToShare1 = [UIImage imageNamed:@"南红所有类型.png"];
    UIImage *imageToShare2 = [UIImage imageNamed:@"琥珀蜜蜡@2x.png"];
    UIImage *imageToShare3 = [UIImage imageNamed:@"南红耳饰@2x.png"];
    UIImage *imageToShare4 = [UIImage imageNamed:@"南红戒指@2x.png"];
    NSArray *activityItems = @[imageToShare,imageToShare1];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (void)UMShare {
    __weak typeof(self)WeakSelf = self;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [WeakSelf shareImageAndTextToPlatformType:platformType];
    }];
    
}

- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = @"我要发多张图片，谁也拦不住！";
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    //    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:@"https://imgssl.jaadee.com/images/201703/thumb_img/33743_d8dfd577f0a.jpg"];
    [shareObject setShareImage:@"https://imgssl.jaadee.com/images/201703/thumb_img/33742_d8dfd4f125c.jpg"];
    [shareObject setShareImage:@"https://imgssl.jaadee.com/images/201703/thumb_img/33741_d8dfd478ff0.jpg"];
    [shareObject setShareImage:@"https://imgssl.jaadee.com/images/201703/thumb_img/33740_d8dfd26c19a.jpg"];
    [shareObject setShareImage:@"https://imgssl.jaadee.com/images/201703/thumb_img/33738_d8dfcea5629.jpg"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
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
