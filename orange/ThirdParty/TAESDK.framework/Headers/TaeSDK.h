//
//  TaeSDK.h
//  taesdk
//
//  Created by 友和(lai.zhoul@alibaba-inc.com) on 14-8-2.
//  Copyright (c) 2014年 com.taobao. All rights reserved.
//

#import "TaeSession.h"
#import "TaeUser.h"
#import "TaeWebViewUISettings.h"
#import "TaeTradeProcessResult.h"
#import "TaeOrderItem.h"
#import "TaeTaokeParams.h"
#import "TaeTest.h"

@class TaeOrderItem;
@class TaeTradeProcessResult;
@class TaeSDK;
@class TaeSession;
@class TaeUser;
@class TaeWebViewUISettings;
@class TaeTaokeParams;

#pragma -mark SDK 回调定义
/**
 *  初始化结果回调
 */
typedef void (^initSuccessCallback)();
typedef void (^initFailedCallback)(NSError *error);


/**
 *  登录授权结果回调
 */
typedef void (^loginSuccessCallback)(TaeSession *session);
typedef void (^loginFailedCallback)(NSError *error);


/**
 *  会话登入和登出的监听Handler
 *
 *  @param session 返回状态更新后的会话
 */
typedef void (^sessionStateChangedHandler)(TaeSession *session);


/**
 * 交易流程结果回调
 */
typedef void (^tradeProcessSuccessCallback)(TaeTradeProcessResult *tradeProcessResult);
typedef void (^tradeProcessFailedCallback)(NSError *error);

@interface TaeSDK : NSObject

#pragma -mark SDK 基础API
/**
 *
 *  @return 返回单例
 */
+ (instancetype) sharedInstance ;

/**
 *  TaeSDK初始化，异步执行
 */
-(void)asyncInit;

/**
 *  TaeSDK初始化，异步执行
 *
 *  @param sucessCallback 初始化成功回调
 *  @param failedCallback 初始化失败回调
 */
-(void)asyncInit:(initSuccessCallback) sucessCallback
  failedCallback:(initFailedCallback) failedCallback;


/**
 *
 *  @param handler 会话登录状态改变时候的处理handler,可以通过TaeSession isLogin判断当前登录态
 */
-(void) setSessionStateChangedHandler:(sessionStateChangedHandler) handler;

/**
 *  退出登录
 */
-(void) logout;


/**
 *  用于处理其他App的回跳
 *
 *  @param url
 *
 *  @return 是否经过了TaeSDK的处理
 */
-(BOOL)handleOpenURL:(NSURL *) url;




#pragma -mark SDK Show API
/**
 *  请求登录授权，跳转到手机淘宝登录或者本地弹出登录界面
 *
 *  @param parentController app当前的Controller
 *  @param successCallback      登录授权成功的回调，返回TaeSession
 *  @param failedCallback       登录授权失败的回调，返回NSError
 */
-(void) showLogin:(UIViewController *) parentController
  successCallback:(loginSuccessCallback) successCallback
   failedCallback:(loginFailedCallback) failedCallback;

/**
 *  请求登录授权，跳转到手机淘宝登录或者本地弹出登录界面
 *
 *  @param parentController app当前的Controller
 *  @param successCallback      登录授权成功的回调，返回TaeSession
 *  @param failedCallback       登录授权失败的回调，返回NSError
 *  @param notUseTaobaoAppLogin       YES表示不要使用手机淘宝APP的登录授权，直接使用本地登录页面
 */
-(void) showLogin:(UIViewController *) parentController
  successCallback:(loginSuccessCallback) successCallback
   failedCallback:(loginFailedCallback) failedCallback
notUseTaobaoAppLogin:(BOOL)notUseTaobaoAppLogin;


-(void) showLogin:(UIViewController *) parentController
  successCallback:(loginSuccessCallback) successCallback
   failedCallback:(loginFailedCallback) failedCallback
notUseTaobaoAppLogin:(BOOL)notUseTaobaoAppLogin
isBackButtonHidden:(BOOL)isBackButtonHidden;

/**
 *  使用TaeSDK的webview打开H5页面，可以自动实现淘宝安全免登
 *
 *  @param parentController  app当前的Controller
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param pageUrl                  页面的url
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */
-(void) showPage:(UIViewController *) parentController
      isNeedPush:(BOOL) isNeedPush
         pageUrl:(NSString *)pageUrl
webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;


/**
 *  打开商品详情页面
 *
 *  @param parentController  app当前的Controller
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param itemId                      商品详情页请求真实ID
 *  @param itemType                      商品类型:1代表淘宝，2代表天猫
 *  @param params                        商品详情页请求附加参数
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */

- (void)showItemDetailByItemId:(UIViewController *)parentController
                    isNeedPush:(BOOL)isNeedPush
             webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                        itemId:(NSNumber *)itemId
                      itemType:(NSInteger)itemType
                        params:(NSDictionary *)params
   tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;
/**
 *  打开商品详情页面
 *
 *  @param parentController  app当前的Controller
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param itemId                      商品详情页请求混淆Id
 *  @param itemType                      商品类型:1代表淘宝，2代表天猫
 *  @param params                        商品详情页请求附加参数
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */

- (void)showItemDetailByOpenId:(UIViewController *)parentController
                    isNeedPush:(BOOL)isNeedPush
             webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                        itemId:(NSString *)itemId
                      itemType:(NSInteger)itemType
                        params:(NSDictionary *)params
   tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;
/**
 *  打开商品详情页面
 *
 *  @param parentController  app当前的Controller
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param itemId                      商品详情页请求参数
 *  @param itemType                      商品类型:1代表淘宝，2代表天猫
 *  @param params                        商品详情页请求附加参数
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */
-(void)showItemDetail:(UIViewController*)parentController
           isNeedPush:(BOOL) isNeedPush
    webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
               itemId:(NSString *)itemId
             itemType:(NSInteger) itemType
               params:(NSDictionary *)params
tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;

/**
 *  打开商品详情页面
 *
 *  @param parentController  app当前的Controller
 *  @param isRealId          商品的itmeId 是否是真实itemId
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param itemId                      商品详情页请求参数
 *  @param itemType                      商品类型:1代表淘宝，2代表天猫
 *  @param params                        商品详情页请求附加参数
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */

- (void)showItemDetailByItemId:(UIViewController *)parentController
                        isRealId:(BOOL)isRealId
                      isNeedPush:(BOOL)isNeedPush
               webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                          itemId:(NSNumber *)itemId
                        itemType:(NSInteger)itemType
                          params:(NSDictionary *)params
     tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;



/**
 *  打开订单页面
 *
 *  @param parentController  app当前的Controller
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param orderItems                      订单请求参数数组，参数类型见 TaeOrderItem
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */
-(void)showOrder:(UIViewController*)parentController
      isNeedPush:(BOOL) isNeedPush
webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
      orderItems:(NSArray *)orderItems
tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;




#pragma -mark 淘客 Show API
/**
 *  以淘客方式打开商品详情页面
 *
 *  @param parentController  app当前的Controller
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param itemId                      商品详情页请求参数
 *  @param itemType                      商品类型:1代表淘宝，2代表天猫
 *  @param params                        商品详情页请求附加参数
 *  @param taoKeParams                        淘客参数
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */
-(void)showTaoKeItemDetail:(UIViewController*)parentController
                isNeedPush:(BOOL) isNeedPush
         webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                    itemId:(NSString *)itemId
                  itemType:(NSInteger) itemType
                    params:(NSDictionary *)params
               taoKeParams:(TaeTaokeParams *) taoKeParams
tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;

/**
 *  以淘客方式打开商品详情页面
 *
 *  @param parentController  app当前的Controller
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param itemId                      商品详情页真实ID
 *  @param itemType                      商品类型:1代表淘宝，2代表天猫
 *  @param params                        商品详情页请求附加参数
 *  @param taoKeParams                        淘客参数
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */
- (void)showTaoKeItemDetailByItemId:(UIViewController *)parentController
                           isNeedPush:(BOOL)isNeedPush
                    webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                               itemId:(NSNumber *)itemId
                             itemType:(NSInteger)itemType
                               params:(NSDictionary *)params
                          taoKeParams:(TaeTaokeParams *)taoKeParams
          tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;
/**
 *  以淘客方式打开商品详情页面
 *
 *  @param parentController  app当前的Controller
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param itemId                      商品详情页混淆ID
 *  @param itemType                      商品类型:1代表淘宝，2代表天猫
 *  @param params                        商品详情页请求附加参数
 *  @param taoKeParams                        淘客参数
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */

- (void)showTaoKeItemDetailByOpenId:(UIViewController *)parentController
                         isNeedPush:(BOOL)isNeedPush
                  webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                             itemId:(NSString *)itemId
                           itemType:(NSInteger)itemType
                             params:(NSDictionary *)params
                        taoKeParams:(TaeTaokeParams *)taoKeParams
        tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;
/**
 *  以淘客方式打开订单页面
 *
 *  @param parentController  app当前的Controller
 *  @param isNeedPush            是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param orderItem                      订单请求参数，参数类型见 TaeOrderItem
 *  @param taoKeParams                        淘客参数
 *  @param tradeProcessSuccessCallback    交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */
-(void)showTaoKeOrder:(UIViewController*)parentController
           isNeedPush:(BOOL) isNeedPush
    webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
            orderItem:(TaeOrderItem *)orderItem
          taoKeParams:(TaeTaokeParams *) taoKeParams
tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;

#pragma -mark  Show url
/**
 *  打开优惠卷页面
 *  其中param和type都为必填选项，
 *  type：shop时，param传递为sellerNick；
 *  type：auction时，param传递为商品的混淆id；
 *
 *  @param parentController            <#parentController description#>
 *  @param isNeedPush                  <#isNeedPush description#>
 *  @param webViewUISettings           <#webViewUISettings description#>
 *  @param param                       <#param description#>
 *  @param type                        <#type description#>
 *  @param tradeProcessSuccessCallback <#tradeProcessSuccessCallback description#>
 *  @param tradeProcessFailedCallback  <#tradeProcessFailedCallback description#>
 */
-(void)showPromotions:(UIViewController*)parentController
           isNeedPush:(BOOL) isNeedPush
    webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                param:(NSString *)param
                 type:(NSString *)type
tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;


/**
 *  打开电子凭证页面
 *
 *  @param parentController            <#parentController description#>
 *  @param isNeedPush                  <#isNeedPush description#>
 *  @param webViewUISettings           <#webViewUISettings description#>
 *  @param orderId                     订单Id
 *  @param tradeProcessSuccessCallback <#tradeProcessSuccessCallback description#>
 *  @param tradeProcessFailedCallback  <#tradeProcessFailedCallback description#>
 */
-(void)showETicketDetail :(UIViewController*)parentController
               isNeedPush:(BOOL) isNeedPush
        webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                  orderId:(NSString *)orderId
tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;

#pragma -mark SDK 环境定义

typedef enum{
    TaeSDKEnvironmentDaily,  //测试环境
    TaeSDKEnvironmentPreRelease,//预发环境
    TaeSDKEnvironmentRelease,//线上环境
    TaeSDKEnvironmentSandBox//沙箱环境
    
} TaeSDKEnvironment;


TaeSDKEnvironment TaeSDKCurrentEnvironment();//当前环境
/**
 *  设置SDK 环境信息，Tae内部测试使用
 *
 *  @param environmentType 见TaeSDKEnvironment
 */
-(void)setTaeSDKEnvironment:(TaeSDKEnvironment) environmentType;


#pragma -mark SDK 回调Code定义

typedef enum{
    TAE_INIT_FAILED=1000,//SDK初始化失败
    TAE_INIT_SERVER_CER_LOAD_FAILED=1002,//初始化下载服务端证书失败
    TAE_INIT_SERVER_CER_EVAL_FAIELD=1003,//服务端证书验证失败
    TAE_INIT_LOCAL_CER_EVAL_FAIELD=1004,//本地证书验证失败
    TAE_INIT_REFRESH_SESSION_FAIELD=1005,//刷新当前会话失败
    TAE_LOGIN_FAILED=2001,//登录失败
    TAE_LOGIN_CANCELLED=2002,//用户取消了登录
    TAE_TRADE_PROCESS_FAILED=3001 ,//交易链路失败
    TAE_TRADE_PROCESS_CANCELLED=3002, //交易链路中用户取消了操作
    TAE_TRADE_PROCESS_PAY_FAILED =3003,//交易链路中发生支付但是支付失败
    TAE_TRADE_PROCESS_ITEMID_INVALID=3004//itemId无效
    
} TaeSDKCode;


#pragma -mark SDK 业务开关

/**
 *  打开debug日志
 *
 *  @param isDebugLogOpen
 */
-(void) setDebugLogOpen:(BOOL) isDebugLogOpen;

/**
 *  是否开启阿里云推送功能,默认不开启
 *
 *  @param isCloudPushSDKOpen
 */
-(void) setCloudPushSDKOpen:(BOOL) isCloudPushSDKOpen;

/**
 *  关闭TAE的user-agent
 */
-(void) closeTaeUserAgent;


/**
 *  关闭TAE设置的crashHandler
 */
-(void) closeCrashHandler;

/**
 *  如果引入了高德地图SDK，TAE会返回对应的高德key
 *
 *  @return <#return value description#>
 */
-(NSString *) getGaoDeAPIKey;

#pragma -mark 购物车API

/**
 *  加入商品到购物车的结果回调
 */
typedef void (^addCartSuccessCallback)();
typedef void (^addCartCacelledCallback)();


/**
 *  添加商品到购物车
 *
 *  @param parentController        app当前的Controller
 *  @param isNeedPush              是否需要使用parentController进行push
 *  @param webViewUISettings        可以自定义的webview配置项
 *  @param itemId                   商品混淆id
 *  @param addCartSuccessCallback   用户点击确定，添加到购物车成功的回调
 *  @param addCartCacelledCallback  用户点击返回，取消了添加的回调
 */
-(void) addItem2Cart:(UIViewController *) parentController
          isNeedPush:(BOOL) isNeedPush
   webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
              itemId:(NSString *)itemId
addCartSuccessCallback:(addCartSuccessCallback)addCartSuccessCallback
addCartCacelledCallback:(addCartCacelledCallback)addCartCacelledCallback;



/**
 *  添加淘客商品到购物车
 *
 *  @param parentController        app当前的Controller
 *  @param isNeedPush              是否需要使用parentController进行push
 *  @param webViewUISettings       可以自定义的webview配置项
 *  @param itemId                  商品混淆id
 *  @param taoKeParams             淘客参数
 *  @param addCartSuccessCallback   用户点击确定，添加到购物车成功的回调
 *  @param addCartCacelledCallback  用户点击返回，取消了添加的回调
 */
-(void) addTaoKeItem2Cart:(UIViewController *) parentController
               isNeedPush:(BOOL) isNeedPush
        webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                   itemId:(NSString *)itemId
              taoKeParams:(TaeTaokeParams *) taoKeParams
   addCartSuccessCallback:(addCartSuccessCallback)addCartSuccessCallback
  addCartCacelledCallback:(addCartCacelledCallback)addCartCacelledCallback;



/**
 *  带sku选择页的商品下单接口
 *
 *  @param parentController            app当前的Controller
 *  @param isNeedPush                  是否需要使用parentController进行push
 *  @param webViewUISettings           可以自定义的webview配置项
 *  @param itemId                      商品混淆id
 *  @param params                      扩展参数
 *  @param tradeProcessSuccessCallback 交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */
-(void)showOrderWithSku:(UIViewController*)parentController
                    isNeedPush:(BOOL) isNeedPush
                webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                    itemId:(NSString *)itemId
                     params:(NSDictionary *)params
        tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
        tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;

/**
 *  带sku选择页的淘客商品下单接口
 *
 *  @param parentController            app当前的Controller
 *  @param isNeedPush                  是否需要使用parentController进行push
 *  @param webViewUISettings           可以自定义的webview配置项
 *  @param itemId                      商品混淆id
 *  @param params                      扩展参数
 *  @param taoKeParams                  淘客参数
 *  @param tradeProcessSuccessCallback 交易流程成功完成订单支付的回调
 *  @param tradeProcessFailedCallback  交易流程未完成的回调
 */
-(void)showTaoKeOrderWithSku:(UIViewController*)parentController
                    isNeedPush:(BOOL) isNeedPush
                webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
                        itemId:(NSString *)itemId
                      params:(NSDictionary *)params
                    taoKeParams:(TaeTaokeParams *) taoKeParams
        tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
        tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;



/**
 *  打开购物车页面
 *
 *  @param parentController            <#parentController description#>
 *  @param isNeedPush                  <#isNeedPush description#>
 *  @param webViewUISettings           <#webViewUISettings description#>
 *  @param tradeProcessSuccessCallback <#tradeProcessSuccessCallback description#>
 *  @param tradeProcessFailedCallback  <#tradeProcessFailedCallback description#>
 */
-(void) showCart:(UIViewController*)parentController
            isNeedPush:(BOOL) isNeedPush
            webViewUISettings:(TaeWebViewUISettings *)webViewUISettings
        tradeProcessSuccessCallback:(tradeProcessSuccessCallback)tradeProcessSuccessCallback
        tradeProcessFailedCallback:(tradeProcessFailedCallback)tradeProcessFailedCallback;


#pragma -mark 插件相关API

/**
 *  获取TAESDK以及所有插件SDK暴露的service 实例
 *
 *  @param protocol service的协议
 *
 *  @return service实例
 */
-(id) getService:(Protocol *) protocol;


/**
 *  指定当前APP的版本，以便关联相关日志和crash分析信息,//如果不设置默认会取plist里的Bundle version
 *
 *  @param version
 */
-(void) setAppVersion:(NSString *)version;
@end
