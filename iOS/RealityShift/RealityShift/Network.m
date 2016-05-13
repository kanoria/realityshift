//
//  Network.m
//  RealityShift
//
//  Created by Matt on 16/5/12.
//  Copyright © 2016年 Matt.Zhang. All rights reserved.
//

#import "Network.h"

@implementation Network
static Network* _instance = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}


- (void)translate:(NSString*) text {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [[NSString alloc] initWithFormat:@"https://www.googleapis.com/language/translate/v2"];
    NSDictionary* params = @{@"key": @"AIzaSyBpZOGjcIQevFWzQDq4_VrxY-wIHym6cik",
                             @"source": @"zh",
                             @"target": @"en",
                             @"q": text};
    [manager GET:url parameters:params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject objectForKey:@"data"];
        NSDictionary* tran = [data objectForKey:@"translations"][0];
        NSString* translatedText = [tran objectForKey:@"translatedText"];
        NSLog(@"TranslatedText: %@", translatedText);
        [self.delegate didGetTranslatedData: translatedText];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (NSString*) hack: (NSString*) str {
    NSRange r = [str rangeOfString:@"\"transcript\":\""];
    if (r.length == 0)
        return @"";
    int loc = r.length+ r.location;
    //NSLog(@"%c", [str characterAtIndex:loc]);
    NSRange limit = {loc, [str length] - loc-1};
    NSRange end = [str rangeOfString:@"\"" options:NSLiteralSearch range:limit];
    //NSLog(@"%c", [str characterAtIndex:end.location]);
    NSRange answer = {limit.location, end.location - limit.location};
    NSString* result = [str substringWithRange:answer];
    //NSLog(@"%@", result);
    return result;
}

- (void) transcribe:(NSString*) path {
//    NSString* urlS = @"https://www.google.com/speech-api/v2/recognize";
    NSString* urlS = @"https://www.google.com/speech-api/v2/recognize?output=json&lang=zh&key=AIzaSyAyyNj4pWpKO0AcmoGT_DLd81vfzLRIqts";
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [AFResponseSerializer serializer];
    NSData *data = [NSData dataWithContentsOfFile:path];
    //NSMutableData *body = [NSMutableData data];
    //[body appendData:data];
    
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"audio/l16; rate=16000" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: data];
///////////////
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Rough STR is: %@", str);
        NSString* result = [self hack:str];
        NSLog(@"Transcribed Text is: %@", result);
        [self.delegate didGetTranscribedData:result];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"In Fail");
        NSLog(@"ERROR:%@", error);
    }];
    
    [operation start];
    
    /*
     {"result":[]}
     {"result":[{"alternative":[{"transcript":"what's the weather like","confidence":0.96594596},{"transcript":"was the weather like"},{"transcript":"what is the weather like"},{"transcript":"what's the weather like in"},{"transcript":"what was the weather like"}],"final":true}],"result_index":0}
    */
}



@end