//
//  reactiveSignInService.m
//  reactivePractice
//
//  Created by 許嘉元 on 2017/8/2.
//  Copyright © 2017年 許嘉元. All rights reserved.
//

#import "reactiveSignInService.h"

@implementation reactiveSignInService

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock {

  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    BOOL success = [username isEqualToString:@"user"] && [password isEqualToString:@"password"];
    completeBlock(success);
  });
}

@end
