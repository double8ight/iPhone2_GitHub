//
//  ViewController.m
//  day16_tMapTest
//
//  Created by SDT-1 on 2014. 1. 17..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "TMapView.h"

@interface ViewController ()<TMapViewDelegate>
- (IBAction)addOverlay:(id)sender;
- (IBAction)moveToSeoul:(id)sender;
- (IBAction)addMarker:(id)sender;
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
    [_mapView setZoomLevel:12];
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark T-MAP DELEGATE
-(void)onClick:(TMapPoint *)TMP
{
    NSLog(@"Tapped point : %@", TMP);
}

-(void)onLongClick:(TMapPoint *)TMP
{
    NSLog(@"long clicked :%@", TMP);
}

// 콜 아웃의 버튼을 누른 경우
-(void)onCalloutRightbuttonClick:(TMapMarkerItem *)markerItem
{
    NSLog(@"Market ID: %@", [markerItem getID]);
    
    if([@"T-ACADEMY" isEqualToString:[markerItem getID]])
    {
        DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        detailVC.urlStr = @"https://oic.skplanet.com/";
        
        // 모달로 표시
        [self presentViewController:detailVC animated:YES completion:nil];
    }
}

-(void)onCustomObjectClick:(TMapObject *)obj
{
    if([obj isKindOfClass:[TMapMarkerItem class]])
    {
        TMapMarkerItem *marker = (TMapMarkerItem *)obj;
        NSLog(@"Marker Clicked %@", [marker getID]);
    }
}



- (IBAction)addOverlay:(id)sender {
    CLLocationCoordinate2D coord[5] = {
        CLLocationCoordinate2DMake(37.460143, 126.914062),
        CLLocationCoordinate2DMake(37.469136, 126.981869),
        CLLocationCoordinate2DMake(37.437930, 126.989937),
        CLLocationCoordinate2DMake(37.413255, 126.959038),
        CLLocationCoordinate2DMake(37.426752, 126.913548)
    };
    
    TMapPolygon *polygon = [[TMapPolygon alloc]init];
    
    [polygon setLineColor:[UIColor redColor]];
    
    [polygon setPolygonAlpha:0];
    [polygon setLineWidth:8.0];
    
    for(int i = 0 ; i < 5 ; i++ )
    {
        [polygon addPolygonPoint:[TMapPoint mapPointWithCoordinate:coord[i]]];
    }
    
    [_mapView addTMapPolygonID:@"관악산" Polygon:polygon];
}

- (IBAction)moveToSeoul:(id)sender {
    TMapPoint *centerPoint = [[TMapPoint alloc]initWithLon:126.96 Lat:37.466];
    [_mapView setCenterPoint:centerPoint];
}

- (IBAction)addMarker:(id)sender {
    NSString *itemID = @"T-ACADEMY";
    
    TMapPoint *point = [[TMapPoint alloc]initWithLon:126.95 Lat:37.45];
    TMapMarkerItem *marker = [[TMapMarkerItem alloc]initWithTMapPoint:point];
    [marker setIcon:[UIImage imageNamed:@"t_logo.jpg"]];
    
    //콜 아웃 설정
    [marker setCanShowCallout:YES];
    [marker setCalloutTitle:@"티 아카데미"];
    [marker setCalloutRightButtonImage:[UIImage imageNamed:@"right_arrow.jpg"]];
    
    [_mapView addTMapMarkerItemID:itemID Marker:marker];
    
}
@end
