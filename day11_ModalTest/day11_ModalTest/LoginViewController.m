//
//  LoginViewController.m
//  day11_ModalTest
//
//  Created by SDT-1 on 2014. 1. 10..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"

@interface LoginViewController ()
- (IBAction)loginButton:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender {
    
    // 여러개의 뷰컨트롤들이 하나의 공통된 요소를 쓰거나 아니면 서로 요소를 쓰려면 헤더추가가 꼬이게된다.
    // 1. Notification(비동기방식)
    //   => UsernameChanged라는 이 알림에 관심있는 아이들을 정한다.
    //      UsernameChanged -> 이름이 바뀌는 곳은 LoginVC, 이름이 바뀌는 것에 관심이 있는 곳은 VC이다.
    //   => 이름이 바뀌었을 때 바뀐다.
    // 2. KVO
    //   =>
    // Key Value Observing
    
    /* Notification으로 하는 방식 */
    NSDictionary *userInfo = @{@"username":self.userField.text};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UsernameChanged" object:nil userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    /* 이전에 하던 방식 */
    // 메인 뷰 컨트롤러에게 값 전달
    //ViewController *mainVC = (ViewController *)self.presentingViewController;
    // 뷰에 직접 넣기
    //mainVC.username.text = self.userField.text;
    // 모달 뷰 컨트롤러 닫기
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
