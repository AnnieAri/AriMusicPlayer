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
//  AriPlayerFactory.h 
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


#if __has_include(<AriMusicPlayer/AriMusicPlayer.h>)
FOUNDATION_EXPORT double AriMusicPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char AriMusicPlayerVersionString[];
#import <AriMusicPlayer/AriMusicPlayer.h>
#import <AriMusicPlayer/AriMusicPlayerCallBack.h>
#import <AriMusicPlayer/AriAVPlayer.h>
#import <AriMusicPlayer/FreeStreamerPlayer.h>
#else
#import "AriMusicPlayer.h"
#import "AriMusicPlayerCallBack.h"
#import "AriAVPlayer.h"
#import "FreeStreamerPlayer.h"
#endif

typedef NS_ENUM(NSUInteger, AriPlayerType) {
    AriPlayerTypeAVPlayer,
    AriPlayerTypeStreamPlayer
};

@interface AriPlayerFactory : NSObject
+ (id<AriMusicPlayer>)creatPlayerWithType:(AriPlayerType)type delegate:(id<AriMusicPlayerCallBack>)delegate;
@end
