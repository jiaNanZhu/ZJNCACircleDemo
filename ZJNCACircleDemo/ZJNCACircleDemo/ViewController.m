//
//  ViewController.m
//  ZJNCACircleDemo
//
//  Created by 朱佳男 on 2017/1/16.
//  Copyright © 2017年 ShangYuKeJi. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
@interface ViewController ()

@property (strong,nonatomic) CircleView *cv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mySlider addTarget:self action:@selector(valuechanged:) forControlEvents:UIControlEventValueChanged];
    
    self.cv = [[CircleView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 320/2, self.view.frame.size.height/2 - 320/2, 320, 320)];
    self.cv.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.cv];
    
    //首次进入
    self.cv.circleLayer.progress = _mySlider.value;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)valuechanged:(UISlider *)sender{
    
    self.contentLabel.text = [NSString stringWithFormat:@"Current:  %f",sender.value];
    self.cv.circleLayer.progress = sender.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
