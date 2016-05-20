//
//  MaterialSelection.h
//  TestPAD
//
//  Created by Clay Sanders on 7/8/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MaterialSelection;
@protocol MaterialSelectionDelegate <NSObject>

-(void) didCancelMaterialSelection: (MaterialSelection *)controller;

-(void) materialSelectionController: (MaterialSelection *) controller didSelectMaterial: (NSArray *)material;

@end

@interface MaterialSelection : UIViewController
@property (nonatomic, strong) id <MaterialSelectionDelegate> materialDelegate;
-(IBAction)didCancel:(id)sender;
-(IBAction)didSetMaterials:(id)sender;
@property NSNumber *eValue;
@property NSNumber *aValue;
@property NSNumber *iValue;

@end
