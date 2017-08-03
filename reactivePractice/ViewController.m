//
//  ViewController.m
//  reactivePractice
//
//  Created by 許嘉元 on 2017/7/31.
//  Copyright © 2017年 許嘉元. All rights reserved.
//  Practice from "https://www.raywenderlich.com/62699/reactivecocoa-tutorial-pt1"
//

#import "ViewController.h"
#import <ReactiveCocoa.h>
#import "reactiveSignInService.h"

@interface ViewController ()

@property (strong, nonatomic) reactiveSignInService *signInService;

@end

@implementation ViewController


- (void)viewDidLoad {
  [super viewDidLoad];

  RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id(id value) {
    NSString *text = value;
    return @([self isValidUsername:text]);
  }];

  RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(id value) {
    NSString *text = value;
    return @([self isValidPassword:text]);
  }];

  RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
    return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
  }];

  RAC(self.usernameTextField, backgroundColor) = [validUsernameSignal map:^id(NSNumber *passwordValid) {
    return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
  }];

  RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                                                    reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
                                                      return @([usernameValid boolValue] && [passwordValid boolValue]);
                                                    }];

  [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
    self.signInButton.enabled = [signupActive boolValue];
    //self.signInFailureText.text = [signupActive stringValue];
  }];

  [[[[self.signInButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     doNext:^(id x) {
       self.signInButton.enabled = NO;
       self.signInFailureText.hidden = YES;
     }]
    flattenMap:^id(id x) {
      return [self signInSignal];
    }]
   subscribeNext:^(NSNumber *signedIn) {
     self.signInButton.enabled = YES;
     BOOL success = [signedIn boolValue];
     self.signInFailureText.hidden = success;
     if (success) {
       [self performSegueWithIdentifier:@"signInSuccess" sender:self];
     }
   }];

  // example 1
  __block int num = 0;
  RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id  subscriber) {
    num++;
    NSLog(@"Increment num to: %i", num);
    [subscriber sendNext:@(num)];
    return nil;
  }];

  NSLog(@"Start subscriptions");

  // Subscriber 1 (S1)
  [signal subscribeNext:^(id x) {
    NSLog(@"S1: %@", x);
  }];

  // Subscriber 2 (S2)
  [signal subscribeNext:^(id x) {
    NSLog(@"S2: %@", x);
  }];

  // Subscriber 3 (S3)
  [signal subscribeNext:^(id x) {
    NSLog(@"S3: %@", x);
  }];


  // example 2

  RACSubject *letters = [RACSubject subject];
  RACSignal *signal1 = letters;

  NSLog(@"Subscribe S1");
  [signal1 subscribeNext:^(id x) {
    NSLog(@"S1: %@", x);
  }];

  NSLog(@"Send A");
  [letters sendNext:@"A"];
  NSLog(@"Send B");
  [letters sendNext:@"B"];

  NSLog(@"Subscribe S2");
  [signal1 subscribeNext:^(id x) {
    NSLog(@"S2: %@", x);
  }];

  NSLog(@"Send C");
  [letters sendNext:@"C"];
  NSLog(@"Send D");
  [letters sendNext:@"D"];

  NSLog(@"Subscribe S3");
  [signal1 subscribeNext:^(id x) {
    NSLog(@"S3: %@", x);
  }];
}

- (BOOL)isValidUsername:(NSString *)username {
  return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
  return password.length > 3;
}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      [self.signInService
       signInWithUsername:self.usernameTextField.text
       password:self.passwordTextField.text
       complete:^(BOOL success) {
         [subscriber sendNext:@(success)];
         [subscriber sendCompleted];
       }];
      return nil;
    }];
}

@end
