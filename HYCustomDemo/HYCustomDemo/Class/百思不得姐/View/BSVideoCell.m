//
//  BSVideoCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BSVideoCell.h"
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

static AVPlayer * video_player_;
static AVPlayerLayer *playerLayer_;
static UIButton *lastPlayBtn_;
static NSTimer *avTimer_;
static BS_List *last_List;
static UIProgressView *progress_;

@interface BSVideoCell ()
@property (strong, nonatomic) AVPlayerItem *playerItem;
@end

@implementation BSVideoCell

-(void)setList:(BS_List *)list{
    _list = list;
    
    BS_U *u = list.u;
    NSString *iconStr = [u.header firstObject];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"head-default"]];
    
    self.nameLabel.text = u.name.length>0?u.name:@"186****1207";
    self.timeLabel.text = [Tools compareCurrentTime:list.passtime];
    
    self.detailLabel.text = list.text;
    
    
    BS_Video *video = list.video;
    
    self.imageHeight.constant = (CGFloat)video.height/video.width * Main_Screen_Width;
    [self layoutIfNeeded];
    
    //静态图
    [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:[video.thumbnail firstObject]]];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:video.video.firstObject]];
        video_player_ = [AVPlayer playerWithPlayerItem:self.playerItem];
        video_player_.volume = 1.0f;
        playerLayer_ = [AVPlayerLayer playerLayerWithPlayer:video_player_];
        playerLayer_.backgroundColor = [UIColor clearColor].CGColor;
        playerLayer_.videoGravity = AVLayerVideoGravityResizeAspect;
        avTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        [avTimer_ setFireDate:[NSDate distantFuture]];
        progress_ = [[UIProgressView alloc] initWithFrame:CGRectZero];
        progress_.backgroundColor = [UIColor whiteColor];
        progress_.tintColor = [UIColor whiteColor];
        progress_.trackTintColor =[UIColor whiteColor];
        progress_.progressTintColor = [UIColor redColor];
    });
    video.videoPlaying = NO;
    last_List.video.videoPlaying = NO;
    
    [self.playButton setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [lastPlayBtn_  setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [video_player_ pause];//可以继续播放 else else else
    [avTimer_ setFireDate:[NSDate distantFuture]];
    [playerLayer_ removeFromSuperlayer];
    progress_.hidden = !video.videoPlaying;
    progress_.progress = 0;
}

- (IBAction)playButtonAction:(UIButton *)sender {
    [self layoutIfNeeded];
    
    BS_Video *video = self.list.video;
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion integerValue] < 9) {
        MPMoviePlayerViewController *movieVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:video.video.firstObject]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentMoviePlayerViewControllerAnimated:movieVC];
    }else{
        self.playButton.selected = !sender.isSelected;
        lastPlayBtn_.selected = !lastPlayBtn_.isSelected;
        if (last_List != self.list) {
            [playerLayer_ removeFromSuperlayer];
            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:video.video.firstObject]];
            [video_player_ replaceCurrentItemWithPlayerItem:self.playerItem];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:self.playerItem];
            
            playerLayer_.frame = CGRectMake(self.bottomImageView.x, self.bottomImageView.y, CGRectGetWidth(self.bottomImageView.frame), CGRectGetHeight(self.bottomImageView.frame));
            progress_.frame = CGRectMake(playerLayer_.frame.origin.x, CGRectGetMaxY(playerLayer_.frame), playerLayer_.frame.size.width, 2);
            [self.layer addSublayer:playerLayer_];
            [self addSubview:progress_];
            
            progress_.progress = 0;
            [video_player_ play];
            [avTimer_ setFireDate:[NSDate date]];
            
            last_List.video.videoPlaying = NO;
            video.videoPlaying = YES;
            [lastPlayBtn_ setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
            [self.playButton setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
        }else{
            if(last_List.video.videoPlaying){
                [video_player_ pause];
                [avTimer_ setFireDate:[NSDate distantFuture]];
                video.videoPlaying = NO;
                [self.playButton setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
            }else{
                playerLayer_.frame = CGRectMake(self.bottomImageView.x, self.bottomImageView.y, CGRectGetWidth(self.bottomImageView.frame), CGRectGetHeight(self.bottomImageView.frame));
                progress_.frame = CGRectMake(playerLayer_.frame.origin.x, CGRectGetMaxY(playerLayer_.frame), playerLayer_.frame.size.width, 2);
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:self.playerItem];
                [self.layer addSublayer:playerLayer_];
                [self addSubview:progress_];
                [video_player_ play];
                [avTimer_ setFireDate:[NSDate date]];
                video.videoPlaying = YES;
                [self.playButton setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
            }
        }
        progress_.hidden = !video.videoPlaying;
        last_List = self.list;
        lastPlayBtn_ = self.playButton;
    }
}


- (void)timer{
    Float64 currentTime = CMTimeGetSeconds(video_player_.currentItem.currentTime);
    if (currentTime > 0){
        progress_.progress =  currentTime / CMTimeGetSeconds(video_player_.currentItem.duration);
        NSLog(@" --- progress %f --- ",progress_.progress);
    }
}
-(void)playerItemDidReachEnd:(AVPlayerItem *)playerItem{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    last_List.video.videoPlaying = NO;
    self.list.video.videoPlaying = NO;
    [lastPlayBtn_ setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [video_player_ pause];
    [video_player_ seekToTime:kCMTimeZero];
    [playerLayer_ removeFromSuperlayer];
    progress_.hidden = !self.list.video.videoPlaying;
    progress_.progress = 0;
}

-(void)dealloc{
    [video_player_ pause];
    [playerLayer_ removeFromSuperlayer];
    last_List.video.videoPlaying = NO;
    [lastPlayBtn_ setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //[avTimer_ invalidate];
    //avTimer_= nil;
}



@end
