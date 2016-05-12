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
    [Network translate:@"hello"];
    
    piece = 0;
    
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
    NSLog(@"RedTapped");
    [_RedImageView setHidden:true];
    [_GreenImageView setHidden:false];
    [self.voiceHud commitRecording];
}

- (void)GreenTapped:(id)sender {
    [_GreenImageView setHidden:true];
    [_RedImageView setHidden:false];
    NSLog(@"%@", NSHomeDirectory());
    [self.voiceHud startForFilePath:[NSString stringWithFormat:@"%@/Documents/%d.wav", NSHomeDirectory(), piece]];
}

- (void) ClearButtonTapped:(id)sender {
    [_TranslateTextView setText:@""];
}

#pragma mark - POVoiceHUD Delegate

- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength {
    NSLog(@"Sound recorded with file %@ for %.2f seconds", [recordPath lastPathComponent], recordLength);
    [_RedImageView setHidden:true];
    [_GreenImageView setHidden:false];
    

}

#pragma mark - Network Delegate

- (void) didGetTranscribedData: (NSString *) text {
    
}
- (void) didGetTranslatedData: (NSString *)text {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
