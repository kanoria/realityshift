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
+ (void)translate:(NSString*) text;
@end
