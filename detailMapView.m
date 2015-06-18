//
//  mapView.m
//  polyon
//
//  Created by jun on 5/22/15.
//  Copyright (c) 2015 jun. All rights reserved.
//

#import "detailMapView.h"

// https://maps.googleapis.com/maps/api/directions/json?origin=3.116227,101.595110&destination=3.0260481,101.5491794
// http://stackoverflow.com/questions/14756762/google-maps-sdk-for-ios-and-routes
// http://www.meonbinary.com/2014/02/route-directions-with-ios7-mapkit-and-google-maps-api

@interface detailMapView ()

@end

@implementation detailMapView
{
   // GMSMapView *mapView_;
}

@synthesize latitude, longitude;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [_mapView setDelegate:self];
    _mapView.showsUserLocation = YES;
    [_mapView setAlpha: 1];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Get Directions";
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self setUpView];
}

-(void) getLocation
{
    CLLocation *location = [locationManager location];
    coordinate = [location coordinate];
    
    currentLatitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    currentLongitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    // if current location is 0, 0, abort
    if([currentLatitude intValue] == 0 && [currentLongitude intValue] == 0)
    { return; }
    
    NSLog(@"currentLatitude  = %@", currentLatitude);
    NSLog(@"currentLongitude = %@", currentLongitude);
    NSLog(@"passLatitude  = %@", latitude);
    NSLog(@"passLongitude = %@", longitude);
    
    [timer invalidate];
    
    [self proceedToGenerateMap];
}

-(void) proceedToGenerateMap
{
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([currentLatitude floatValue], [currentLongitude floatValue]);
    CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    
    [self calculateRoutesFrom:startCoordinate to:endCoordinate];
        
    [self drawCalculatedRoutesOnMap];
}

-(void) setUpView
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // delegate method ~
}

-(void) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t
{
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
    
    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    
    NSError *error = nil;
    NSStringEncoding encoding;
    
    NSString *apiResponse = [[NSString alloc] initWithContentsOfURL: apiUrl
                            usedEncoding:&encoding error:&error];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"points:\\\"([^\\\"]*)\\\"" options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:apiResponse options:0 range:NSMakeRange(0, [apiResponse length])];
    NSString *encodedPoints = [apiResponse substringWithRange:[match rangeAtIndex:1]];
    
    [self decodePolyLine:[encodedPoints mutableCopy]];
}

-(void)decodePolyLine: (NSMutableString *)encoded
{
    listOfCoordination = [[NSMutableArray alloc] init];
    
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude_local = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude_local = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue: latitude_local forKey: @"latitude"];
        [dict setValue: longitude_local forKey:@"longtitude"];
        
        [listOfCoordination addObject: dict];
    }
}

-(void) drawCalculatedRoutesOnMap
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    [_mapView setRegion:region];
    
    [_mapView setCenterCoordinate:coordinate animated:YES];
    
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate2;
    
    [self.mapView addAnnotation:point];
    
    int stepIndex = 0;
    
    CLLocationCoordinate2D stepCoordinates[1  + [listOfCoordination count] + 1];
    
    stepCoordinates[stepIndex] = coordinate;
    
    for(int i = 0; i < [listOfCoordination count]; i++)
    {
        stepCoordinates[++stepIndex] = CLLocationCoordinate2DMake([[[listOfCoordination objectAtIndex: i] objectForKey:@"latitude"] floatValue], [[[listOfCoordination objectAtIndex: i] objectForKey:@"longtitude"] floatValue]);
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count:1 + stepIndex];
    
    [_mapView addOverlay:polyLine];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    
    polylineView.lineWidth = 10.0;
    
    return polylineView;
}

/*
-(void) thirdPartyLibrary_path
{
    MapView* mapView = [[MapView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview: mapView];
    
    Place* home = [[Place alloc] init];
    home.latitude = [currentLatitude floatValue];
    home.longitude = [currentLongitude floatValue];
    
    Place* office = [[Place alloc] init];
    office.latitude = [latitude floatValue];
    office.longitude = [longitude floatValue];
    
    [mapView showRouteFrom:home to:office];
}
 */

/*
- (void)fetchingGroupsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}
 */

/*
-(void) getRouteDetails
{
    // much more faster compare to asynchronous request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false", [currentLatitude floatValue], [currentLongitude floatValue], [latitude floatValue], [longitude floatValue]]]];
    
    NSURLResponse * response = nil;
    
    NSError * error = nil;
    
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error)
    {   [self fetchingGroupsFailedWithError:error]; }
    else
    {   [self receivedGroupsJSON:data]; }
}
*/

/*
-(void) testOnMapKit
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    [_mapView setRegion:region];
    
    [_mapView setCenterCoordinate:coordinate animated:YES];
    
    // much more faster compare to asynchronous request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false", [currentLatitude floatValue], [currentLongitude floatValue], [latitude floatValue], [longitude floatValue]]]];
    
    
    NSURLResponse * response = nil;
    
    NSError * error = nil;
    
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response error:&error];
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSArray *routes = [result objectForKey:@"routes"];
    
    NSDictionary *firstRoute = [routes objectAtIndex:0];
    
    NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
    
    NSDictionary *end_location = [leg objectForKey:@"end_location"];
    
    double lat = [[end_location objectForKey:@"lat"] doubleValue];
    
    double longt = [[end_location objectForKey:@"lng"] doubleValue];
    
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(lat, longt);
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate2;
    point.title =  [leg objectForKey:@"end_address"];
    
    [self.mapView addAnnotation:point];
    
    NSArray *steps = [leg objectForKey:@"steps"];
    
    int stepIndex = 0;
    
    CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
    
    stepCoordinates[stepIndex] = coordinate;
    
    for (NSDictionary *step in steps)
    {
        NSDictionary *start_location = [step objectForKey:@"start_location"];
        
        stepCoordinates[++stepIndex] = [self coordinateWithLocation:start_location];
        
        if ([steps count] == stepIndex)
        {
            NSDictionary *end_location = [step objectForKey:@"end_location"];
            
            stepCoordinates[++stepIndex] = [self coordinateWithLocation:end_location];
        }
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count:1 + stepIndex];
    
    [_mapView addOverlay:polyLine];
}*/

/*
- (void)receivedGroupsJSON:(NSData *)objectNotation
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    NSArray *routes = parsedObject[@"routes"];
    NSArray *legs = routes[0][@"legs"];
    NSArray *steps = legs[0][@"steps"];
    
    NSMutableArray *textsteps = [[NSMutableArray alloc] init];
    NSMutableArray *latlong = [[NSMutableArray alloc]init];
    
    for(int i = 0; i< [steps count]; i++)
    {
        NSString *html = steps[i][@"html_instructions"];
        
        [latlong addObject:steps[i][@"end_location"]];
        
        [textsteps addObject:html];
    }
    
    [self drawRoutes : latlong];
}*/

/*
-(void) drawRoutes :(NSMutableArray*) latlong
{
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude: [latitude floatValue] longitude: [longitude floatValue] zoom: 14];
     mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
     mapView_.myLocationEnabled = YES;
     
     GMSMarker *marker = [[GMSMarker alloc]init];
     marker.position = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
     marker.groundAnchor = CGPointMake(0.5, 0.5);
     marker.map = mapView_;
     
     GMSMutablePath *path = [GMSMutablePath path];
     
     for(int i = 0; i < [latlong count]; i++)
     {
     double lat = [latlong[i][@"lat"] doubleValue];
     double lng = [latlong[i][@"lng"] doubleValue];
     
     [path addLatitude:lat longitude:lng];
     }
     
     GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
     rectangle.geodesic = YES;
     rectangle.strokeWidth = 3.f;
     rectangle.map = mapView_;
     
     self.view = mapView_;
}*/

/*
- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude_ = [[location objectForKey:@"lat"] doubleValue];
    double longitude_ = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude_, longitude_);
}*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
