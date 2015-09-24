//
//  QRCode.h
//  QRCode
//
//  Created by rc on 15/9/24.
//  Copyright © 2015年 rc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*容错度 越高越容易识别*/
typedef NS_ENUM(NSInteger, ErrorCorrection) {
    ErrorCorrectionLow,
    ErrorCorrectionMedium,
    ErrorCorrectionQuartile,
    ErrorCorrectionHigh,
};

@interface QRCode : NSObject

/*二维码内容*/
@property (nonatomic,strong) NSString *dataString;
/*二维码Size*/
@property (nonatomic,assign) CGSize  size;
/*容错度*/
@property (nonatomic,assign) ErrorCorrection errorCorrection;
/*二维码背景色*/
@property (nonatomic,strong) UIColor *backgroudColor;
/*二维码颜色*/
@property (nonatomic,strong) UIColor *frontColor;
/*中心Icon*/
@property (nonatomic,strong) UIImage *iconImage;
/*中心Icon圆角*/
@property (nonatomic,assign) CGFloat iconRadius;
/*中心Icon边框颜色*/
@property (nonatomic,strong) UIColor *iconBorderColor;
/*中心Icon边框宽*/
@property (nonatomic,assign) CGFloat iconBorderWidth;

/*生成的二维码Image*/
-(UIImage *)qrImage;


@end
