//
// Created by Johnathan Raymond on 2/9/14.
//

#import "SPSound+TimeEvents.h"
#import "SPUtils.h"
#import "SPALSound+TimeEvents.h"
#import "SPAVSound+TimeEvents.h"
#import "SPMacros.h"

@implementation SPSound (TimeEvents)

+ (SPSound *)soundTimeExtensionWithContentsOfFile:(NSString *)path
{
    return [[SPSound alloc] initTimeExtensionWithContentsOfFile:path];
}

- (id)initTimeExtensionWithContentsOfFile:(NSString *)path {
    // SPSound is a class factory! We'll return a subclass, not self.

    NSString *fullPath = [SPUtils absolutePathToFile:path withScaleFactor:1.0f];
    if (!fullPath) [NSException raise:SP_EXC_FILE_NOT_FOUND format:@"file %@ not found", path];

    NSString *error = nil;

    AudioFileID fileID = 0;
    void *soundBuffer = NULL;
    int   soundSize = 0;
    int   soundChannels = 0;
    int   soundFrequency = 0;
    double soundDuration = 0.0;

    do
    {
        OSStatus result = noErr;

        result = AudioFileOpenURL((__bridge CFURLRef) [NSURL fileURLWithPath:fullPath],
                kAudioFileReadPermission, 0, &fileID);
        if (result != noErr)
        {
            error = [NSString stringWithFormat:@"could not read audio file (%x)", (int)result];
            break;
        }

        AudioStreamBasicDescription fileFormat;
        UInt32 propertySize = (UInt32)sizeof(fileFormat);
        result = AudioFileGetProperty(fileID, kAudioFilePropertyDataFormat, &propertySize, &fileFormat);
        if (result != noErr)
        {
            error = [NSString stringWithFormat:@"could not read file format info (%x)", (int)result];
            break;
        }

        propertySize = sizeof(soundDuration);
        result = AudioFileGetProperty(fileID, kAudioFilePropertyEstimatedDuration,
                &propertySize, &soundDuration);
        if (result != noErr)
        {
            error = [NSString stringWithFormat:@"could not read sound duration (%x)", (int)result];
            break;
        }

        if (fileFormat.mFormatID != kAudioFormatLinearPCM)
        {
            error = @"sound file not linear PCM";
            break;
        }

        if (fileFormat.mChannelsPerFrame > 2)
        {
            error = @"more than two channels in sound file";
            break;
        }

        if (!TestAudioFormatNativeEndian(fileFormat))
        {
            error = @"sounds must be little-endian";
            break;
        }

        if (!(fileFormat.mBitsPerChannel == 8 || fileFormat.mBitsPerChannel == 16))
        {
            error = @"only files with 8 or 16 bits per channel supported";
            break;
        }

        UInt64 fileSize = 0;
        propertySize = sizeof(fileSize);
        result = AudioFileGetProperty(fileID, kAudioFilePropertyAudioDataByteCount,
                &propertySize, &fileSize);
        if (result != noErr)
        {
            error = [NSString stringWithFormat:@"could not read sound file size (%x)", (int)result];
            break;
        }

        UInt32 dataSize = (UInt32)fileSize;
        soundBuffer = malloc(dataSize);
        if (!soundBuffer)
        {
            error = @"could not allocate memory for sound data";
            break;
        }

        result = AudioFileReadBytes(fileID, false, 0, &dataSize, soundBuffer);
        if (result == noErr)
        {
            soundSize = (int)dataSize;
            soundChannels = fileFormat.mChannelsPerFrame;
            soundFrequency = fileFormat.mSampleRate;
        }
        else
        {
            error = [NSString stringWithFormat:@"could not read sound data (%x)", (int)result];
            break;
        }
    }
    while (NO);

    if (fileID) AudioFileClose(fileID);

    if (!error)
    {
        self = [[SPALSound alloc] initWithData:soundBuffer size:soundSize channels:soundChannels
                                     frequency:soundFrequency duration:soundDuration];
    }
    else
    {
        NSLog(@"Sound '%@' will be played with AVAudioPlayer [Reason: %@]", path, error);
        self = [[SPAVSound alloc] initWithContentsOfFile:fullPath duration:soundDuration];
    }

    free(soundBuffer);
    return self;
}

@end