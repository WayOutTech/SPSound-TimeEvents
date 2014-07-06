//
// Created by Johnathan Raymond on 2/9/14.
//

#import <Foundation/Foundation.h>
#import "SPSound.h"
#import "SXTimeEvents.h"

#define SP_EVENT_TYPE_CHECKPOINT @"checkpoint"

@interface SPSound (TimeEvents)

+ (SPSound *)soundTimeExtensionWithContentsOfFile:(NSString *)path;

- (id)initTimeExtensionWithContentsOfFile:(NSString *)path;

@end

