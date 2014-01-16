//
//  ViewController.m
//  day15_5_4_7_recorder
//
//  Created by SDT-1 on 2014. 1. 16..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
- (IBAction)toggleRecording:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btn;

@end

@implementation ViewController
{
    AVAudioRecorder *recorder;
    NSMutableArray *recordingFiles;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleRecording:(id)sender {
    if([recorder isRecording])
    {
        [self stopRecording];
        self.btn.title = @"Record";
        
    }
    else
    {
        [self startRecording];
        self.btn.title = @"Stop";
    }
}

-(NSString *)getPullPath:(NSString *)fileName
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:fileName];
}

// 녹음 시작
-(void)startRecording
{
    NSDate *date = [NSDate date];
    NSString *filePath = [self getPullPath:[NSString stringWithFormat:@"%@.caf", [date description]]];
    NSLog(@"recording path :%@", filePath);
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    [setting setValue:[NSNumber numberWithFloat:44100.0]  forKey:AVSampleRateKey];
    [setting setValue:[NSNumber numberWithInt:16]  forKey:AVLinearPCMBitDepthKey];
    
    __autoreleasing NSError *error;
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
    recorder.delegate = self;
    if([recorder prepareToRecord])
    {
        self.status.text = [NSString stringWithFormat:@"Recording : %@", [[url path]lastPathComponent]];
        // 10 초간 녹음
        [recorder recordForDuration:10];
    }
}

// 녹음된 파일 목록을 테이블에
-(void)updateRecordedFiles
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    __autoreleasing NSError *error = nil;
    
    recordingFiles = [[NSMutableArray alloc]initWithArray:[fm contentsOfDirectoryAtPath:documentPath error:&error]];
    NSLog(@"%@", recordingFiles);
    [self.table reloadData];
}

// 녹음 중지
-(void)stopRecording
{
    [recorder stop];
    [self updateRecordedFiles];
//    NSLog(@"%d", [recordingFiles count]);
}


// AVAudioRecorder Delegate 메소드 - 녹음이 끝나면
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    self.status.text = @"녹음 완료";
    [self updateRecordedFiles];
}

// AVAudioRecorder Delegate 메소드 - 녹음 중 오류 발생
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    self.status.text = [NSString stringWithFormat:@"녹음 중 오류 : %@", [error description]];
    
}

//#pragma mark Table..
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recordingFiles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    cell.textLabel.text = [recordingFiles objectAtIndex:indexPath.row];
    return cell;
}

// 녹음된 파일 삭제
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName = [recordingFiles objectAtIndex:indexPath.row];
    NSString *fullPath = [self getPullPath:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    __autoreleasing NSError *error = nil;
    BOOL ret = [fm removeItemAtPath:fullPath error:&error];
    // TODO : 에러체크
    if(ret == NO)
    {
        NSLog(@"Error %@", [error localizedDescription]);
        
    }
    [recordingFiles removeObjectAtIndex:indexPath.row];
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic    ];
}

@end
