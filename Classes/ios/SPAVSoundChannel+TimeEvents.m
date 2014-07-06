//
// Created by Johnathan Raymond on 3/30/14.
//

#import "SPAVSoundChannel+TimeEvents.h"
#import "TPPreciseTimer.h"

@implementation SPAVSoundChannel (TimeEvents)

- (AVAudioPlayer *) getPlayer {
    return [self valueForKey:@"_player"];
}

- (void)seekToOffset:(NSTimeInterval)offset {
    [self getPlayer].currentTime = offset;
}

- (void)scheduleAlarmAtOffset:(NSTimeInterval)offset {
    [TPPreciseTimer scheduleAction:@selector(checkpointReached)
                            target:self
                    inTimeInterval:offset];
}

- (void) checkpointReached {
    [self dispatchEventWithType:SP_EVENT_TYPE_CHECKPOINT];
}

@end