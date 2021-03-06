//
//  API.h
//  orange
//
//  Created by 谢家欣 on 15/4/4.
//  Copyright (c) 2015年 guoku.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKModel.h"

//@class GKEntity;
//@class GKComment;
//@class GKNote;

@interface API : NSObject

typedef NS_ENUM(NSInteger, GKSNSType){
    /// 新浪微博
    GKSinaWeibo = 1,
    /// 淘宝
    GKTaobao,
} ;

typedef NS_ENUM(NSInteger, GKPaymentType) {
    WechatPaymentType   = 1,
    AlipayPaymentType,
};

/*
 *  更新 JPush Register ID
 */
+ (void)postRegisterID:(NSString *)rid Model:(NSString *)model Version:(NSString *)ver Success:(void (^)())success
               Failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取启动画面
 *
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getLaunchImageWithSuccess:(void (^)(GKLaunch * launch))success
                          failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取全部分类信息
 *
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getAllCategoryWithSuccess:(void (^)(NSArray *groupArray))success
                          failure:(void (^)(NSInteger stateCode))failure;


/**
 *  获取分类统计数据
 *
 *  @param categoryId 商品分类ID
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getCategoryStatByCategoryId:(NSUInteger)categoryId
                            success:(void (^)(NSInteger likeCount, NSInteger noteCount, NSInteger entityCount))success
                            failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取大分类列表
 *
 *  success block
 *  failure block
 */
+ (void)getGroupCategoryWithSuccess:(void (^)(NSArray * categories))success
                            failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取分类商品列表
 *
 *  @param gid 一级分类 id
 */
+ (void)getGroupEntityWithGroupId:(NSInteger)gid Page:(NSInteger)pag
                            Sort:(NSString *)sort
                            success:(void (^)(NSArray * entities))success
                          failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取分类文章列表
 *
 *  @param gid 一级分类
 */
+ (void)getGroupArticleWithGroupId:(NSInteger)gid Page:(NSInteger)page
                           success:(void (^)(NSArray * articles, NSInteger count))success
                           failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取子分类文章列表
 *
 *  @param sid 二级分类
 */
+ (void)getSubCategoryArticlesWithCategroyId:(NSInteger)sid Page:(NSInteger)page
                                     success:(void (^)(NSArray * articles, NSInteger count))success
                                     failure:(void (^)(NSInteger stateCode))failure;


#pragma mark - Entity API
/**
 *  获取商品详细
 *
 *  @param entityId 商品ID
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)getEntityDetailWithEntityId:(NSString *)entityId
                            success:(void (^)(GKEntity *entity, NSArray *likeUserArray, NSArray *noteArray, NSArray *recommendation))success
                            failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取随机商品
 *
 *  @param categoryId 分类ID
 *  @param count      请求的个数
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getRandomEntityListByCategoryId:(NSUInteger)categoryId
                               entityId:(NSString *)entityId
                                  count:(NSInteger)count
                                success:(void (^)(NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode, NSError *error))failure;

/**
 *  获取商品喜爱用户
 *
 *  @param entity_id  商品ID
 *  @param page       页码page
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getEntityLikerWithEntityId:(NSString *)entity_id
                              Page:(NSInteger)page
                           success:(void (^)(NSArray *dataArray, NSInteger page))success
                           failure:(void (^)(NSInteger stateCode))failure;

/**
 *  对点评点赞
 *
 *  @param noteId  点评ID
 *  @param state   想要设置的赞状态
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)pokeWithNoteId:(NSUInteger)noteId
                 state:(BOOL)state
               success:(void (^)(NSString *entityId, NSUInteger noteId, BOOL state))success
               failure:(void (^)(NSInteger stateCode))failure;

#pragma mark - order 
/**
 *  获取商品 sku
 *
 *  @param entity_hash 商品 hash 码
 *
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getEntitySKUWithHash:(NSString *)entity_hash
                     Success:(void (^)(GKEntity * entity))success
                     Failure:(void (^)(NSInteger stateCode, NSError * error))failure;

/**
 *  商品加入购物车
 *
 *  sid     sku id
 *  volume  商品数量
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)addEntitySKUToCartWithSKUId:(NSInteger)sku_id Volume:(NSInteger)volume
                            Success:(void (^)(BOOL is_success))success
                            Failure:(void (^)(NSInteger stateCode, NSError * error))failure;


/**
 *  获取购物车内商品列表
 *
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getCartItemListWithSuccess:(void (^)(NSArray * shoppingCartArray))success
                           Failure:(void (^)(NSInteger stateCode, NSError * error))failure;

/**
 *  incr shopping cart item
 *
 *  @param sku_id   sku_id
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)incrShoppingCartItemWithSKUId:(NSInteger)sku_id Success:(void (^)(NSInteger volume))success
                              Failure:(void (^)(NSInteger stateCode, NSError * error))failure;

/**
 *  desc shopping cart item
 *
 *  @param sku_id   sku_id
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)descShoppingCartItemWithSKUId:(NSInteger)sku_id Success:(void (^)(NSInteger volume))success
                              Failure:(void (^)(NSInteger stateCode, NSError * error))failure;


/**
 *  clear Shopping Cart
 *
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)clearCartWithSuccess:(void (^)(BOOL isClear))success
                     Failure:(void (^)(NSInteger stateCode, NSError * error))failure;

/**
 *  生成订单
 *
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)checkoutShoppingCartWithSuccess:(void (^)(GKOrder *order))success
                                Failure:(void (^)(NSInteger stateCode, NSError * error))failure;

/**
 *  获取订单列表
 *
 *  @param status  订单状态
 *  @param page     页码
 *  @param size    每页数量
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getOrderListWithWithStatus:(NSInteger)status Page:(NSInteger)page Size:(NSInteger)size
                           Success:(void (^)(NSArray *OrderArray))success
                           Failure:(void (^)(NSInteger stateCode, NSError * error))failure;


/**
 *  获取微信支付链接
 *
 *  @param order_id     订单 ID
 *  @param type         支付方式
 *  @param success      成功block
 *  @param failure      成功block
 */
+ (void)getPaymentURLWithOrderId:(NSInteger)order_id PaymentType:(GKPaymentType)type
                        Success:(void (^)(NSString  *payment_url))success
                        Failure:(void (^)(NSInteger stateCode, NSError * error))failure;

#pragma mark - get Article data
/**
 *  获取标签下 图文列表
 *  @param  name    标签名称
 *  @param  page    页数
 *  @param  size    每页数量
 *  @param  success   成功block
 *  @param  failure   失败block
 */
+ (void)getArticlesWithTagName:(NSString *)name
                          Page:(NSInteger)page
                          Size:(NSInteger)size
                       success:(void (^)(NSArray *dataArray))success
                       failure:(void (^)(NSInteger stateCode))failure;

/**
 *  图文点赞
 *  @param  article_id  图文 ID
 *  @param  isdig       图文状态
 *  @param  success     成功block
 *  @param  failure     失败block
 */
+ (void)digArticleWithArticleId:(NSInteger)article_id isDig:(BOOL)isdig
                        success:(void (^)(BOOL IsDig))success
                        failure:(void (^)(NSInteger stateCode))failure;

/**
 *  图文评论
 *  @param  article_id
 *  @parma  content
 *  @param  success     成功block
 *  @param  failure     失败block
 */
+ (void)postCommentForArticleWithArticleId:(NSInteger)article_id Content:(NSString *)content
                                   success:(void (^)(GKArticleComment* comment))success
                                   failure:(void (^)(NSInteger stateCode))failure;

#pragma mark - get main list
/**
 * 获取首页信息
 *
 */
+ (void)getHomeWithSuccess:(void (^)(NSArray * banners, NSArray * articles, NSArray * category, NSArray * entities))success
                   failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取精选列表
 *
 *  @param timestamp 时间戳
 *  @param cateId    旧版categoryId(0 ~ 11)
 *  @param count     请求的个数

 */
+ (void)getSelectionListWithTimestamp:(NSTimeInterval)timestamp
                               cateId:(NSUInteger)cateId
                                count:(NSInteger)count
                              success:(void (^)(NSArray *dataArray))success
                              failure:(void (^)(NSInteger stateCode, NSError * error))failure;

/**
 *  获取图文列表
 *  @param timestamp    时间戳
 *  @param page         翻页
 *  @param size         每页数量
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)getArticlesWithTimestamp:(NSTimeInterval)timestamp
                            Page:(NSInteger)page
                            Size:(NSInteger)size
                         success:(void (^)(NSArray *articles))success
                         failure:(void (^)(NSInteger stateCode, NSError * error))failure;

/**
 *  获取发现数据
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getDiscoverWithsuccess:(void (^)(NSArray *banners, NSArray *entities, NSArray *categories,
                                         NSArray *stores, NSArray *articles, NSArray *users))success
                       failure:(void (^)(NSInteger stateCode, NSError * error))failure;


/**
 *  获取认证用户列表
 *
 *  @param page     页数
 *  @param size     每页长度
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getAuthorizedUserWithPage:(NSInteger)page Size:(NSInteger)size success:(void (^)(NSArray * users, NSInteger page))success failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取热门商品列表
 *
 *  @param type    类型(24小时/7天)
 *  @param success 成功block
 *  @param failure 失败block
 */
+(void)getHotEntityListWithType:(NSString *)type
                        success:(void (^)(NSArray *entityArray))success
                        failure:(void (^)(NSInteger stateCode))failure;



/**
 *  获取商品列表
 *
 *  @param categoryId 商品分类ID
 *  @param sort       排序规则(评价:"best" 时间:"new")
 *  @param reverse    是否倒序
 *  @param offset     偏移量
 *  @param count      请求的个数
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getEntityListWithCategoryId:(NSUInteger)categoryId
                               sort:(NSString *)sort
                            reverse:(BOOL)reverse
                             offset:(NSInteger)offset
                              count:(NSInteger)count
                            success:(void (^)(NSArray *entityArray))success
                            failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取用户的喜爱商品列表
 *
 *  @param userId    用户ID
 *  @param categoryId   分类ID
 *  @param timestamp 时间戳
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getUserLikeEntityListWithUserId:(NSUInteger)userId
                            categoryId:(NSInteger)categoryId
                              timestamp:(NSTimeInterval)timestamp
                                  count:(NSInteger)count
                                success:(void (^)(NSTimeInterval timestamp, NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取用户的点评列表
 *
 *  @param userId    用户ID
 *  @param timestamp 时间戳
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getUserNoteListWithUserId:(NSUInteger)userId
                        timestamp:(NSTimeInterval)timestamp
                            count:(NSInteger)count
                          success:(void (^)(NSArray *dataArray, NSTimeInterval timestamp))success
                          failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取喜爱商品列表
 *
 *  @param categoryId 商品分类ID
 *  @param sort       排序规则(评价:"best" 时间:"new")
 *  @param reverse    正序、逆序
 *  @param offset     偏移量
 *  @param count      请求的个数
 *  @param success    成功block
 *  @param failure    失败block
 */

+ (void)getLikeEntityListWithCategoryId:(NSUInteger)categoryId
                                 userId:(NSUInteger)userId
                                   sort:(NSString *)sort
                                reverse:(BOOL)reverse
                                 offset:(NSInteger)offset
                                  count:(NSInteger)count
                                success:(void (^)(NSArray *entityArray))success
                                failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取用户的标签列表
 *
 *  @param userId  用户ID
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getTagListWithUserId:(NSUInteger)userId
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(GKUser *user, NSArray *tagArray))success
                     failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取用户某个标签下的商品列表
 *
 *  @param userId  用户ID
 *  @param tag     标签
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getEntityListWithUserId:(NSUInteger)userId
                            tag:(NSString *)tag
                         offset:(NSInteger)offset
                          count:(NSInteger)count
                        success:(void (^)(GKUser *user ,NSArray *entityArray))success
                        failure:(void (^)(NSInteger stateCode))failure;


/**
 *  喜欢商品
 *
 *  @param entityId   商品 Id
 *  @param isLike     想要设置的喜爱状态
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)likeEntityWithEntityId:(NSString *)entityId
                        isLike:(BOOL)isLike
                       success:(void (^)(BOOL liked))success
                       failure:(void (^)(NSInteger stateCode))failure;


/**
 *  获取用户赞过的图文
 *
 *  @param  page        页码
 *  @param  success     成功block
 *  @param  failure     失败block
 */
+ (void)getUserDigArticleWithUserId:(NSInteger)userId Page:(NSInteger)page
                            success:(void (^)(NSArray *articles, NSInteger size, NSInteger total))success
                            failure:(void (^)(NSInteger stateCode))failure;


#pragma mark - entity note 

/**
 *  发点评
 *
 *  @param entityId  商品ID
 *  @param content   点评内容
 *  @param score     点评分数
 *  @param imageData 用户晒图
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)postNoteWithEntityId:(NSString *)entityId
                     content:(NSString *)content
                       score:(NSInteger)score
                   imageData:(NSData *)imageData
                     success:(void (^)(GKNote *note))success
                     failure:(void (^)(NSInteger stateCode))failure;

/**
 *  修改点评
 *
 *  @param noteId    点评ID
 *  @param content   点评内容
 *  @param score     点评分数
 *  @param imageData 用户晒图
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)updateNoteWithNoteId:(NSUInteger)noteId
                     content:(NSString *)content
                       score:(NSInteger)score
                   imageData:(NSData *)imageData
                     success:(void (^)(GKNote *note))success
                     failure:(void (^)(NSInteger stateCode))failure;

/**
 *  删除点评
 *
 *  @param noteId  点评ID
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)deleteNoteByNoteId:(NSUInteger)noteId
                   success:(void (^)())success
                   failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取点评详细
 *
 *  @param noteId  点评ID
 *  @param success 成功block
 *  @param failure 失败block
 */

+ (void)getNoteDetailWithNoteId:(NSUInteger)noteId
                        success:(void (^)(GKNote *note, GKEntity *entity, NSArray *commentArray, NSArray *pokerArray))success
                        failure:(void (^)(NSInteger stateCode))failure;

/**
 *  发评论
 *
 *  @param noteId   点评ID
 *  @param content  评论内容
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)postCommentWithNoteId:(NSUInteger)noteId
                      content:(NSString *)content
                      success:(void (^)(GKComment *comment))success
                      failure:(void (^)(NSInteger stateCode))failure;

/**
 *  回复评论
 *
 *  @param noteId    点评ID
 *  @param commentId 回复的评论ID
 *  @param commentCreatorId 回复的评论的创建者ID
 *  @param content   评论内容
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)replyCommentWithNoteId:(NSUInteger)noteId
                     commentId:(NSUInteger)commentId
              commentCreatorId:(NSUInteger)commentCreatorId
                       content:(NSString *)content
                       success:(void (^)(GKComment *comment))success
                       failure:(void (^)(NSInteger stateCode))failure
;

/**
 *  删除评论
 *
 *  @param noteId    点评ID
 *  @param commentId 评论ID
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)deleteCommentByNoteId:(NSUInteger)noteId
                    commentId:(NSUInteger)commentId
                      success:(void (^)())success
                      failure:(void (^)(NSInteger stateCode))failure;

#pragma mark - send tip off
/**
 *  举报商品
 *
 *  @param entityId 商品ID
 *  @param comment  举报原因
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)reportEntityId:(NSString *)entityId
                  type:(NSInteger)type
               comment:(NSString *)comment
               success:(void (^)(BOOL success))success
               failure:(void (^)(NSInteger stateCode))failure;

/**
 *  举报点评
 *
 *  @param noteId  点评ID
 *  @param comment 举报原因
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)reportNoteId:(NSUInteger)noteId
             comment:(NSString *)comment
             success:(void (^)(BOOL success))success
             failure:(void (^)(NSInteger stateCode))failure;

#pragma mark - get notification
/**
 *  获取动态
 *
 *  @param timestamp 时间戳
 *  @param type      返回的实体类型(entity/candidate)
 *  @param scale     好友动态/社区动态(friend/all)
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getFeedWithTimestamp:(NSTimeInterval)timestamp
                        type:(NSString *)type
                       scale:(NSString *)scale
                     success:(void (^)(NSArray *dataArray))success
                     failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取消息列表
 *
 *  @param timestamp 时间戳
 *  @param count     请求的个数
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)getMessageListWithTimestamp:(NSTimeInterval)timestamp
                              count:(NSInteger)count
                            success:(void (^)(NSArray *messageArray))success
                            failure:(void (^)(NSInteger stateCode))failure;

#pragma mark - user relation
/**
 *  关注用户
 *
 *  @param userId  目标用户
 *  @param state   要设置的关注状态
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)followUserId:(NSUInteger)userId
               state:(BOOL)state
             success:(void (^)(GKUserRelationType relation))success
             failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取用户的关注列表
 *
 *  @param userId  用户ID
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getUserFollowingListWithUserId:(NSUInteger)userId
                                offset:(NSInteger)offset
                                 count:(NSInteger)count
                               success:(void (^)(NSArray *userArray))success
                               failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取用户的粉丝列表
 *
 *  @param userId  用户ID
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getUserFanListWithUserId:(NSUInteger)userId
                          offset:(NSInteger)offset
                           count:(NSInteger)count
                         success:(void (^)(NSArray *userArray))success
                         failure:(void (^)(NSInteger stateCode))failure;

#pragma mark - account 
/**
 *  用户注册
 *
 *  @param email        邮箱
 *  @param password     密码
 *  @param nickname     昵称
 *  @param imageData    头像
 *  @param sinaUserId   新浪微博ID
 *  @param sinaToken    新浪微博Token
 *  @param taobaoUserId 淘宝ID
 *  @param taobaoToken  taobaoToken
 *  @param screenName   新浪/淘宝 昵称
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)registerWithEmail:(NSString *)email
                 password:(NSString *)password
                 nickname:(NSString *)nickname
                imageData:(NSData *)imageData
               sinaUserId:(NSString *)sinaUserId
                sinaToken:(NSString *)sinaToken
             taobaoUserId:(NSString *)taobaoUserId
              taobaoToken:(NSString *)taobaoToken
               screenName:(NSString *)screenName
                  success:(void (^)(GKUser *user, NSString *session))success
                  failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure;

/**
 *  用户登录
 *
 *  @param email    邮箱
 *  @param password 密码
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
               success:(void (^)(GKUser *user, NSString *session))success
               failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure;

/**
 *  新浪微博登录
 *
 *  @param sinaUserId 新浪微博用户ID
 *  @param sinaToken  新浪token
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)loginWithSinaUserId:(NSString *)sinaUserId
                  sinaToken:(NSString *)sinaToken
                 ScreenName:(NSString *)screenname
                    success:(void (^)(GKUser *user, NSString *session))success
                    failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure;

/**
 *  百川登录
 *
 *  @param uid          淘宝用户ID
 *  @param nick         淘宝用户昵称
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)loginWithBaichuanUid:(NSString *)uid
                        nick:(NSString *)nick
                     success:(void (^)(GKUser *user, NSString *session))success
                     failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure;

/**
 *  微信登录
 *
 *  @param unionid      微信用户 UNIONID
 *  @param nickname     微信用户昵称
 *  @param headimgurl   微信用户头像
 *  @param success      成功block
 *  @param failure      失败block
 */
+ (void)loginWithWeChatWithUnionid:(NSString *)unionid Nickname:(NSString *)nickname HeaderImgURL:(NSString *)headimgurl
                           success:(void (^)(GKUser *user, NSString *session))success
                           failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure;

/**
 *  新浪用户绑定果库账号
 *  @param user_id          果库用户ID
 *  @param sina_user_id     新浪用户ID
 *  @param screen_name      新浪用户名
 *  @param access_token     新浪token
 *  @param expires_in       token过期时间
 *  @param success          成功block
 *  @param failure          失败block
 */
+ (void)bindWeiboWithUserId:(NSInteger)user_id sinaUserId:(NSString *)sina_user_id
             sinaScreenname:(NSString *)screen_name
                accessToken:(NSString *)access_token
                  ExpiresIn:(NSDate *)expires_in
                    success:(void (^)(GKUser *user))success
                    failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure;

/**
 *  果库账号解除SNS綁定
 *  @param user_id          果库用户ID
 *  @param sns_user_name    SNS用户名
 *  @param platform         SNS平台
 *  @param success          成功block
 *  @param failure          失败block
 */
+ (void)unbindSNSWithUserId:(NSInteger)user_id
                SNSUserName:(NSString *)sns_user_name
                setPlatform:(GKSNSType)platform
                    success:(void (^)(bool status))success
                    failure:(void (^)(NSInteger stateCode, NSString *type, NSString *message))failure;

#pragma mark - user profile
/**
 *  获取个人主页详细信息
 *
 *  @param userId  用户ID
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getUserDetailWithUserId:(NSUInteger)userId
                        success:(void (^)(GKUser *user, NSArray *lastLikeEntities, NSArray  *lastNotes, NSArray * lastArticles))success
                        failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取用户图文
 *
 *  @param  userId      用户 ID
 *  @param  page        页码
 *  @param  size        每页长度
 *  @param  success     成功block
 *  @param  failure     失败block
 */
+ (void)getUserArticlesWithUserId:(NSInteger)userId Page:(NSInteger)page Size:(NSInteger)size
                          success:(void (^)(NSArray * articles, NSInteger page, NSInteger count))success
                          failure:(void (^)(NSInteger stateCode))failure;

/**
 *  更新当前用户信息
 *

 *  @param parameters    性别
 *  @param imageData    头像
 *  @param success      成功block
 *  @param failure      失败block
 */

+ (void)updateUserProfileWithParameters:(NSDictionary *)parameters
                              imageData:(NSData *)imageData
                                success:(void (^)(GKUser *user))success
                                failure:(void (^)(NSInteger stateCode))failure;

/**
 *  更新当前用户邮箱
 *
 *  @param parameters  密码
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)updateEmailWithParameters:(NSDictionary *)parameters
                          success:(void (^)(GKUser *user))success
                          failure:(void (^)(NSInteger stateCode, NSString *errorMsg))failure;

/**
 *  更新当前用户邮箱
 *
 *  @param parameters     邮箱
 *  @param success   成功block
 *  @param failure   失败block
 */
+ (void)verifiedEmailWithParameters:(NSDictionary *)parameters
                            success:(void (^)(NSInteger stateCOde))success
                            failure:(void (^)(NSInteger stateCode, NSString *errorMsg))failure;

/**
 *  更新当前用户密码
 *
 *  @param parameters         密码
 *  @param success          成功block
 *  @param failure          失败block
 */
+ (void)resetPasswordWithParameters:(NSDictionary *)parameters
                            success:(void (^)(GKUser *user))success
                            failure:(void (^)(NSInteger stateCode, NSString *errorMsg))failure;

/**
 *  忘记密码
 *
 *  @param email   注册时的Email
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)forgetPasswordWithEmail:(NSString *)email
                        success:(void (^)(BOOL success))success
                        failure:(void (^)(NSInteger stateCode))failure;

/**
 *  用户注销
 *
 *  @param success  成功block
 *  @param failure  失败block
 */
+ (void)logoutWithSuccess:(void (^)())success
                  failure:(void (^)(NSInteger stateCode))failure;

#pragma mark - Search API
/**
 *  搜索页面 API
 *
 *  @param keyword 搜索关键词
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)searchWithKeyword:(NSString *)keyword
                  Success:(void (^)(NSArray *entities, NSArray * articles, NSArray * users))success
                  failure:(void (^)(NSInteger stateCode, NSError * error))failure;

/**
 *  热门搜索关键词
 *
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getSearchKeywordsWithSuccess:(void (^)(NSArray *keywords))success
                             Failure:(void (^)(NSInteger stateCode, NSError * error))failure;

/**
 *  搜索商品
 *
 *  @param string  搜索关键字
 *  @param type    类型(全部/喜爱)
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)searchEntityWithString:(NSString *)string
                          type:(NSString *)type
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                       success:(void (^)(NSDictionary *stat,NSArray *entityArray))success
                       failure:(void (^)(NSInteger stateCode))failure;

/**
 *  搜索图文
 *
 *  @param  string      搜索关键词
 *  @param  page        翻页
 *  @param  size        长度
 *  @param  success      成功block
 *  @param  failure     失败block
 */
+ (void)searchArticlesWithString:(NSString *)string
                            Page:(NSInteger)page
                            Size:(NSInteger)size
                         success:(void (^)(NSArray * articles))success
                         failure:(void (^)(NSInteger stateCode))failure;
/**
 *  搜索用户
 *
 *  @param string  搜索关键字
 *  @param offset  偏移量
 *  @param count   请求的个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)searchUserWithString:(NSString *)string
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(NSArray *userArray))success
                     failure:(void (^)(NSInteger stateCode))failure;

/**
 *  获取未读内容数值
 *
 *  @param success    成功block
 *  @param failure    失败block
 */
+ (void)getUnreadCountWithSuccess:(void (^)(NSDictionary *dictionary))success
                          failure:(void (^)(NSInteger stateCode))failure;


#pragma mark - get wechat open_uid
/**
 *  获取微信用户 OPEN ID
 *  @param appkey app key
 *  @param secret app secret
 *  @param code     wechat_auth_code
 */
+ (NSDictionary *)getWeChatAuthWithAppKey:(NSString *)appkey Secret:(NSString *)secret Code:(NSString *)code;

/**
 *  获取微信用户信息
 *
 *  @param access_token wechat access token
 *  @param open_id      wechat open id
 */
+ (NSDictionary *)getWeChatUserInfoWithAccessToken:(NSString *)access_token OpenID:(NSString *)open_id;


#pragma mark - today
/**
 *  获取 24小时 Top 10 商品列表
 *
 *  @param count   获取商品个数
 *  @param success 成功block
 *  @param failure 失败block
 */
+ (void)getTopTenEntityCount:(NSInteger)count
                     success:(void (^)(NSArray *array))success
                     failure:(void (^)(NSInteger stateCode, NSError *error))failure;


#pragma mark - Advertise
+ (void)getAdvertiseWithSuccess:(void (^)(NSArray *array))success
                        failure:(void (^)(NSInteger stateCode, NSError *error))failure;


/**
 *  取消所有网络请求
 */
+ (void)cancelAllHTTPOperations;
@end
