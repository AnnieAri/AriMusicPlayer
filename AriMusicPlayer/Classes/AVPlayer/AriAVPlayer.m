//	
//  ░░░░░░░░░░░░░░░░░░░░░░░░▄░░
//  ░░░░░░░░░▐█░░░░░░░░░░░▄▀▒▌░
//  ░░░░░░░░▐▀▒█░░░░░░░░▄▀▒▒▒▐
//  ░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐
//  ░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐
//  ░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌
//  ░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒
//  ░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐
//  ░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄
//  ░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒
//  ▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒
//  AriAVPlayer.m 
//  AriMusicPlayer 
// 
//  Created by Ari on 2018/6/11. 
//   
//  github:https://github.com/AnnieAri
//  blog:https://www.jianshu.com/u/e80cddc74b7d
//  qq:6937523
//  学习这件事， 不在乎有没有人教你，最重要的是在于你自己有没有觉悟和恒心。
//  可能一个人说你不服气，两个人说你不服气，很多人在说的时候，你要反省，一定是自己出了一些问题。	
// 

#import "AriAVPlayer.h"
#import "AriMusicPlayerCallBack.h"
#define AudioDelegate(SEL) self.delegate&&[self.delegate respondsToSelector:@selector(SEL)]
@import AVFoundation;
@interface AriAVPlayer()
{
    BOOL _isPrepare;//播放是否准备成功
    BOOL _isPlaying;//播放器是否正在播放
    BOOL _pauseFlag;//暂停标记
}
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)NSTimer *timer;
@end
@implementation AriAVPlayer
+ (instancetype)sharedPlayer {
    static AriAVPlayer *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[self alloc] init];
    });
    return ins;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        //通知中心
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endAction:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)setTotalTime:(double)totalTime {
    if (_totalTime != totalTime) {
        _totalTime = totalTime;
    }
}
- (void)setVolume:(float)volume {
    if (volume < 0) {
        self.player.volume = 0;
    }else if (volume > 1) {
        self.player.volume = 1;
    }else {
        self.player.volume = volume;
    }
}
- (void)playFromURL:(NSURL *)url {
    
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    //创建一个item资源
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    [self.player replaceCurrentItemWithPlayerItem:item];
}

- (void)play {
    //判断资源是否准备成功
    if (!_isPrepare) {
        return;
    }
    [self.player play];
    _isPlaying = YES;
    //播放时候的图片转动效果
    //timer初始化
    if (_timer) {
        return;
    }
    
    //创建一个timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingAction:) userInfo:nil repeats:YES];
    if (AudioDelegate(playerStartPlaying)) {
        [self.delegate playerStartPlaying];
    }
    
}
- (void)pause {
    
    if (!_isPlaying) {
        return;
    }
    
    [self.player pause];
    _isPlaying = NO;
    //销毁计时器
    [_timer invalidate];
    _timer = nil;
    if (AudioDelegate(playerDidPause)) {
        [self.delegate playerDidPause];
    }
}


- (void)stop {
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
}

- (void)seekToTime:(double)time {
    
    //当音乐播放器时间改变时,先暂停后播放
    [self pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            [self play];
        }
    }];
    
}





//每隔0.1秒执行一下这个事件
- (void)playingAction:(id)sender {
    if (AudioDelegate(playerPlayWith:currentTime:totalTime:)) {
        //获取当前播放歌曲的时间
        float progress = CMTimeGetSeconds(self.player.currentTime);
        [self.delegate playerPlayWith:self currentTime:progress totalTime:(double)self.player.currentItem.duration.value/self.player.currentItem.duration.timescale];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    AVPlayerStatus staute = [change[@"new"] integerValue];
    switch (staute) {
        case AVPlayerStatusReadyToPlay:
            _isPrepare = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadSuccessWithPlayer:)]) {
                [self.delegate loadSuccessWithPlayer:self];
            }
            break;
        case AVPlayerStatusFailed:
        case AVPlayerStatusUnknown:
            if (AudioDelegate(playerDidLoadFailed)) {
                [self.delegate playerDidLoadFailed];
            }
            
            break;
    }
    
    NSLog(@"change:%@",change);
}
//当一首歌播放结束时会执行下面的方法
- (void)endAction:(NSNotification *)not {
    if (AudioDelegate(playerDidPause)) {
        [self.delegate playerDidPause];
    }
    
    [_timer invalidate];
    _timer = nil;
    if (AudioDelegate(playerDidFinishItem:)) {
        [self.delegate playerDidFinishItem:self];
    }
}


-(AVPlayer*)player
{
    if (_player==nil) {
        _player = [AVPlayer new];
    }
    return _player;
}

-(BOOL)isPlaying
{
    return _isPlaying;
    
}
@end
