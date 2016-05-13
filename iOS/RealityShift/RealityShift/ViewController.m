//
//  ViewController.m
//  RealityShift
//
//  Created by Matt on 16/5/11.
//  Copyright © 2016年 Matt.Zhang. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () {
    int piece;
    Boolean isStop;
}

@property (weak, nonatomic) IBOutlet UITextView *TranslateTextView;
@property (weak, nonatomic) IBOutlet UIImageView *RedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *GreenImageView;
@property (weak, nonatomic) IBOutlet UIButton *ClearButton;
@property (nonatomic, retain) POVoiceHUD *voiceHud;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Network shareInstance].delegate = self;
    //[[Network shareInstance] translate:@"你好世界"];
    //[[Network shareInstance] transcribe:@"/Users/Matt/Downloads/google-speech-v2-master/audio/test.wav"];
    //[[Network shareInstance] transcribe:@"/Users/Matt/Projects/test.wav"];
    //[[Network shareInstance] hack:@"t"] ;
    
    piece = 0;
    isStop = true;
    [_TranslateTextView setText:@""];
    
    self.voiceHud = [[POVoiceHUD alloc] init];
    self.voiceHud.delegate = self;
    [_RedImageView setUserInteractionEnabled:YES];
    [_GreenImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTapRed =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RedTapped:)];
    [singleTapRed setNumberOfTapsRequired:1];
    [_RedImageView addGestureRecognizer:singleTapRed];
    
    UITapGestureRecognizer *singleTapGreen =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GreenTapped:)];
    [singleTapGreen setNumberOfTapsRequired:1];
    [_GreenImageView addGestureRecognizer:singleTapGreen];
    
    [_ClearButton addTarget:self action:@selector(ClearButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)RedTapped:(id)sender {
    [_RedImageView setHidden:true];
    [_GreenImageView setHidden:false];
    isStop = true;
    [self.voiceHud commitRecording];
}

- (void)GreenTapped:(id)sender {
    [_GreenImageView setHidden:true];
    [_RedImageView setHidden:false];
    isStop = false;
    [self StartRecord];
}
- (void) StartRecord {
    [self.voiceHud startForFilePath:[NSString stringWithFormat:@"%@/Documents/%d.wav", NSHomeDirectory(), piece]];
    piece += 1;
}

- (void) ClearButtonTapped:(id)sender {
    [_TranslateTextView setText:@""];
}

#pragma mark - POVoiceHUD Delegate

- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength {
    NSLog(@"Sound recorded with file %@ for %.2f seconds", [recordPath lastPathComponent], recordLength);
    [[Network shareInstance] transcribe:recordPath];
    if (!isStop) {
        [self StartRecord];
    }
}

#pragma mark - Network Delegate

- (void) didGetTranscribedData: (NSString *) text {
    if ([text  isEqual: @""]) {
        
        return;
    }
    [[Network shareInstance] translate:text];
}


- (void) didGetTranslatedData: (NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* currentText = [_TranslateTextView text];
        NSString* newText = [[NSString alloc] initWithFormat:@"%@\n%@", currentText, text];
        [_TranslateTextView setText:newText];
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
