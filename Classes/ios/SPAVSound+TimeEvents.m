//
// Created by Johnathan Raymond on 3/30/14.
//

#import "SPAVSound+TimeEvents.h"
#import "SPAVSoundChannel+TimeEvents.h"

@implementation SPAVSound (TimeEvents)

- (SPSoundChannel *)createChannel
{
    return [[SPAVSoundChannel alloc] initWithSound:self];
}

@end