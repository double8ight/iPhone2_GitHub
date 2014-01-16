//
//  ViewController.m
//  day14_4_4_3_syncData
//
//  Created by SDT-1 on 2014. 1. 15..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#define IMAGE_URL @"http://upload.wikimedia.org/wikipedia/commons/4/4d/Klimt_-_Der_Kuss.jpeg"

@interface ViewController ()<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)syncCall:(id)sender;
- (IBAction)aSyncCall:(id)sender;

@end

@implementation ViewController
{
    NSMutableData *buffer;
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


// 동기식은 불러올때 다른 오브젝트들이 제어가 안된다.
- (IBAction)syncCall:(id)sender {
    self.imageView.image = nil;
    NSLog(@"Starting Image Download");
    NSURL *url = [NSURL URLWithString:IMAGE_URL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.imageView.image = [UIImage imageWithData:data];
    NSLog(@"Finished Image Download");
    
}

// 비동기식
- (IBAction)aSyncCall:(id)sender {
    self.imageView.image = nil;
    NSLog(@"Starting Image Download Request");
    NSURL *url = [NSURL URLWithString:IMAGE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url]; // 추가
    [NSURLConnection connectionWithRequest:request delegate:self]; // 추가
    //NSData *data = [NSData dataWithContentsOfURL:url];
    //self.imageView.image = [UIImage imageWithData:data];
    NSLog(@"Finished Image Download Request");
}

// response를 받으면 버퍼를 초기화
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    buffer = [[NSMutableData alloc]init];
}

// 데이터 패킷을 버퍼에 축적
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"RECEIVING: %d", [data length]);
    [buffer appendData:data];
}

// 데이터 전송 완료
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.imageView.image = [UIImage imageWithData:buffer];
    NSLog(@"finished image download");
}

// 에러 발생
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error %@", [error localizedDescription]);
    
}

@end
