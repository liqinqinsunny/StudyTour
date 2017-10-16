//
//  WJPPhotoBrowseViewController.m
//  StudyTourLeaderSide
//
//  Created by use on 16/5/17.
//  Copyright © 2016年 wjp. All rights reserved.
//

#import "WJPPhotoBrowseViewController.h"
#import "WJPPhotoCollectionCell.h"

@interface WJPPhotoBrowseViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, weak) UILabel *locationLabel;
@end

@implementation WJPPhotoBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WJPPhotoCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WJPPhotoCollectionCell class])];
    [self createTopToolBar];
}

#pragma mark -- UICollection View Data Source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJPPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WJPPhotoCollectionCell class]) forIndexPath:indexPath];
    if (indexPath.row < _placeholdImageArray.count) {
        id value = _placeholdImageArray[indexPath.row];
        if ([value isKindOfClass:[NSNull class]]) {
            cell.placeholdImage = nil;
        } else {
            cell.placeholdImage = _placeholdImageArray[indexPath.row];
        }
    } else {
        cell.placeholdImage = nil;
    }
    
    cell.imageInfo = _imageArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth, ScreenHeight - 64);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:_myCollectionView.center toView:_myCollectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [_myCollectionView indexPathForItemAtPoint:pInView];
    // 赋值给记录当前坐标的变量
    
    NSInteger index = indexPathNow.row;
    NSString *locationText;
    if (index + 1 > _imageArray.count) {
        locationText = [NSString stringWithFormat:@"%ld/%ld", _imageArray.count, _imageArray.count];
    } else {
        locationText = [NSString stringWithFormat:@"%ld/%ld", index+1, _imageArray.count];
    }
    _locationLabel.text = locationText;
}

#pragma mark -- 创建视图
- (void)createTopToolBar
{
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    _scrollview = scrollview;
//    [self.view addSubview:_scrollview];
//    [self.view bringSubviewToFront:_scrollview];
//    _scrollview.delegate = self;
//    _scrollview.backgroundColor = [UIColor blackColor];
//    _scrollview.maximumZoomScale = 3.0;
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    toolBar.backgroundColor = [UIColor colorWithHex:0x2C3132];
    [self.view addSubview:toolBar];
//    _photoToolBar = toolBar;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(ScreenWidth - 60, 20, 44, 44);
    [deleteBtn setImage:[UIImage imageNamed:@"icon_photo_del"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:deleteBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"icon_photo_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popFromPhotoView) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-80)/2, 22, 80, 40)];
    titleLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex, _imageArray.count];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [toolBar addSubview:titleLabel];
    _locationLabel = titleLabel;
}

- (void)popFromPhotoView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deletePhoto
{
    if (self.deleteBlock) {
        CGPoint pInView = [self.view convertPoint:_myCollectionView.center toView:_myCollectionView];
        NSIndexPath *indexPathNow = [_myCollectionView indexPathForItemAtPoint:pInView];
        NSInteger index = indexPathNow.row;
        if (index < 0 || index >= _imageArray.count) {
            return;
        }
        NSMutableArray *tempArray = [_imageArray mutableCopy];
        [tempArray removeObjectAtIndex:index];
        _imageArray = [tempArray copy];
        
        [_myCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        self.deleteBlock(index);
        
        NSString *locationText;
        if (index + 1 > _imageArray.count) {
            locationText = [NSString stringWithFormat:@"%ld/%ld", _imageArray.count, _imageArray.count];
        } else {
            locationText = [NSString stringWithFormat:@"%ld/%ld", index+1, _imageArray.count];
        }
        _locationLabel.text = locationText;
        
        if (_imageArray.count <= 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark -- LifeCircle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _locationLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex+1, _imageArray.count];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!_isFromSuperViewController) {
        return;
    }
    _isFromSuperViewController = NO;
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    [_myCollectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
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
