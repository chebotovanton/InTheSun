#ifndef AMPlayerStatusProtocol_h
#define AMPlayerStatusProtocol_h

@protocol AMPlayerStatusProtocol <NSObject>

- (void)stopMusicPlayer;
- (void)playInitialSong;
- (BOOL)isPlaying;

@end


#endif
