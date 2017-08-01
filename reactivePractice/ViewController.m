//
//  ViewController.m
//  reactivePractice
//
//  Created by 許嘉元 on 2017/7/31.
//  Copyright © 2017年 許嘉元. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.usernameTextField.rac_textSignal subscribeNext:^(id x) {
    NSLog(@"%@", x);
  }];
}


@end
