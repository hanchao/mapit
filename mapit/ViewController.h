//
//  ViewController.h
//  mapit
//
//  Created by chao han on 14-2-28.
//  Copyright (c) 2014年 chao han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface ViewController : UIViewController <AGSMapViewLayerDelegate,AGSMapViewTouchDelegate>
{
    AGSSketchGraphicsLayer *_sketchLayer;
    AGSGraphicsLayer *_graphicsLayer;
}

@property (strong, nonatomic) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *baselayerSelect;
@property (weak, nonatomic) IBOutlet UIStepper *zoomStepper;
- (IBAction)basemapChanged:(id)sender;
- (IBAction)sketchChanged:(id)sender;

@end
