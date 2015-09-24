//
//  QRCode.m
//  QRCode
//
//  Created by rc on 15/9/24.
//  Copyright © 2015年 rc. All rights reserved.
//

#import "QRCode.h"
#define DEFAULT_VOID_COLOR [UIColor clearColor]

@interface UIColor (CIColorFix)

@end
@implementation UIColor (CIColorFix)
-(CIColor *)CIColor {
    CGFloat rgba[4];
    [self getRed:&rgba[0] green:&rgba[1] blue:&rgba[2] alpha:&rgba[3]];
    return [CIColor colorWithRed:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
}
@end
@interface QRCode()
@end

@implementation QRCode

- (instancetype)init {

    self = [super init];
    if (self) {

        self.frontColor = [UIColor blackColor];
        self.backgroudColor = [UIColor whiteColor];
        self.size = CGSizeMake(200, 200);
        self.errorCorrection = ErrorCorrectionLow;
        self.iconImage = nil;
        self.iconBorderWidth = 0;
        self.iconBorderColor = [UIColor whiteColor];
        self.iconRadius = 0;

    }
    return self;
}

- (NSString *)correctionLevel:(ErrorCorrection)erroCorrection {

    NSString *correctionLevel = @"";
    switch (erroCorrection) {
        case ErrorCorrectionLow:
            correctionLevel = @"L";
            break;
        case ErrorCorrectionMedium:
            correctionLevel = @"M";
            break;
        case ErrorCorrectionQuartile:
            correctionLevel = @"Q";
            break;
        case ErrorCorrectionHigh:
            correctionLevel = @"H";
            break;
        default:
            break;
    }
    return correctionLevel;
}
- (CIImage*)createQRForString:(NSString*)qrString {
    
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:[self correctionLevel:self.errorCorrection] forKey:@"inputCorrectionLevel"];
    
    
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setValue:qrFilter.outputImage forKey:@"inputImage"];
    [colorFilter setValue:self.frontColor.CIColor forKey:@"inputColor0"];
    [colorFilter setValue:self.backgroudColor.CIColor forKey:@"inputColor1"];
    
    UIImage *qrImage = [[UIImage alloc] initWithCIImage:colorFilter.outputImage];

    CGFloat scale = (self.size.width/qrImage.size.width);
    
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CIImage *scaledQRImage = [colorFilter.outputImage imageByApplyingTransform:transform];

    return scaledQRImage;
}

- (UIImage *)makeRoundCornersWithRadius:(CGFloat)radius
                                  image:(UIImage *)originImage
                            borderColor:(UIColor *)color
                           boarderWidth:(CGFloat)width {


    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, originImage.scale);
    CGRect rect  = CGRectMake(0, 0, originImage.size.width, originImage.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextRef context =  UIGraphicsGetCurrentContext();
    [path addClip];
    CGContextSaveGState(context);

    [originImage drawInRect:rect];
    CGContextRestoreGState(context);
    
    path.lineWidth = width;
    [color setStroke];
    [path stroke];

    
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}
- (UIImage *)qrImage {

    CIImage *qrCIImage = [self createQRForString:self.dataString];
    UIImage *qrImage   = [UIImage imageWithCIImage:qrCIImage];
    if (self.iconImage) {
        
        
        UIGraphicsBeginImageContextWithOptions(qrImage.size, NO, qrImage.scale);
        [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
        
        UIImage *roundImage = [self makeRoundCornersWithRadius:self.iconRadius image:self.iconImage borderColor:self.iconBorderColor boarderWidth:self.iconBorderWidth];
        [roundImage drawInRect:CGRectMake((qrImage.size.width - self.iconImage.size.width) * 0.5f,
                                     (qrImage.size.height - self.iconImage.size.height) * 0.5f,
                                     self.iconImage.size.width, self.iconImage.size.height)];
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return resultImage;
    }

    return qrImage;

}
@end
