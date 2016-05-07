//
//  XXBViewController.m
//  XXBTouchIDDemo
//
//  Created by xiaobing on 16/5/7.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface XXBViewController ()

- (IBAction)judgeTouchID:(id)sender;
@end

@implementation XXBViewController


- (IBAction)judgeTouchID:(id)sender {
    [self authenticateUser];
}

- (void)touchIDTest {
    LAContext *laContext = [[LAContext alloc] init];
    NSError *error;
    
    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:@"Touch Id Test"
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    NSLog(@"success to evaluate");
                                    //do your work
                                }
                                if (error) {
                                    NSLog(@"---failed to evaluate---error: %@---", error.description);
                                    //do your error handle
                                }
                            }];
    }
    else {
        NSLog(@"==========Not support :%@", error.description);
        //do your error handle
    }
}
- (void)authenticateUser
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"XXBTouchIDDemo 请验证你的指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                    {
                        
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            NSLog(@"用户选择输入密码");
                        }];
                        break;
                    }
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        
                    }
                    case LAErrorTouchIDLockout:
                    {
                        
                    }
                    case LAErrorAppCancel:
                    {
                        
                    }
                    case LAErrorInvalidContext:
                    {
                        
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}
@end
