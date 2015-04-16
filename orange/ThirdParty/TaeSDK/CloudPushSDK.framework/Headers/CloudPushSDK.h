//
//  CloudPushSDK.h
//  CloudPushSDK
//
//  Created by wuxiang on 14-8-27.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCPURLRequest.h"
#import "CCPURLResponse.h"
#import "CCPRequestOperation.h"

#define CCP_VERSION = "1.2.6";

typedef enum{
    CCPSDKEnvironmentDaily,  //测试环境
    CCPSDKEnvironmentPre,//预发环境
    CCPSDKEnvironmentSandBox,// 沙箱环境
    CCPSDKEnvironmentRelease//线上环境
} CCPSDKEnvironmentEnum;


typedef void (^CCPOperateResult)(BOOL success);
typedef void (^initChannelSuccessCallback)();
typedef void (^initChannelFailCallback)(NSError *error);

@protocol CloudPushSDKServiceDelegate <NSObject>

-(void) messageReceived:(NSData*)content msgId:(NSInteger) msgId;

@end

@interface CloudPushSDK : NSObject<CloudPushSDKServiceDelegate>


@property (strong, nonatomic) id<CloudPushSDKServiceDelegate> delegate;



/**
 *  云tcp 通道初始化
 *
 *  @param sid 基于账号体系生成的 sessionId
 *  @param appKey 基于 top app 体系的 appKey
 *  @param account 初始化通道带上的用户名，选填，用于信息推送
 */
+(void) initWithChannel:(NSString *) sid appKey:(NSString *)appKey  account:(NSString *) account;



/**
 * 只使用云推送通道的初始化入口
 */
+(void)asyncInit:(initChannelSuccessCallback) sucessCallback
  failedCallback:(initChannelFailCallback) failedCallback account:(NSString *) account;
/**
 *  关闭通道
 *
 *  @param sid
 */
+(void) closeChannel:(NSString *) sid;
/**
 *  设置环境变量
 *
 *  @param env
 */
+ (void) setEnvironment: (CCPSDKEnvironmentEnum) env;


/**
 *  得到本机的deviceId
 *
 *  @return
 */
+(NSString *) getDeviceId;
/**
 *  用户通过通知打开应用，检查lanchOptions，主要用来发送统计回执
 *
 *  @param launchOptions
 */
+(void)handleLaunching:(NSDictionary *)launchOptions;


/**
 *  处理苹果anps 推送下来的消息，主要是用来统计回执
 *
 *  @param userInfo
 */
+(void)handleReceiveRemoteNotification:(NSDictionary *)userInfo;


/**
 * 设置账号
 */
+(void) bindAccount:(NSString *) account withCallback:(CCPOperateResult) callback;

/**
 *  去除账号绑定
 *
 *  @param account 账号
 */
+(void) unbindAccount: (NSString *) account withCallback:(CCPOperateResult) callback;


+(void) setAcceptTime:(UInt32) startH startMS:(UInt32) startMS endH:(UInt32)endH endMS: (UInt32)endMS withCallback:(CCPOperateResult) callback;


/**
 *  注销设备，不再接收消息推送，apns与CloudPush两个通道都关闭
 *
 */
+(void)unRegisterApp;

/**
 *  对外提供 json 序化列的方法
 *
 *  @param dict
 *
 *  @return
 */
+ (NSString *) toJson: (NSDictionary * )dict;


+(void) executeRequest:(CCPURLRequest *) ccpRequest success :(successCallBack) successCallBack failure: (failureCallBack)failureCallBack timeout:(NSTimeInterval) timeout;


/**
 *  http
 *
 *  @param ccpRequest
 *  @param successCallBack
 *  @param failureCallBack
 */
+(void) executeHttpRequest:(CCPURLRequest *) ccpRequest success :(successCallBack) successCallBack failure: (failureCallBack)failureCallBack timeout:(NSTimeInterval) timeout;



/**
 * 获取deiviceToken
 *
 */
+(NSString *)getDeviceToken:(NSData *)deviceToken;

/**
 *  是否允许程序进入后台时，还保留长连接 默认是 true 保留
 *
 *  @param isRun
 */
+(void) setBackground:(BOOL) isRun;

/**
 * 得到推送的当前版本
 **/
+(NSString *) getVersion;


/**
 *  会将deviceToken放至服务器，然后获取通道里的基本信息
 *
 *  @param deviceToken 苹果apns 服务器推送下来的 deviceToken
 *
 *  @return
 */
+(void)registerDevice:(NSData *) deviceToken;



@end
