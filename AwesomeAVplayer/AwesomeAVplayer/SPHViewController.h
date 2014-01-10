//
//  SPHViewController.h
//  AwesomeAVplayer
//
//  Created by Heart on 07/01/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"
#import "CEPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface SPHViewController : UIViewController<CEPlayerDelegate>
{
    int indexvalue;
    float songposition;
    float seektime;
    NSMutableArray *songsArray;
}

@property (strong, nonatomic) AVPlayer *audioPlayer;

@property (retain, nonatomic) IBOutlet CERoundProgressView *progressView;
@property (retain, nonatomic) IBOutlet UISlider *progressSlider;
@property (retain, nonatomic) IBOutlet UIButton *playPauseButton;
@property (retain, nonatomic) CEPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *genrelabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumArt;
@property (weak, nonatomic) IBOutlet UILabel *timePast;
@property (weak, nonatomic) IBOutlet UIImageView *leftVolumeicon;
@property (weak, nonatomic) IBOutlet UIImageView *rightVolumeicon;

- (IBAction) sliderValueChanged:(UISlider *)sender ;
- (IBAction)playPauseButton:(UIButton *)sender;
- (IBAction)rewind:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)facebookShare:(id)sender;
- (IBAction)TwitterShare:(id)sender;


@end
