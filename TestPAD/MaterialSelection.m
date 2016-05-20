//
//  MaterialSelection.m
//  TestPAD
//
//  Created by Clay Sanders on 7/8/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//

#import "MaterialSelection.h"

@interface MaterialSelection ()
@property (weak, nonatomic) IBOutlet UITextField *youngsModulus;
@property (weak, nonatomic) IBOutlet UITextField *crossSection;
@property (weak, nonatomic) IBOutlet UITextField *momentOfInertia;
@end



@implementation MaterialSelection

@synthesize materialDelegate;
@synthesize eValue,aValue,iValue;

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)didCancel:(id)sender{
    [self.materialDelegate didCancelMaterialSelection:self];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /* for backspace */
    if([string length]==0){
        return YES;
    }
    
    /*  limit to only numeric characters  */
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-.e"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    
    return NO;
    
}

-(void)didSetMaterials:(id)sender{
    self.eValue = [NSNumber numberWithFloat:[self.youngsModulus.text floatValue]];
    self.aValue = [NSNumber numberWithFloat:[self.crossSection.text floatValue]];
    self.iValue = [NSNumber numberWithFloat:[self.momentOfInertia.text floatValue]];
    
    NSArray *materials =[[NSArray alloc]init];
                         
    materials = [NSArray arrayWithObjects:self.eValue,self.aValue,self.iValue, nil];
    
    [self.materialDelegate materialSelectionController:self didSelectMaterial:materials];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.youngsModulus.keyboardType = UIKeyboardTypeDecimalPad;
    self.crossSection.keyboardType = UIKeyboardTypeDecimalPad;
    self.momentOfInertia.keyboardType = UIKeyboardTypeDecimalPad;
    
    //this part sets the inputs to null initially. Pesky
    if(self.eValue!=nil){
        [self.youngsModulus setText:[NSString stringWithFormat:@"%@",self.eValue]];
    }
    if(self.aValue!=nil){
        [self.crossSection setText:[NSString stringWithFormat:@"%@",self.aValue]];
    }
    if(self.iValue!=nil){
        [self.momentOfInertia setText:[NSString stringWithFormat:@"%@",self.iValue]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
