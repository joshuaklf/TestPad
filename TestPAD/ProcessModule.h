//
//  ProcessModule.h
//  TestPAD
//
//  Created by Clay Sanders on 7/12/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import "AnalysisView.h"

@interface ProcessModule : UIViewController
@property NSArray * materialsArray;
@property NSArray * loadData;
@property NSArray * supportData;
@property NSArray * nodalConnectivity;
@property NSArray * nodalCoordinates;
@property (strong, nonatomic) IBOutlet AnalysisView *analysisDrawing;
@property NSMutableArray * nodalCoordinatesMod;
// @property NSMutableArray * memberList;






@end
