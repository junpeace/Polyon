//
//  mapView.h
//  polyon
//
//  Created by jun on 5/22/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
// #import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
// #import "Place.h"
// #import "MapView.h"

@interface detailMapView : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    int firstGet;
    NSTimer *timer;
    NSString *currentLatitude, *currentLongitude;
    CLLocationCoordinate2D coordinate;
    NSMutableArray *listOfCoordination;
}

@property (nonatomic, strong) NSString *longitude, *latitude;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
