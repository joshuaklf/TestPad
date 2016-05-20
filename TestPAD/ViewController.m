//
//  ViewController.m
//  TestPAD
//
//  Created by Clay Sanders on 6/5/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize myViewData;
@synthesize supportSelectionNumber;

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didCancelLoad:(LoadCondition *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadController:(LoadCondition *)controller didSelectType:(NSArray *)loadSelectionArray{
    self.loadSelectionArrayNumbers=loadSelectionArray;
    [controller dismissViewControllerAnimated:YES completion:nil];
    myViewData.loadSelectedArray = self.loadSelectionArrayNumbers;

}

-(void)didCancelSupportCondition:(SupportCondition *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectSupportCondition:(SupportCondition *)controller withModeSelected:(NSNumber *)numMode{
    self.supportSelectionNumber =numMode;
    [controller dismissViewControllerAnimated:YES completion:nil];
    myViewData.supportConditionNumberSelected = self.supportSelectionNumber;
    
}

-(void)didCancelMaterialSelection:(MaterialSelection *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void) materialSelectionController:(MaterialSelection *)controller didSelectMaterial:(NSArray *)material{
    self.materialProperties = material;
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Material Properties %@",self.materialProperties);
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"toLoadSelection"]){
        LoadCondition * loadController = [segue destinationViewController];
        loadController.loadDelegate = self;
        
    }else if ([[segue identifier]isEqualToString:@"toSupportSelection"]){
        SupportCondition *supportController = [segue destinationViewController];
        supportController.supportDelegate =self;
        
    }else if([[segue identifier] isEqualToString:@"toMaterialSelection"]){
        MaterialSelection *materialController = [segue destinationViewController];
        materialController.materialDelegate =self;
        materialController.eValue =[self.materialProperties objectAtIndexedSubscript:0];
        materialController.aValue =[self.materialProperties objectAtIndexedSubscript:1];
        materialController.iValue =[self.materialProperties objectAtIndexedSubscript:2];
        
    }
    
    else if ([[segue identifier] isEqualToString:@"toAnalysisMode"]){
        NSLog(@"nodal Connectivity is %@",myViewData.nodalConnectivity);
        
        ProcessModule *processController = [segue destinationViewController];
        processController.materialsArray =self.materialProperties;
        processController.loadData =myViewData.loadData;
        processController.supportData =myViewData.supportData;
        processController.nodalConnectivity =myViewData.nodalConnectivity;
        processController.nodalCoordinates =myViewData.nodalCoordinates;
    }
}


@end
