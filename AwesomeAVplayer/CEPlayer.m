//
//  CEPlayer.m
//  RoundProgress
//
//  Created by Renaud Pradenc on 04/06/12.
//  Copyright (c) 2012 Céroce. All rights reserved.
//

#import "CEPlayer.h"

#define DURATION  20.0
#define PERIOD    1.0

@interface CEPlayer ()
{
    NSTimer *timer;
}


@end

@implementation CEPlayer

- (void)dealloc
{
    [timer invalidate];
    
   // [super dealloc];
}

- (void) play 
{
    if(timer)
        return;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:PERIOD target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
}

- (void) playNow:(CGFloat)intervaltime {
    
    if(timer)
        return;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:intervaltime target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
}

- (void) pause
{
    [timer invalidate];
    timer = nil;
   
}

- (void) stop
{
    [timer invalidate];
    timer = nil;
    self.position = 0.0;
}

- (void) timerDidFire:(NSTimer *)theTimer
{
    if(self.position >= 1.0)
    {
        self.position = 0.0;
        [timer invalidate];
        timer = nil;
        [self.delegate playerDidStop:self];
    }
    else
    {
        self.position += PERIOD/self.durationsong;
        [self.delegate player:self didReachPosition:self.position];
    }
}

-(void)forward:(float)point
{
    if(self.position >= 1.0)
    {
        self.position = 0.0;
        [timer invalidate];
        timer = nil;
        [self.delegate playerDidStop:self];
    }
    else
    {
        self.position += (PERIOD*point)/self.durationsong;
        [self.delegate player:self didReachPosition:self.position];
    }

}
-(void)rewind:(float)point
{
    if(self.position >= 1.0)
    {
        self.position = 0.0;
        [timer invalidate];
        timer = nil;
        [self.delegate playerDidStop:self];
    }
    else
    {
        self.position -=(PERIOD*point)/self.durationsong;
        [self.delegate player:self didReachPosition:self.position];
    }
  
}
@synthesize position;  // 0..1

@synthesize delegate;

@end
