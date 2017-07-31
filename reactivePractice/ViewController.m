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

  [self.textField.rac_textSignal subscribeNext:^(id x) {
    NSLog(@"%@", x);
  }];

  RACSignal *signal = [self creatSignal];
  [signal subscribeNext:^(id x) {
    NSLog(@"!!!!!!!!!!");
  }];
}

- (RACSignal *)creatSignal {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSLog(@"signal created");
    [subscriber sendNext:nil];
    return nil;
  }];
}


@end
