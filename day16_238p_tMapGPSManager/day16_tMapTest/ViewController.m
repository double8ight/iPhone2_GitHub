//
//  ViewController.m
//  day16_tMapTest
//
//  Created by SDT-1 on 2014. 1. 17..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "TMapView.h"

@interface ViewController ()<TMapGpsManagerDelegate>

- (IBAction)switchGPS:(id)sender;
@property (strong, nonatomic) TMapGpsManager *gpsManager;
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
    [self.view addSubview:_mapView];
    
    _gpsManager = [[TMapGpsManager alloc]init];
    [_gpsManager setDelegate:self];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationChanged:(TMapPoint *)newTmp
{
    NSLog(@"location changed: %@", newTmp);
    [_mapView setCenterPoint:newTmp];
    
    NSString *markerID = @"내 위치";
    TMapMarkerItem *marker = [[TMapMarkerItem alloc]init];
    [marker setTMapPoint:newTmp];
    [marker setIcon:[UIImage imageNamed:@"red_pin.jpg"]];
    
    [marker setCanShowCallout:YES];
    //[marker setCalloutTitle:[item getPOIName]];
    //[marker setCalloutSubtitle:[item getPOIAddress]];
    
    [_mapView addCustomObject:marker ID:markerID];
}

-(void)headingChanged:(double)heading
{
    
}

- (IBAction)switchGPS:(id)sender {
    UISwitch *_switch = (UISwitch *)sender;
    
    if(_switch.on == YES)
    {
        [_gpsManager openGps];
    }
    else
    {
        [_gpsManager closeGps];
    }
}
@end
