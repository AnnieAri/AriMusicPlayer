//
//  AriViewController.m
//  AriMusicPlayer
//
//  Created by 18354295998@sina.cn on 06/11/2018.
//  Copyright (c) 2018 18354295998@sina.cn. All rights reserved.
//

#import "AriViewController.h"
#import <AriMusicPlayer/AriPlayerFactory.h>

@interface AriViewController ()<AriMusicPlayerCallBack>
@property (nonatomic,strong) id<AriMusicPlayer> player;
@end

@implementation AriViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test.mp3" withExtension:nil];
//    self.player = [AriPlayerFactory creatPlayerWithType:(AriPlayerTypeAVPlayer) delegate:self];
    self.player = [AriPlayerFactory creatPlayerWithType:(AriPlayerTypeStreamPlayer) delegate:self];
    [self.player playFromURL:url];
}
- (IBAction)pause:(id)sender {
    [self.player pause];
}

- (IBAction)play:(id)sender {
    [self.player play];
}

- (IBAction)seek:(id)sender {
    [self.player seekToTime:10.5];
}

- (void)loadSuccessWithPlayer:(id<AriMusicPlayer>)player {
    NSLog(@"加载成功");
    [player play];
}

- (void)playerDidFinishItem:(id<AriMusicPlayer>)player {
    NSLog(@"播放完毕");
}

- (void)playerDidLoadFailed {
    NSLog(@"加载失败");
}

- (void)playerDidPause {
    NSLog(@"暂停");
}

- (void)playerPlayWith:(id<AriMusicPlayer>)player currentTime:(double)currentTime totalTime:(double)totalTime {
    
    NSString *proceedStr = [NSString stringWithFormat:@"%i:%02i / %i:%02i",
                            (int)currentTime / 60, (int)currentTime % 60,
                            (int)totalTime / 60, (int)totalTime % 60];
    NSLog(@"%@",proceedStr);
    
}

- (void)playerStartPlaying {
    NSLog(@"开始播放");
}
@end
