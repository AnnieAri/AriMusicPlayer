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
//  AriMusicPlayerCallBack.h 
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

#import <Foundation/Foundation.h>
@protocol AriMusicPlayer;
@protocol AriMusicPlayerCallBack <NSObject>
/**准备播放*/
- (void)loadSuccessWithPlayer:(id<AriMusicPlayer>)player;

/**开始播放*/
- (void)playerStartPlaying;

/**暂停播放*/
- (void)playerDidPause;

/**播放进度  当前的播放时间*/
- (void)playerPlayWith:(id<AriMusicPlayer>)player currentTime:(double)currentTime totalTime:(double)totalTime;

/**播放完成的回调*/
- (void)playerDidFinishItem:(id<AriMusicPlayer>)player;

/**加载失败*/
- (void)playerDidLoadFailed;
@end
