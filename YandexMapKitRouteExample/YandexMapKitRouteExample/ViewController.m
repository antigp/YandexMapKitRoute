//
//  ViewController.m
//  YandexMapKitRouteExample
//
//  Created by Eugen Antropov on 7/10/13.
//  Copyright (c) 2013 eantropov. All rights reserved.
//

#import "ViewController.h"
#import  <YandexMapKitRoute/YandexMapKitRoute.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [YandexMapKitRoute showRouteOnMap:mapView From:YMKMapCoordinateMake(55.837064,37.487895) To:YMKMapCoordinateMake(55.695618,37.657496)];
    [mapView setCenterCoordinate:YMKMapCoordinateMake(55.754219,37.622478)
                     atZoomLevel:10
                        animated:NO];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
