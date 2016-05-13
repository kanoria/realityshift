//
//  Network.h
//  RealityShift
//
//  Created by Matt on 16/5/12.
//  Copyright © 2016年 Matt.Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@protocol NetworkDelegate <NSObject>

- (void)didGetTranscribedData: (NSString *) text;
- (void)didGetTranslatedData: (NSString *) text;


@end


@interface Network : NSObject

@property (nonatomic,  weak) id<NetworkDelegate> delegate;
- (NSString*) hack: (NSString*) str;
+(instancetype) shareInstance ; 
- (void)translate:(NSString*) text;
- (void) transcribe:(NSString*) path;
@end
