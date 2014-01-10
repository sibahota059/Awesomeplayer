

#import "AVPlayer+KNAdditions.h"

@implementation AVPlayer (KNVolumeAdditions)

- (NSURL *)currentURL {
  AVAsset *asset = self.currentItem.asset;
  if ([asset isMemberOfClass:[AVURLAsset class]])
    return ((AVURLAsset *)asset).URL;
  return nil;
}

- (void)setVolume:(CGFloat)volume {
  NSArray *audioTracks = [self.currentItem.asset tracksWithMediaType:AVMediaTypeAudio];
  NSMutableArray *allAudioParams = [NSMutableArray array];
  for (AVAssetTrack *track in audioTracks) {
    AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
    [audioInputParams setVolume:volume atTime:kCMTimeZero];
    [audioInputParams setTrackID:[track trackID]];
    [allAudioParams addObject:audioInputParams];
  }
  AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
  [audioMix setInputParameters:allAudioParams];
  [self.currentItem setAudioMix:audioMix];
}

@end