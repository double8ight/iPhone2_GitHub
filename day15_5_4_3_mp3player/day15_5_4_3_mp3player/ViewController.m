//
//  ViewController.m
//  day15_5_4_3_mp3player
//
//  Created by SDT-1 on 2014. 1. 16..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;


@end

@implementation ViewController
{
    AVAudioPlayer *player;
    NSArray *musicFiles;
    NSTimer *timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    musicFiles = [[NSArray alloc]initWithObjects:@"music1.mp3", @"music2.mp3", nil];
    
    // 다른 어플리케이션의 므악 재생을 멈추지 않는 정책
    AVAudioSession *session = [AVAudioSession sharedInstance];
    __autoreleasing NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryAmbient error:&error];
}

-(void)viewDidUnload
{
    [timer invalidate];
    timer = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 프로그레스 업데이트
-(void)updateProgress:(NSTimer *)timer
{
    self.progress.progress = player.currentTime / player.duration;
}

// 파일 재생
-(void)playMusic:(NSURL *)url
{
    if(player!=nil)
    {
        if([player isPlaying])
        {
            [player stop];
        }
    
    
        // 플레이어 초기화
        player = nil;
    
        // 타이머 처리
        [timer invalidate];
        timer = nil;
    }
    
    __autoreleasing NSError *error;
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    player.delegate = self;
    
    if([player prepareToPlay])
    {
        self.status.text = [NSString stringWithFormat:@"재생중 : %@", [[url path]lastPathComponent]];
        [player play];
        
        // 타이머 시작
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
        
    }
}

// AVAudioPlayerDelegate - 재생 완료
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.status.text = @"재생완료";
    
    // 타이머 중지
    [timer invalidate];
    timer = nil;
}

// AVAudioPlayerDelegate - 재생 중 오류
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    self.status.text = [NSString stringWithFormat:@"재생 중 오류 발생 : %@", [error description]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [musicFiles count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    cell.textLabel.text = [musicFiles objectAtIndex:indexPath.row];
    return cell;
}

// 셀 선택으로 파일 재생
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filename = [musicFiles objectAtIndex:indexPath.row];
    NSURL *urlForPlay = [[NSBundle mainBundle]URLForResource:filename withExtension:nil];
    [self playMusic:urlForPlay];
}


@end
