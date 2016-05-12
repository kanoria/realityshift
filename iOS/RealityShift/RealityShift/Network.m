//
//  Network.m
//  RealityShift
//
//  Created by Matt on 16/5/12.
//  Copyright © 2016年 Matt.Zhang. All rights reserved.
//

#import "Network.h"

@implementation Network


+ (void)translate:(NSString*) text {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [[NSString alloc] initWithFormat:@"https://www.googleapis.com/language/translate/v2"];
    NSDictionary* params = @{@"key": @"AIzaSyBpZOGjcIQevFWzQDq4_VrxY-wIHym6cik",
                             @"source": @"en",
                             @"target": @"zh",
                             @"q": text};
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSError *err = nil;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&err];
        if (err != nil) {
            NSLog(@"Translate error %@", err);
            return;
        }
        NSLog(@"%@", resp);
        NSDictionary* data = [resp objectForKey:@"data"];
        NSDictionary* tran = [data objectForKey:@"translations"][0];
        NSString* translatedText = [tran objectForKey:@"translatedText"];
        /*
        NSString* translatedText = (NSString*)[(NSDictionary*)[(NSDictionary*)[resp objectForKey: @"data"]
                                     objectForKey: @"translations"]
                                    objectForKey: @"translatedText"];
         */
        NSLog(@"TranslatedText: %@", translatedText);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end