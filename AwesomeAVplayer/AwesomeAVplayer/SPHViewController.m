//
//  SPHViewController.m
//  AwesomeAVplayer
//
//  Created by Heart on 07/01/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import "SPHViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "AVPlayer+KNAdditions.h"
#import "SPHSongsList.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>


#define SEEKVALUE  10.00

#define IS_BIGSCREEN ([[UIScreen mainScreen] bounds].size.height == 568.0f)


@interface SPHViewController ()
{
    SLComposeViewController *mySLComposerSheet;  
}
- (BOOL)sharingStatus_facebook;
-(BOOL)sharingStatus_twitter;

@end

@implementation SPHViewController

@synthesize progressView;
@synthesize progressSlider;
@synthesize playPauseButton;
@synthesize player;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    songposition=0.0;
    seektime=0.0;
    indexvalue=0;
    
    songsArray=[[NSMutableArray alloc]init];
    
    SPHSongsList *songlist=[[SPHSongsList alloc]init];
    
    songlist.artist=@"pierson barrow";
    songlist.titlestring=@"Post War - So So Fly";
    songlist.durationString=@"05:09";
    songlist.audioID=@"tcokosUvQyzCl5gwwc3g.mp3";
    [songsArray addObject:songlist];
    
    songlist=[[SPHSongsList alloc]init];
    songlist.artist=@"pierson barrow";
    songlist.titlestring=@"Rock The Ladies";
    songlist.durationString=@"03:36";
    songlist.audioID=@"4ArfJSN3tJvGrYq3Z0pc.mp3";
    [songsArray addObject:songlist];
    
    songlist=[[SPHSongsList alloc]init];
    songlist.artist=@"Mikey Blu";
    songlist.titlestring=@"What Would You Do";
    songlist.durationString=@"02:50";
    songlist.audioID=@"tcokosUvQyzCl5gwwc3g.mp3";
    [songsArray addObject:songlist];
    
    self.titlelabel.text=@"Post War - So So Fly";
    self.genrelabel.text=@"Hip-Hop";
    self.artistLabel.text=@"pierson barrow";
    self.durationLabel.text=@"05:09";
    
    self.albumArt.layer.cornerRadius = 33.0;
    //mImageLayer.backgroundColor = [UIColor greenColor].CGColor;
    //  mImageLayer.contents = (id)[UIImage imageNamed:@"2.png"].CGImage;
    
    self.albumArt.layer.borderWidth=2.0;
    self.albumArt.layer.borderColor = [UIColor whiteColor].CGColor;
    self.albumArt.clipsToBounds=YES;
    self.player = [[CEPlayer alloc] init];
    self.player.delegate = self;
    // self.player.durationsong=[[channelDict valueForKey:@"audio_length"] floatValue]*60;
    
    UIColor *tintColor = [UIColor purpleColor];
    [[UISlider appearance] setMinimumTrackTintColor:tintColor];
    [[CERoundProgressView appearance] setTintColor:tintColor];
    
    self.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    self.progressView.startAngle = (3.0*M_PI)/2.0;
    self.audioPlayer = [[AVPlayer alloc] init];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("audio data downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSURL *audioURL = [NSURL URLWithString:@"http://www.silverlineappz.com/uploads/audio/tcokosUvQyzCl5gwwc3g.mp3"];
        AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:audioURL];
        dispatch_async(dispatch_get_main_queue(), ^{
          //  NSError *error = nil;
         //   NSLog(@"%@", error);
            [self.audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
            [self.audioPlayer play];
            NSString *durationString=[NSString stringWithFormat:@"%lld",(self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale)];
            self.durationLabel.text=[NSString stringWithFormat:@"%02d:%02d",[durationString intValue]/60,[durationString intValue]%60];
            self.player.durationsong=self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:currentItem];
            self.playPauseButton.selected = YES;
            [self performSelector:@selector(updateTime) withObject:nil afterDelay:0];
            [self.player play];
            [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"pausebtnnew"] forState:UIControlStateNormal];
            
            
            
        });
    });

    
    
    if (IS_BIGSCREEN)
    {
        CGRect sliderframe=self.progressSlider.frame;
        CGRect timepastframe=self.timePast.frame;
        CGRect leftVolumeframe=self.leftVolumeicon.frame;
        CGRect rightVolumeframe=self.rightVolumeicon.frame;
        sliderframe.origin.y-=50;
        timepastframe.origin.y-=50;
        leftVolumeframe.origin.y-=50;
        rightVolumeframe.origin.y-=50;
        self.timePast.frame=timepastframe;
        self.progressSlider.frame=sliderframe;
        self.leftVolumeicon.frame=leftVolumeframe;
        self.rightVolumeicon.frame=rightVolumeframe;
        
    }

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)sharingStatus_facebook
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)sharingStatus_twitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (IBAction)playPauseButton:(UIButton *)sender
{
    if(sender.selected) // Shows the Pause symbol
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"playbtnnew"] forState:UIControlStateNormal];
        sender.selected = NO;
        [self.audioPlayer pause];
        [self.player pause];
    }
    else    // Shows the Play symbol
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"pausebtnnew"] forState:UIControlStateNormal];
        sender.selected = YES;
        [self.audioPlayer play];
        [self.player play];
    }
}


- (void) player:(CEPlayer *)player didReachPosition:(float)position
{
    self.progressView.progress = position;
}

- (void) playerDidStop:(CEPlayer *)player
{
    
    self.playPauseButton.selected = NO;
    self.progressView.progress = 0.0;
}





-(void)showSuccessAlertWithText:(NSString *)msgText title:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msgText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
-(void)showWarningAlertWithText:(NSString *)msgText title:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msgText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


- (IBAction)rewind:(id)sender
{
    seektime-=SEEKVALUE;
    [self seektoTime];
    [self.player rewind:SEEKVALUE-2];
}

- (IBAction)forward:(id)sender
{
    seektime+=SEEKVALUE;
    [self seektoTime];
    [self.player forward:SEEKVALUE-2];
}

-(void)seektoTime
{
    if (seektime<0.0) {
        seektime=0.0;
    }
    else
        if(seektime>(self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale)) {
            seektime=self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale;
        }
    int32_t timeScale = self.audioPlayer.currentItem.asset.duration.timescale;
    CMTime time = CMTimeMakeWithSeconds(seektime, timeScale);
    [self.audioPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void) updateTime
{
    AVPlayerItem *currentItem = self.audioPlayer.currentItem;
    CMTime durationV = currentItem.currentTime;
    // NSLog(@"%lld", durationV.value/durationV.timescale);
    NSString *durationString=[NSString stringWithFormat:@"%lld",(durationV.value/durationV.timescale)];
    self.timePast.text=[NSString stringWithFormat:@"%02d:%02d",[durationString intValue]/60,[durationString intValue]%60];
   [self performSelector:@selector(updateTime) withObject:nil afterDelay:1.0];
    
    
}

- (IBAction)previous:(id)sender
{
    if (indexvalue<=0) {
        indexvalue=songsArray.count-1;
    }
    else
    {
        indexvalue--;
    }
    self.progressView.progress = 0.0;
    [self.player stop];
    [self.audioPlayer pause];
    
    SPHSongsList *songlist=[[SPHSongsList alloc]init];
    songlist=[songsArray objectAtIndex:indexvalue];
    
    self.titlelabel.text=songlist.titlestring;
    //self.genrelabel.text=@"Hip-Hop";
    self.artistLabel.text=songlist.artist;
    self.durationLabel.text=songlist.durationString;
    
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"pausebtnnew"] forState:UIControlStateNormal];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("audio data downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSURL *audioURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.silverlineappz.com/uploads/audio/%@",songlist.audioID]];
        AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:audioURL];
        dispatch_async(dispatch_get_main_queue(), ^{
          //  NSError *error = nil;
          //  NSLog(@"%@", error);
            [self.audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
            [self.audioPlayer play];
            NSString *durationString=[NSString stringWithFormat:@"%lld",(self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale)];
            self.durationLabel.text=[NSString stringWithFormat:@"%02d:%02d",[durationString intValue]/60,[durationString intValue]%60];
            self.player.durationsong=self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:currentItem];
            self.playPauseButton.selected = YES;
            [self performSelector:@selector(updateTime) withObject:nil afterDelay:0];
            [self.player play];
            
        });
    });
    

   
}
- (IBAction)next:(id)sender
{
    if (indexvalue>=songsArray.count-1) {
        indexvalue=0;
    }
    else
    {
        indexvalue++;
    }
    self.progressView.progress = 0.0;
    [self.player stop];
    [self.audioPlayer pause];
    
    SPHSongsList *songlist=[[SPHSongsList alloc]init];
    songlist=[songsArray objectAtIndex:indexvalue];
    
    self.titlelabel.text=songlist.titlestring;
    //self.genrelabel.text=@"Hip-Hop";
    self.artistLabel.text=songlist.artist;
    self.durationLabel.text=songlist.durationString;
    
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"pausebtnnew"] forState:UIControlStateNormal];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("audio data downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSURL *audioURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.silverlineappz.com/uploads/audio/%@",songlist.audioID]];
        AVPlayerItem * currentItem = [AVPlayerItem playerItemWithURL:audioURL];
        dispatch_async(dispatch_get_main_queue(), ^{
          //  NSError *error = nil;
          //  NSLog(@"%@", error);
            [self.audioPlayer replaceCurrentItemWithPlayerItem:currentItem];
            [self.audioPlayer play];
            NSString *durationString=[NSString stringWithFormat:@"%lld",(self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale)];
            self.durationLabel.text=[NSString stringWithFormat:@"%02d:%02d",[durationString intValue]/60,[durationString intValue]%60];
            self.player.durationsong=self.audioPlayer.currentItem.duration.value/self.audioPlayer.currentItem.duration.timescale;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:currentItem];
            self.playPauseButton.selected = YES;
            [self performSelector:@selector(updateTime) withObject:nil afterDelay:0];
            [self.player play];
            
        });
    });
    

}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    
    seektime=0.0;
    [self seektoTime];
    self.playPauseButton.selected = NO;
    [self.player stop];
    self.progressView.progress = 0.0;
    [self.audioPlayer pause];
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"playbtnnew"] forState:UIControlStateNormal];
    // isinScreen=NO;
    
    
}
- (IBAction) sliderValueChanged:(UISlider *)sender
{
    [self.audioPlayer setVolume:sender.value];
}


- (void) shareOnTwitterWithText:(NSString*)text andURL:(NSString*)url andImageName:(NSString*)imageName
{
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        // user has setup the iOS6 twitter account
        
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [composeViewController setInitialText:text];
        if([UIImage imageNamed:imageName])
        {
            [composeViewController addImage:[UIImage imageNamed:imageName]];
        }
        if(url)
        {
            [composeViewController addURL:[NSURL URLWithString:url]];
        }
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else
    {
        
        
        [self showSuccessAlertWithText:@"App Permissions disabled in Twitter settings. Go to iPhone Settings and Login With Twitter to Use this feature." title:@""];
        
        
    }
}

- (IBAction)TwitterShare:(id)sender {
    //stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding
    [self shareOnTwitterWithText:[NSString stringWithFormat:@"Listening %@ By %@ via Bajantube iOS app.",self.titlelabel.text,self.artistLabel.text] andURL:@"http://www.bajantube.com/ios" andImageName:@"facebookTwitterShare"];
}


- (IBAction)facebookShare:(id)sender
{
    
    if ([self sharingStatus_facebook]) {
        
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Listening %@ By %@ via Bajantube iOS app.",self.titlelabel.text,self.artistLabel.text]];
            
            //[mySLComposerSheet setInitialText:[NSString stringWithFormat:@"iOS 6 %@ integration test!",mySLComposerSheet.serviceType]]
            [mySLComposerSheet addImage:[UIImage imageNamed:@"facebookTwitterShare"]];
            [mySLComposerSheet addURL:[NSURL URLWithString:@"http://www.bajantube.com/ios"]];
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output = @"";
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"ACtionCancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Successfull";
                    break;
                default:
                    break;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }];
        
    }
    else
    {
        [self showSuccessAlertWithText:@"App Permissions disabled in facebook settings. Go to iPhone Settings and Login With Facebook to Use this feature." title:@""];
        
    }
    
    
    
    
    
}



@end
