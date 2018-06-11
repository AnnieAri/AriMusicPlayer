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
//  FreeStreamerPlayer.m 
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

#import "FreeStreamerPlayer.h"
#import "FSAudioController.h"
#import "AriMusicPlayer.h"
#import "AriMusicPlayerCallBack.h"

@interface FreeStreamerPlayer ()
@property (nonatomic,strong) FSAudioController *audioController;
@property (nonatomic,strong) NSTimer *progressUpdateTimer;
/**是否是暂停状态*/
@property (nonatomic,assign) BOOL isPause;
@end

@implementation FreeStreamerPlayer
+ (instancetype)sharedPlayer {
    static FreeStreamerPlayer *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[self alloc] init];
//        ins.volume = 100;
        __weak FreeStreamerPlayer *weakIns = ins;
        
        ins.audioController.onStateChange = ^(FSAudioStreamState state) {
            switch (state) {
                case kFsAudioStreamPlaying:
                    if (weakIns.delegate && [weakIns.delegate respondsToSelector:@selector(playerStartPlaying)]) {
                        [weakIns.delegate playerStartPlaying];
                    }
                    break;
                case kFsAudioStreamPaused:
                    if (weakIns.delegate && [weakIns.delegate respondsToSelector:@selector(playerDidPause)]) {
                        [weakIns.delegate playerDidPause];
                    }
                    break;
                case kFsAudioStreamPlaybackCompleted:
                    weakIns.isPause = true;
                    [weakIns stop];
                    if (weakIns.delegate && [weakIns.delegate respondsToSelector:@selector(playerDidFinishItem:)]) {
                        [weakIns.delegate playerDidFinishItem:weakIns];
                    }
                    break;
                case kFsAudioStreamRetrievingURL:
                    
                case kFsAudioStreamStopped:
                    
                case kFsAudioStreamBuffering:
                    
                case kFsAudioStreamSeeking:
                    
                case kFsAudioStreamFailed:
                    
                case kFsAudioStreamRetryingStarted:
                    
                case kFsAudioStreamRetryingSucceeded:
                    
                case kFsAudioStreamRetryingFailed:
                    
                case kFSAudioStreamEndOfFile:
                    ///缓冲完全部数据
                case kFsAudioStreamUnknownState:
                    break;
            }
        };
        ins.audioController.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
            if (weakIns.delegate && [weakIns.delegate respondsToSelector:@selector(playerDidLoadFailed)]) {
                [weakIns.delegate playerDidLoadFailed];
            }
        };
        
    });
    return ins;
}
- (FSAudioController *)audioController
{
    if (!_audioController) {
        _audioController = [[FSAudioController alloc] init];
    }
    return _audioController;
}
- (void)setVolume:(float)volume {
    if (volume < 0) {
        self.audioController.volume = 0;
    }else if (volume > 1) {
        self.audioController.volume = 1;
    }else {
        self.audioController.volume = volume;
    }
}
- (void)setTotalTime:(double)totalTime {
    if (_totalTime != totalTime) {
        _totalTime = totalTime;
    }
}
#pragma mark - AriMusicPlayer功能
- (void)playFromURL:(NSURL *)url {
    [self.audioController playFromURL:url];
    self.isPause = false;
    if (!self.progressUpdateTimer) {
        self.progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                    target:self
                                                                  selector:@selector(updatePlaybackProgress)
                                                                  userInfo:nil
                                                                   repeats:YES];
    }
}
- (void)play {
    if (!self.progressUpdateTimer) {
        self.progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                    target:self
                                                                  selector:@selector(updatePlaybackProgress)
                                                                  userInfo:nil
                                                                   repeats:YES];
    }
    if (self.isPause) {
        [self.audioController pause];
    }else {
        [self.audioController play];
    }
}
- (void)pause {
    [self.progressUpdateTimer invalidate];
    self.progressUpdateTimer = nil;
    [self.audioController pause];
    self.isPause = true;
}
- (void)stop {
    if (!self.isPause) {
        [self.audioController pause];
    }
    [self.progressUpdateTimer invalidate];
    self.progressUpdateTimer = nil;
}
- (void)seekToTime:(double)time {
    if (self.totalTime == 0) {
        return;
    }
    FSStreamPosition p = {0,0,0,time/self.totalTime};
    [self.audioController.activeStream seekToPosition:p];
}

#pragma mark - 时间监听
- (void)updatePlaybackProgress
{
    if (self.audioController.activeStream.continuous) {
        ///可能在缓存
    } else {
        ///顺畅播放 回调进度
        
        FSStreamPosition cur = self.audioController.activeStream.currentTimePlayed;
        FSStreamPosition end = self.audioController.activeStream.duration;
        self.totalTime = end.playbackTimeInSeconds;
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayWith:currentTime:totalTime:)]) {
            [self.delegate playerPlayWith:self currentTime:cur.playbackTimeInSeconds totalTime:end.playbackTimeInSeconds];
        }
    }
    
    
    ///   已缓存的buffer
    //    if (self.audioController.activeStream.contentLength > 0) {
    //        // A non-continuous stream, show the buffering progress within the whole file
    //        FSSeekByteOffset currentOffset = self.audioController.activeStream.currentSeekByteOffset;
    //
    //        UInt64 totalBufferedData = currentOffset.start + self.audioController.activeStream.prebufferedByteCount;
    //
    //        float bufferedDataFromTotal = (float)totalBufferedData / self.audioController.activeStream.contentLength;
    //
    //        self.bufferingIndicator.progress = (float)currentOffset.start / self.audioController.activeStream.contentLength;
    //
    //        // Use the status to show how much data we have in the buffers
    //        self.prebufferStatus.frame = CGRectMake(self.bufferingIndicator.frame.origin.x,
    //                                                self.bufferingIndicator.frame.origin.y,
    //                                                CGRectGetWidth(self.bufferingIndicator.frame) * bufferedDataFromTotal,
    //                                                5);
    //        self.prebufferStatus.hidden = NO;
    //    } else {
    //        // A continuous stream, use the buffering indicator to show progress
    //        // among the filled prebuffer
    //        self.bufferingIndicator.progress = (float)self.audioController.activeStream.prebufferedByteCount / _maxPrebufferedByteCount;
    //    }
}
@end
