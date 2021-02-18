//
//  WaterFallWIthHoverCollectionViewFlowLayout.h
//  WaterFall
//
//  Created by zjl on 2021/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WaterFallHoverDelegate <NSObject>
//获取header的size
-(CGSize)getHeaderSizeWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface WaterFallWithHoverCollectionViewFlowLayout : UICollectionViewFlowLayout
///列数
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, weak) id<WaterFallHoverDelegate> waterFallHoverDelegate;
@end

NS_ASSUME_NONNULL_END
