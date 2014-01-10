#import <AVFoundation/AVFoundation.h>

@interface AVPlayer (KNVolumeAdditions)
-(NSURL *)currentURL;
-(void)setVolume:(CGFloat)volume;
@end
