//
//  AnalysisView.h
//  TestPAD
//
//  Created by Clay Sanders on 7/13/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>





@interface AnalysisView : UIView

@property NSArray * nodalConnectivity;
@property NSMutableArray * nodalCoordsMod;
@property NSArray * nodalCoordinates;
@property NSInteger drawMode;
@property double * del;
//@property NSMutableArray * memberForces;


@end
