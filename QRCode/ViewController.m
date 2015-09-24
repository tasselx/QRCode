//
//  ViewController.m
//  QRCode
//
//  Created by rc on 15/9/24.
//  Copyright © 2015年 rc. All rights reserved.
//

#import "ViewController.h"
#import "QRCode.h"
@interface ViewController ()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100,300 , 300)];
    
    _imageView.image = ({
    
        QRCode *qrcode = [[QRCode alloc] init];
        qrcode.dataString = @"www.baidu.com";
        qrcode.size = _imageView.bounds.size;
        qrcode.errorCorrection = ErrorCorrectionHigh;
        qrcode.frontColor = [UIColor redColor];
        qrcode.backgroudColor = [UIColor cyanColor];
        qrcode.iconImage  = [UIImage imageNamed:@"dog.jpg"];
        qrcode.iconRadius = 8;
        qrcode.iconBorderWidth = 10;
        qrcode.iconBorderColor = [UIColor whiteColor];
        [qrcode qrImage];
    
    });
    
    [self.view addSubview:_imageView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 420, self.view.bounds.size.width-20*2, 20)];
    slider.value = 1;
    [slider addTarget:self action:@selector(changeImageViewScale:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    
    
    UIButton *saveToAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveToAlbumBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [saveToAlbumBtn setFrame:CGRectMake(0, 450, self.view.frame.size.width, 40)];
    [saveToAlbumBtn setTitle:@"保存到相册" forState:UIControlStateNormal];
    [saveToAlbumBtn addTarget:self action:@selector(saveToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveToAlbumBtn];
}

- (void)changeImageViewScale:(UISlider *)slider {
    _imageView.transform = CGAffineTransformMakeScale(slider.value, slider.value);
}

- (void)saveToAlbum {

    UIImageWriteToSavedPhotosAlbum(_imageView.image, self, nil, NULL);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
