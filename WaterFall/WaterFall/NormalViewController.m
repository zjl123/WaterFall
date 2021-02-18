//
//  NormalViewController.m
//  WaterFall
//
//  Created by zjl on 2021/2/7.
//

#import "NormalViewController.h"

@interface NormalViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *cellHeights;//cell高度
@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem  = rightItem;
//    self.collectionView.view
    self.layout.sectionHeadersPinToVisibleBounds = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    bool hasLabel = NO;
    UILabel *label = nil;
    for (UIView *view in cell.contentView.subviews) {
        if([view isKindOfClass:[UILabel class]]){
            hasLabel = YES;
            label = view;
        }
    }
   
    if(label == nil){
        label = [UILabel new];
        [cell.contentView addSubview:label];
        label.frame = CGRectMake(10, 0, 100, 30);
    }
   
    label.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.cellHeights.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.cellHeights[section];
    return arr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = 100;
    NSArray *arr = self.cellHeights[indexPath.section];
    return CGSizeMake(width, [arr[indexPath.row] floatValue]);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if(indexPath.section == 0){
        view.backgroundColor = [UIColor grayColor];
    }else{
        view.backgroundColor = [UIColor lightGrayColor];
    }
    
    return view;
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    //滚动监听
//    [self.waterFallLayout layoutAttributesForElementsInRect:CGRectMake(0, self.collectionView.contentOffset.y, CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame))];
//}
//-(CGSize )getHeaderSizeWithIndexPath:(NSIndexPath *)indexPath{
//   CGSize size =  [self collectionView:self.collectionView layout:_waterFallLayout referenceSizeForHeaderInSection:indexPath.section];
//    return size;
//}

-(void)rightClick{
    //刷新
    [_cellHeights removeAllObjects];
    _cellHeights = nil;
    [_collectionView reloadData];
}
-(NSMutableArray *)cellHeights{
    if(_cellHeights == nil){
        _cellHeights = [NSMutableArray array];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            CGFloat height = 100+arc4random()%101;
            [arr addObject:@(height)];
        }
        [_cellHeights addObject:arr];
        
        NSMutableArray *arr1 = [NSMutableArray array];
        for (int i = 0; i < 15; i++) {
            CGFloat height = 70+arc4random()%101;
            [arr1 addObject:@(height)];
        }
        [_cellHeights addObject:arr1];
        
    }
    return _cellHeights;
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
