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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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

    
    
    
     TMapView* _mapView;
     _mapView = [[TMapView alloc] initWithFrame:CGRectMake(10, 80, 300, 300)];
     [_mapView setSKPMapApiKey:@"91799d0b-b00a-32a9-84f0-6f409417cf4c"];
     _mapView.clipsToBounds = YES;
     [_mapView setZoomLevel:12];
    
     TMapPoint *centerPoint = [[TMapPoint alloc]initWithLon:126.95 Lat:37.45];
     [_mapView setCenterPoint:centerPoint];
     [_mapView addTMapPolygonID:@"관악산" Polygon:polygon];
    
     [self.view addSubview:_mapView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
