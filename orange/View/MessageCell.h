//
//  MessageCell.h
//  orange
//
//  Created by huiter on 15/1/18.
//  Copyright (c) 2015年 sensoro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, MessageType) {
    /**
     *  默认类型
     */
    MessageTypeDefault = 0,
    /**
     *  评论被回复
     */
    MessageCommentReply,
    /**
     *  点评被评论
     */
    MessageNoteComment,
    /**
     *  被关注
     */
    MessageUserFollow,
    /**
     *  点评被赞
     */
    MessageNotePoke,
    /**
     *  商品被点评
     */
    MessageEntityNote,
    /**
     *  商品被喜爱
     */
    MessageEntityLike,
    /**
     *  点评入精选
     */
    MessageNoteSelection,
    /**
     *  图文被赞
     */
    MessageArticlePoke,
};


@interface MessageCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *message;

@property (copy, nonatomic)     void (^tapLinkBlock)(NSURL *url);
@property (copy, nonatomic)     void (^tapImageBlock)(MessageType type);

+ (CGFloat)height:(NSDictionary *)message;
@end
