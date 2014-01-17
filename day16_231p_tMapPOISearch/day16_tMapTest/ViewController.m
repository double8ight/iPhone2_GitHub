//
//  ViewController.m
//  day16_tMapTest
//
//  Created by SDT-1 on 2014. 1. 17..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "TMapView.h"

@interface ViewController ()<UISearchBarDelegate, TMapViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) TMapView* mapView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    _mapView = [[TMapView alloc] initWithFrame:CGRectMake(10, 80, 300, 300)];
    [_mapView setSKPMapApiKey:@"91799d0b-b00a-32a9-84f0-6f409417cf4c"];
    _mapView.delegate = self;
    
    _mapView.clipsToBounds = YES;
    [_mapView setZoomLevel:13];
    [self.view addSubview:_mapView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//검색버튼 클릭시
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // 새로 작성하기 전에 마커 지우기
    [_mapView clearCustomObjects];
    
    NSString *keyword = self.searchBar.text;
    TMapPathData *path = [[TMapPathData alloc]init];
    NSArray *result = [path requestFindTitlePOI:keyword];
    NSLog(@"Number of POI : %d", result.count);
    
    
    int i = 0 ;
    for(TMapPOIItem *item in result)
    {
        NSLog(@"Name : %@ - Point : %@", [item getPOIName], [item getPOIPoint]);
        
        NSString *markerID = [NSString stringWithFormat:@"marker_%d", i++];
        TMapMarkerItem *marker = [[TMapMarkerItem alloc]init];
        [marker setTMapPoint:[item getPOIPoint]];
        [marker setIcon:[UIImage imageNamed:@"red_pin.jpg"]];
        
        [marker setCanShowCallout:YES];
        [marker setCalloutTitle:[item getPOIName]];
        [marker setCalloutSubtitle:[item getPOIAddress]];
        
        [_mapView addCustomObject:marker ID:markerID];
        
        
    }
    
    
    //[_mapView setCenterPoint:[result[0] getPOIPoint]];
}

@end
