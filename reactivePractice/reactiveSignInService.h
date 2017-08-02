//
//  reactiveSignInService.h
//  reactivePractice
//
//  Created by 許嘉元 on 2017/8/2.
//  Copyright © 2017年 許嘉元. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RWSignInResponse)(BOOL);

@interface reactiveSignInService : NSObject

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock;

@end
