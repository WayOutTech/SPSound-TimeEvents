//
// Created by Johnathan Raymond on 7/5/14.
//

#import "SPALSoundChannel+TimeEvents.h"
#import "TPPreciseTimer.h"
#import <OpenAL/al.h>
#import <QuartzCore/QuartzCore.h>


@implementation SPALSoundChannel (TimeEvents)

- (uint) sourceID {
    return [[self valueForKey:@"_sourceID"] unsignedIntValue];
}

- (void) setStartMoment:(double)start {
    [self setValue:[NSNumber numberWithDouble:start] forKey:@"_startMoment"];
}

- (void) setPauseMoment:(double)start {
    [self setValue:[NSNumber numberWithDouble:start] forKey:@"_pauseMoment"];
}

- (void)seekToOffset:(NSTimeInterval)offset {
    // TODO Make sure you've handled pause states effectively
    alSourcef([self sourceID], AL_SEC_OFFSET, (ALfloat) offset);
    [self performSelector:@selector(revokeSoundCompletedEvent)];
    double startMoment = CACurrentMediaTime() - offset;
    [self setStartMoment:startMoment];
    [self setPauseMoment:0.0];
    [self performSelector:@selector(scheduleSoundCompletedEvent)];
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