//
// Created by Johnathan Raymond on 7/5/14.
//

#import <Foundation/Foundation.h>

#define SP_EVENT_TYPE_CHECKPOINT @"checkpoint"


/** ------------------------------------------------------------------------------------------------

 The SXTimeEvents protocol adds seeking and playback checkpoint notifications to SPSoundChannel


------------------------------------------------------------------------------------------------- */

@protocol SXTimeEvents <NSObject>

/// Moves the channel to the designated offset in ms
- (void)seekToOffset:(NSTimeInterval)offset;

/// Schedules an SPEvent to be invoked when playback on the channel reaches the designated offset.  If the provided
/// offset exceeds the duration of the file, the event will be invoked when the channel reaches the end of playback.
- (void)scheduleAlarmAtOffset:(NSTimeInterval)offset;

@end