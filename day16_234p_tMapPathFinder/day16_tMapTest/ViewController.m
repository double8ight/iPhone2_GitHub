//
//  ViewController.m
//  day16_tMapTest
//
//  Created by SDT-1 on 2014. 1. 17..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "TMapView.h"

@interface ViewController ()<UISearchBarDelegate>
- (IBAction)transportTypeChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transportType;
@property (strong, nonatomic) TMapMarkerItem *startMarker, *endMarker;
@property (strong, nonatomic) TMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _mapView = [[TMapView alloc] initWithFrame:CGRectMake(10, 80, 300, 300)];
    [_mapView setSKPMapApiKey:@"91799d0b-b00a-32a9-84f0-6f409417cf4c"];
    _mapView.clipsToBounds = YES;
    [_mapView setZoomLevel:19];
    [self.view addSubview:_mapView];
    
    
    // 시작 지점 마커
    _startMarker = [[TMapMarkerItem alloc]init];
    [_startMarker setIcon:[UIImage imageNamed:@"red_pin.jpg"]];
    TMapPoint *startPoint = [_mapView convertPointToGpsX:50 andY:50];
    [_startMarker setTMapPoint:startPoint];
    [_mapView addCustomObject:_startMarker ID:@"START"];
    
    // 종료 지점 마커
    _endMarker = [[TMapMarkerItem alloc]init];
    [_endMarker setIcon:[UIImage imageNamed:@"red_pin.jpg"]];
    TMapPoint *endPoint = [_mapView convertPointToGpsX:300 andY:300];
    [_endMarker setTMapPoint:endPoint];
    [_mapView addCustomObject:_endMarker ID:@"END"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 이동 방법 세그웨이 변경시
- (IBAction)transportTypeChanged:(id)sender {
    [self showPath];
    
    
}


// 시작 지점과 종료 지점 사이의 경로를 검색한다.
-(void)showPath
{
    TMapPathData *path = [[TMapPathData alloc]init];
    
    TMapPolyLine *line = [path findPathDataWithType:_transportType.selectedSegmentIndex startPoint:[_startMarker getTMapPoint] endPoint:[_endMarker getTMapPoint]];
    
    if(line != nil)
    {
        [_mapView showFullPath:@[line]];
        
        // 경로 안내선에 마커가 가리는 것을 방지
        [_mapView bringMarkerToFront:_startMarker];
        [_mapView bringMarkerToFront:_endMarker];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showPath];
}
@end
