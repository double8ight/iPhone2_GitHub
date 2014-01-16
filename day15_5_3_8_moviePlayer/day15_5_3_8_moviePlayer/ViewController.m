//
//  ViewController.m
//  day15_5_3_8_moviePlayer
//
//  Created by SDT-1 on 2014. 1. 16..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#define MOVIE_URL @"http://movies.apple.com/media/kr/iphone/2011/tours/apple-iphone4s-feature_keynote-kr-20111110_r848-9cie.mov"

@interface ViewController ()
{
    // ARC의 경우에는 포인터가 사라지지 않도록 멤버 변수로 선언한다.
    MPMoviePlayerController *player;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 재생 상태 변경 알림 감시자 등록
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleStateChanged:) name:@"MPMoviePlayerPlaybackStateDidChangeNotification" object:nil];
    
    // 미디어 소스 타입(파일, 스트리밍) 알림 감시자 등록
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleMediaTypeNoti:) name:@"MPMovieSourceTypeAvailableNotifiacation" object:nil];
    
    //NSURL *url = [[NSBundle mainBundle]URLForResource:@"movie" withExtension:@"mp4"];
    //스트리밍 영상 재생용
    NSURL *url = [NSURL URLWithString:MOVIE_URL];
    
    NSAssert((url != nil), @"url is nil");
    
    player = [[MPMoviePlayerController alloc]initWithContentURL:url];
    [player prepareToPlay];
    
    // 부모 뷰의 크기
    [player.view setFrame:self.view.bounds];
    
    [self.view addSubview:player.view];
}

-(void)handleMediaTypeNoti:(NSNotification *)noti
{
    MPMoviePlayerController *p = noti.object;
    NSLog(@"Media source type : %d", p.movieSourceType);
}

-(void)handleStateChanged:(NSNotification *)noti
{
    MPMoviePlayerController *p = noti.object;
    NSLog(@"Playbak state: : %d", p.playbackState);
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
