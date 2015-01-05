//
//  MCPHandler.m
//  MCP
//
//  Created by Bakers on 31/03/2014.
//  Copyright (c) 2014 Bakers. All rights reserved.
//

#import "MCPHandler.h"

@implementation MCPHandler : NSObject

- (void)setupPeerWithDisplayName:(NSString *)displayName {
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
}

- (void)setupSession {
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

- (void)setupBrowser {
    if (!self.browser) {
        self.browser = [[MCNearbyServiceBrowser alloc]initWithPeer:self.peerID serviceType:@"emojiii"];
    }
}

- (void)advertiseSelf:(BOOL)advertise WithInfo:(NSDictionary *)dic{
    if (advertise) {
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"emojiii" discoveryInfo:dic session:self.session];
        [self.advertiser start];
        
    } else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}


- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSDictionary *userInfo = @{ @"peerID": peerID,
                                @"state" : @(state) };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCDidChangeStateNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
}


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSDictionary *userInfo = @{ @"data": data,
                                @"peerID": peerID };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCDidReceiveDataNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
}

@end
