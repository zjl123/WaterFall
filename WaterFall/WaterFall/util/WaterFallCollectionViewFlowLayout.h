//
//  WaterFallCollectionViewFlowLayout.h
//  test630
//
//  Created by zjl on 2021/1/20.
//  Copyright © 2021 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WaterFallDelegate <NSObject>
//获取header的size
-(CGSize)getHeaderSizeWithIndexPath:(NSIndexPath *)indexPath;

@end
@interface WaterFallCollectionViewFlowLayout : UICollectionViewFlowLayout
///列数
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, weak) id<WaterFallDelegate> waterFallDelegate;
@end

NS_ASSUME_NONNULL_END
