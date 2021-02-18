//
//  WaterFallCollectionViewFlowLayout.m
//  test630
//
//  Created by zjl on 2021/1/20.
//  Copyright © 2021 zjl. All rights reserved.
//

#import "WaterFallCollectionViewFlowLayout.h"

@interface WaterFallCollectionViewFlowLayout ()
///各列当前布局高度
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, assign) CGFloat contentHeight;

//@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong) NSMutableArray *attrsArray;
//@property (nonatomic, assign) CGFloat columnMargin;
@end
@implementation WaterFallCollectionViewFlowLayout
-(void)prepareLayout{
    [super prepareLayout];
    self.contentHeight = 0;
    
   
    //清除之前的布局属性数据
    [self.attrsArray removeAllObjects];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int i = 0; i < sectionCount; i++) {
        [self.columnHeights removeAllObjects];
        UICollectionViewLayoutAttributes *headerAttrs =  [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
       // headerAttrs.representedElementKind可以用来区分是header还是cell
        if(headerAttrs !=nil){
//            NSLog(@"有header");
            [self.attrsArray addObject:headerAttrs];
            
            for (int i = 0; i < self.columnCount; i++) {
                [self.columnHeights addObject:@(CGRectGetMaxY(headerAttrs.frame))];
            }
        }else{
            [self.attrsArray addObject:[UICollectionViewLayoutAttributes new]];
            for (int i = 0; i < self.columnCount; i++) {
                [self.columnHeights addObject:@(self.sectionInset.top+self.contentHeight)];
            }
        }
        //通过数据源拿到需要展示的cell数量
        NSInteger count = [self.collectionView numberOfItemsInSection:i];
        //楷书创建每个cell对应的布局属性
        for (NSInteger index = 0; index < count; index++) {
            //创建indexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:i];
            //获取cell布局属性，在layoutAttributesForItemAtIndexPath
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attrs];
            
        }
    }
    for (UICollectionViewLayoutAttributes *attrs in self.attrsArray) {
        NSLog(@"%@",attrs);
    }
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
   CGSize newSize =  [self.waterFallDelegate getHeaderSizeWithIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attrs = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if(indexPath.section == 0){
        attrs.frame = CGRectMake(0, 0, attrs.frame.size.width,attrs.frame.size.height);
    }else{
        attrs.frame = CGRectMake(0, self.contentHeight, newSize.width,newSize.height);
        
    }
    self.contentHeight += attrs.frame.size.height;
    attrs.zIndex = 2048;
    return attrs;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //获取一个UICollectionViewLayoutAttributes对象
    UICollectionViewLayoutAttributes *attrs = [super layoutAttributesForItemAtIndexPath:indexPath];
    //列数是3，布局属性的宽度是固定的
//    CGFloat collectionW = self.collectionView.frame.size.width;
//    [self.collectionView.delegate collectionvi]
    CGFloat width = attrs.frame.size.width;
    CGFloat height = attrs.frame.size.height;
//    CGFloat width = (collectionW-self.sectionInset.left-self.sectionInset.right-(self.columnCount-1)*self.self.minimumInteritemSpacing)/self.columnCount;
//    CGFloat height = 100+arc4random()%101;
    //找到组内目前高度最小的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (int i = 1; i < self.columnHeights.count; i++) {
        if(minColumnHeight > [self.columnHeights[i] doubleValue]){
            minColumnHeight = [self.columnHeights[i] doubleValue];
            destColumn = i;
        }
    }
    //根据列信息，计算出origin的x
    CGFloat x = self.sectionInset.left+destColumn*(width+self.minimumInteritemSpacing);
    CGFloat y = minColumnHeight;
    if(y != self.sectionInset.top){
        y+=self.minimumLineSpacing;
    }
    attrs.frame = CGRectMake(x, y, width, height);
    //更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    //更新记录战术布局需要的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if(self.contentHeight < columnHeight){
        self.contentHeight = columnHeight;
    }
    return attrs;
}
//滑动过程中，cell会不断复用，系统会调用layoutAttributesForElementsInRect方法来获得当前可见区域的布局属性，由于所有的布局属性都缓存起来了，则只需要返回布局属性的frame和当前可见区域有交集的布局属性就行
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *rArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *cacheAttr in _attrsArray) {
        if(CGRectIntersectsRect(cacheAttr.frame, rect)){
            [rArray addObject:cacheAttr];
        }
    }
    return rArray;
}
//由于我们自定义了每个cell的高度和布局，所以系统不知道UICollectionView当前的contentSize的大小，所以我们需要在collectionViewContentSize方法里返回正确的size以确保所有cell都哼正常滑动到可见区域里来
-(CGSize)collectionViewContentSize{
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.contentHeight+self.sectionInset.bottom);
}
-(NSMutableArray *)columnHeights{
    if(_columnHeights == nil){
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
-(NSMutableArray *)attrsArray{
    if(_attrsArray == nil){
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
@end
