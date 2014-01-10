//
//  CEPlayer.h
//  RoundProgress
//
//  Created by Renaud Pradenc on 04/06/12.
//  Copyright (c) 2012 Céroce. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CEPlayer;

@protocol CEPlayerDelegate <NSObject>

- (void) player:(CEPlayer *)player didReachPosition:(float)position;
- (void) playerDidStop:(CEPlayer *)player;

@end

@interface CEPlayer : NSObject

- (void) play;
- (void) pause;
- (void) stop;
-(void)forward:(float)point;
-(void)rewind:(float)point;

@property (assign) float position;
@property (assign) float durationsong;// 0..1
@property (retain) id <CEPlayerDelegate> delegate;

@end
