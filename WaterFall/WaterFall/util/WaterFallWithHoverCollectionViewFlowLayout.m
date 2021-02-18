//
//  WaterFallWIthHoverCollectionViewFlowLayout.m
//  WaterFall
//
//  Created by zjl on 2021/2/7.
// 瀑布流+悬停

#import "WaterFallWithHoverCollectionViewFlowLayout.h"

@interface WaterFallWithHoverCollectionViewFlowLayout ()
///各列当前布局高度
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, assign) CGFloat contentHeight;//collectionView的contentSize的高度
@property (nonatomic, strong) NSMutableArray *attrsArray;//所有的布局属性（header+cell）
@property (nonatomic, assign) CGSize newBoundsSize;
@end
@implementation WaterFallWithHoverCollectionViewFlowLayout
-(void)prepareLayout{
    [super prepareLayout];
    self.contentHeight = 0;
    
   
    //清除之前的布局属性数据
    [self.attrsArray removeAllObjects];
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int i = 0; i < sectionCount; i++) {
        [self.columnHeights removeAllObjects];
        UICollectionViewLayoutAttributes *headerAttrs =  [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        NSMutableArray *sectionAttrArr = [NSMutableArray array];
       // headerAttrs.representedElementKind可以用来区分是header还是cell
        if(headerAttrs !=nil){
            NSLog(@"有header");
            [sectionAttrArr addObject:headerAttrs];
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
            [sectionAttrArr addObject:attrs];
            
        }
        [self.attrsArray addObject:sectionAttrArr];
    }
    
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if(indexPath.section == 0){
        attrs.frame = CGRectMake(0, 0, attrs.frame.size.width,attrs.frame.size.height);
    }else{
        attrs.frame = CGRectMake(0, self.contentHeight, attrs.frame.size.width,attrs.frame.size.height);
        self.contentHeight += attrs.frame.size.height;
    }
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
    attrs.zIndex = 1000*indexPath.section;
    return attrs;
}
//滑动过程中，cell会不断复用，系统会调用layoutAttributesForElementsInRect方法来获得当前可见区域的布局属性，由于所有的布局属性都缓存起来了，则只需要返回布局属性的frame和当前可见区域有交集的布局属性就行
-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"~~~~~~%@",NSStringFromCGRect(rect));
    NSLog(@"rectrect");
    NSMutableArray *rArray = [NSMutableArray array];
//    [self sectionHeaderStickCounter];
    for (NSMutableArray *mutArr in _attrsArray) {
        for (__strong UICollectionViewLayoutAttributes *cacheAttr in mutArr) {
            if(CGRectIntersectsRect(cacheAttr.frame, rect)){
                if([cacheAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
//                    UICollectionViewLayoutAttributes * attr = [self sectionHeaderStickCounter1WithAttributes:cacheAttr];
                    cacheAttr = [self sectionHeaderStickCounter1WithAttributes:cacheAttr];
//                    [rArray addObject:attr];
                }else{
//                    [rArray addObject:cacheAttr];
                }
                [rArray addObject:cacheAttr];
//                if([cacheAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
//                    UICollectionViewLayoutAttributes *attr =   [self sectionHeaderStickCounterWithCacheAttr:cacheAttr];
//                    [rArray addObject:attr];
//                    NSLog(@"********%@",NSStringFromCGRect(attr.frame));
//                }else{
//                    [rArray addObject:cacheAttr];
//                    NSLog(@"$$$$$$$$$$%@",NSStringFromCGRect(cacheAttr.frame));
//                }
                
            }
        }
    }
    
   
    return rArray;
}
//header停留
//-(UICollectionViewLayoutAttributes *)sectionHeaderStickCounterWithCacheAttr:(UICollectionViewLayoutAttributes *)attributes{
//    CGPoint origin = attributes.frame.origin;
//    if(attributes.indexPath.section == 0){
//        //只要往上滑动，就将header的y修改成collectionView.contentOffser.y
//        if(self.collectionView.contentOffset.y >= 0){
//            origin.y = self.collectionView.contentOffset.y;
//        }
//
//        NSArray *sectionArr1 = self.attrsArray[1];
////                NSArray *sectionArr0 = self.attrsArray[0];
//        UICollectionViewLayoutAttributes *headerAttr1 = sectionArr1.firstObject;
////                UICollectionViewLayoutAttributes *headerAttr0 = sectionArr1.firstObject;
//        if(self.collectionView.contentOffset.y <= headerAttr1.frame.origin.y){
//            origin.y = attributes.frame.origin.y;
//        }
//    }else{
//        NSArray *sectionArr1 = self.attrsArray[1];
//        UICollectionViewLayoutAttributes *headerAttr1 = sectionArr1.firstObject;
//        if(self.collectionView.contentOffset.y >= headerAttr1.frame.origin.y){
//            origin.y = self.collectionView.contentOffset.y;
//        }else{
//            origin.y = attributes.frame.origin.y;
//        }
//    }
//    attributes.zIndex = 2048;
//    CGRect frame = attributes.frame;
//    frame.origin = origin;
//    attributes.frame = frame;
//    return attributes;
//}
//header停留
-(UICollectionViewLayoutAttributes *)sectionHeaderStickCounter1WithAttributes:(UICollectionViewLayoutAttributes *)attributes{
//    NSArray *arr = _attrsArray[0];
//    UICollectionViewLayoutAttributes *attributes = arr[0];
    
    CGPoint origin = attributes.frame.origin;
    if(attributes.indexPath.section == 0){
        //只要往上滑动，就将header的y修改成collectionView.contentOffser.y
        if(self.collectionView.contentOffset.y >= 0){
            origin.y = self.collectionView.contentOffset.y;
        }
        
        NSArray *sectionArr1 = self.attrsArray[1];
        //                NSArray *sectionArr0 = self.attrsArray[0];
        UICollectionViewLayoutAttributes *headerAttr1 = sectionArr1.firstObject;
        //                UICollectionViewLayoutAttributes *headerAttr0 = sectionArr1.firstObject;
       // headerAttr1的高度小于attributess时
        if(headerAttr1.frame.origin.y < CGRectGetMaxY(attributes.frame)){
            origin.y = self.collectionView.contentOffset.y-(self.collectionView.contentOffset.y+attributes.frame.size.height-headerAttr1.frame.origin.y);
        }
        if(self.collectionView.contentOffset.y >= headerAttr1.frame.origin.y){
            origin.y = attributes.frame.origin.y;
        }
    }else{
        NSArray *sectionArr1 = self.attrsArray[1];
        UICollectionViewLayoutAttributes *headerAttr1 = sectionArr1.firstObject;
        if(self.collectionView.contentOffset.y >= headerAttr1.frame.origin.y){
            origin.y = self.collectionView.contentOffset.y;
        }
    }
    attributes.zIndex = 1000*attributes.indexPath.section+100;
    CGRect frame = attributes.frame;
    frame.origin = origin;
    attributes.frame = frame;
    return attributes;
}
-(void)sectionHeaderStickCounter{
    for (NSArray *arr in self.attrsArray) {
        UICollectionViewLayoutAttributes *attributes = arr[0];
        if([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
            CGPoint origin = attributes.frame.origin;
            if(attributes.indexPath.section == 0){
                //只要往上滑动，就将header的y修改成collectionView.contentOffser.y
                if(self.collectionView.contentOffset.y >= 0){
                    origin.y = self.collectionView.contentOffset.y;
                }
                
                NSArray *sectionArr1 = self.attrsArray[1];
//                NSArray *sectionArr0 = self.attrsArray[0];
                UICollectionViewLayoutAttributes *headerAttr1 = sectionArr1.firstObject;
//                UICollectionViewLayoutAttributes *headerAttr0 = sectionArr1.firstObject;
                if(self.collectionView.contentOffset.y >= headerAttr1.frame.origin.y){
                    origin.y = attributes.frame.origin.y;
                }
            }else{
                NSArray *sectionArr1 = self.attrsArray[1];
                UICollectionViewLayoutAttributes *headerAttr1 = sectionArr1.firstObject;
                if(self.collectionView.contentOffset.y >= headerAttr1.frame.origin.y){
                    origin.y = self.collectionView.contentOffset.y;
                }
            }
            attributes.zIndex = 2048;
            CGRect frame = attributes.frame;
            frame.origin = origin;
            attributes.frame = frame;
        }
       
    }
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
//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    if(CGSizeEqualToSize(newBounds.size, self.newBoundsSize)){
//        return NO;
//    }
//    self.newBoundsSize = newBounds.size;
//    return YES;
//}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
@end
