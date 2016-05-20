//
//  ProcessModule.m
//  TestPAD
//
//  Created by Clay Sanders on 7/12/14.
//  Copyright (c) 2014 ClaySanders. All rights reserved.
//
//  Edited by Eric Ho and Joshua Lafond-Favieres on 12/04/15.
//  Copyright (c) 2015 ClaySanders. All rights reserved.
//

#import "ProcessModule.h"
#import <Accelerate/Accelerate.h>
#import "AnalysisView.h"

@interface ProcessModule ()

@property float K;

@end

@implementation ProcessModule
@synthesize K,nodalCoordinatesMod,analysisDrawing;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





-(double *) createElementMatrix: (NSArray*) elementNodes withElementLength: (float) length{
    
    NSInteger nodeOne = [[elementNodes objectAtIndex:0] integerValue];
    NSInteger nodeTwo = [[elementNodes objectAtIndex:1] integerValue];
    
    float nodeOneX = [[[self.nodalCoordinates objectAtIndex:nodeOne-1] objectAtIndex:0] floatValue]/40;
    float nodeOneY = [[[self.nodalCoordinates objectAtIndex:nodeOne-1] objectAtIndex:1] floatValue]/40;
    
    float nodeTwoX = [[[self.nodalCoordinates objectAtIndex:nodeTwo-1]objectAtIndex:0] floatValue ]/40;
    float nodeTwoY = [[[self.nodalCoordinates objectAtIndex:nodeTwo-1]objectAtIndex:1] floatValue ]/40;
    
    float deltaX = nodeTwoX - nodeOneX;
    float deltaY = -nodeTwoY + nodeOneY;
    
    float cosT = deltaX/length;
    float sinT = deltaY/length;
    
   // NSLog(@"Delta X %f Delta Y %f",deltaX,deltaY);
    
    double * eM = (double * )malloc(6*6*sizeof(double));
    
    double Kval = self.K/(pow(length,3));
    double aVal = [[self.materialsArray objectAtIndex:1] doubleValue];
    double iVal = [[self.materialsArray objectAtIndex:2] doubleValue];
    double Cval = aVal*pow(length,2)/iVal; //C=AL.^2./I
    
    //First row
    eM[0] = (Cval*pow(cosT, 2)+12*pow(sinT,2))*Kval;   eM[6] = (Cval-12)*cosT*sinT*Kval;   eM[12] = -6*length*sinT*Kval;
    eM[18] = -(Cval*pow(cosT, 2)+12*pow(sinT,2))*Kval; eM[24] = -(Cval-12)*cosT*sinT*Kval; eM[30] = -6*length*sinT*Kval;
    
    //Second row
    eM[1] = (Cval-12)*cosT*sinT*Kval;   eM[7] = (Cval*pow(sinT, 2)+12*pow(cosT,2))*Kval;   eM[13] = 6*length*cosT*Kval;
    eM[19] = -(Cval-12)*cosT*sinT*Kval; eM[25] = -(Cval*pow(sinT, 2)+12*pow(cosT,2))*Kval; eM[31] = 6*length*cosT*Kval;
    
    //Third row
    eM[2] = -6*length*sinT*Kval; eM[8] = 6*length*cosT*Kval;   eM[14] = 4*pow(length, 2)*Kval;
    eM[20] = 6*length*sinT*Kval; eM[26] = -6*length*cosT*Kval; eM[32] = 2*pow(length, 2)*Kval;
    
    //Fourth row
    eM[3] = -(Cval*pow(cosT, 2)+12*pow(sinT,2))*Kval; eM[9] = -(Cval-12)*cosT*sinT*Kval; eM[15] = 6*length*sinT*Kval;
    eM[21] = (Cval*pow(cosT, 2)+12*pow(sinT,2))*Kval; eM[27] = (Cval-12)*cosT*sinT*Kval; eM[33] = 6*length*sinT*Kval;
    
    //Fifth row
    eM[4] = -(Cval-12)*cosT*sinT*Kval; eM[10] = -(Cval*pow(sinT, 2)+12*pow(cosT,2))*Kval; eM[16] = -6*length*cosT*Kval;
    eM[22] = (Cval-12)*cosT*sinT*Kval; eM[28] = (Cval*pow(sinT, 2)+12*pow(cosT,2))*Kval;  eM[34] = -6*length*cosT*Kval;
    
    //Sixth row
    eM[5] = -6*length*sinT*Kval; eM[11] = 6*length*cosT*Kval;  eM[17] = 2*pow(length, 2)*Kval;
    eM[23] = 6*length*sinT*Kval; eM[29] = -6*length*cosT*Kval; eM[35] = 4*pow(length, 2)*Kval;
    
   NSLog(@"Cos t %f, Sin t %f",cosT,sinT);
    
    return eM;
    
}

-(double*)getRotationMatrix: (NSArray*) elementNodes withElementLength: (float) length{
    double *rM = (double *)malloc(sizeof(double)*4*4);
    
    NSInteger nodeOne = [[elementNodes objectAtIndex:0] integerValue];
    NSInteger nodeTwo = [[elementNodes objectAtIndex:1] integerValue];
    
    float nodeOneX = [[[self.nodalCoordinates objectAtIndex:nodeOne-1]objectAtIndex:0] floatValue ]/40;
    float nodeOneY =[[[self.nodalCoordinates objectAtIndex:nodeOne -1] objectAtIndex:1] floatValue]/40;
    
    float nodeTwoX =[[[self.nodalCoordinates objectAtIndex:nodeTwo-1]objectAtIndex:0] floatValue ]/40;
    float nodeTwoY = [[[self.nodalCoordinates objectAtIndex:nodeTwo-1]objectAtIndex:1] floatValue ]/40;
    
    float deltaX = nodeTwoX - nodeOneX;
    float deltaY = -nodeTwoY + nodeOneY;
    
    float cosT = deltaX/length;
    float sinT = deltaY/length;
    
    // 0-5 represents first row of rotation matrix
    /*
    rM[0] = cosT;  rM[6] = sinT; rM[12] = 0; rM[18] = 0;     rM[24] = 0;    rM[30] = 0;
    rM[1] = -sinT; rM[7] = cosT; rM[13] = 0; rM[19] = 0;     rM[25] = 0;    rM[31] = 0;
    rM[2] = 0;     rM[8] = 0;    rM[14] = 1; rM[20] = 0;     rM[26] = 0;    rM[32] = 0;
    rM[3] = 0;     rM[9] = 0;    rM[15] = 0; rM[21] = cosT;  rM[27] = sinT; rM[33] = 0;
    rM[4] = 0;     rM[10] = 0;   rM[16] = 0; rM[22] = -sinT; rM[28] = cosT; rM[34] = 0;
    rM[5] = 0;     rM[11] = 0;   rM[17] = 0; rM[23] = 0;     rM[29] = 0;    rM[35] = 1;
    */
    //transpose fingers crossed oh well! we'll shift back to working condition and demo from there!
    rM[0] = cosT;  rM[1] = sinT; rM[2] = 0; rM[3] = 0;     rM[4] = 0;    rM[5] = 0;
    rM[6] = -sinT; rM[7] = cosT; rM[8] = 0; rM[9] = 0;     rM[10] = 0;    rM[11] = 0;
    rM[12] = 0;     rM[13] = 0;    rM[14] = 1; rM[15] = 0;     rM[16] = 0;    rM[17] = 0;
    rM[18] = 0;     rM[19] = 0;    rM[20] = 0; rM[21] = cosT;  rM[22] = sinT; rM[23] = 0;
    rM[24] = 0;     rM[25] = 0;   rM[26] = 0; rM[27] = -sinT; rM[28] = cosT; rM[29] = 0;
    rM[30] = 0;     rM[31] = 0;   rM[32] = 0; rM[33] = 0;     rM[34] = 0;    rM[35] = 1;
    
    return rM;
    
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    //Define Stiffness Value
    self.K = [[self.materialsArray objectAtIndex:0] floatValue]*[[self.materialsArray objectAtIndex:2] floatValue];
    
    //Stiffness Value for Truss
    //self.K = [[self.materialsArray objectAtIndex:0] floatValue]*[[self.materialsArray objectAtIndex:1] floatValue];

    //CREATE NODAL STRUCTURAL COORDINATES (size numJoints * 3)
    long nJ = ([self.nodalCoordinates count]);
    //NSLog(@"number of joints %i",nJ);

    
    
    //Create Vector of Element Lengths
    double * eL = (double *)malloc([self.nodalConnectivity count]*sizeof(double));
    
    long numberOfElements= [self.nodalConnectivity count];
    
    NSLog(@"number of elements %li",numberOfElements);
    
    for (int i = 0; i<[self.nodalConnectivity count]; i++) {
        NSArray *element = [self.nodalConnectivity objectAtIndex:i];
        NSInteger nodeOne = [[element objectAtIndex:0]integerValue];
        NSInteger nodeTwo = [[element objectAtIndex:1]integerValue];
        NSLog(@"Nodes are %li,%li",nodeOne,(long)nodeTwo);
        
        
        float nodeOneX = [[[self.nodalCoordinates objectAtIndex:nodeOne -1] objectAtIndex:0] floatValue]/40;
        float nodeOneY = [[[self.nodalCoordinates objectAtIndex:nodeOne -1] objectAtIndex:1] floatValue]/40;
        
        
        float nodeTwoX = [[[self.nodalCoordinates objectAtIndex:nodeTwo -1] objectAtIndex:0] floatValue]/40;
        float nodeTwoY = [[[self.nodalCoordinates objectAtIndex:nodeTwo -1] objectAtIndex:1] floatValue]/40;
        
        
        eL[i]= sqrt((pow((nodeTwoX-nodeOneX), 2) + pow((nodeTwoY-nodeOneY), 2)));
        
        
    }
   // NSLog(@"%f,%f",eL[0],eL[1]);
    
    //Create Load Vector
    
    double *UV = (double *)malloc(3*nJ*sizeof(double));
    for (int i = 0; i<(3*nJ); i++) {
        UV[i] = 0;
    }

    for (int i=0; i<[self.loadData count]; i++) {
        NSArray *loadEntry = [self.loadData objectAtIndex:i];
        
        NSInteger node = [[loadEntry objectAtIndex:0]integerValue];
        
        NSInteger type = [[loadEntry objectAtIndex:1]integerValue];
        
        float magnitude = [[loadEntry objectAtIndex:2]floatValue];
        
        switch (type) {
            case 1:{
                long numb = 3*node -3;
                UV[numb] =magnitude;
                break;
            }
            case 2:{
                long numb = 3*node -2;
                UV[numb] = magnitude;
                break;
            }
            case 3:{
                long numb = 3*node -1;
                UV[numb] = magnitude;
                break;
            }
            default:
                break;
        }
        
        //NSLog(@"%f,%f,%f,%f,%f,%f",UV[0],UV[1],UV[2],UV[3],UV[4],UV[5]);
        
    }
    
        //ASSEMBLE GLOBAL STRUCTURAL MATRIX
    
    
   // double *bsm = (double*)malloc(2*nJ*2*nJ * sizeof(double));
    
    double *GSM = (double*)malloc((3*nJ*3*nJ)*sizeof(double));
    double *GSM2 = (double*)malloc((3*nJ*3*nJ)*sizeof(double));
    
    for (int i=0; i<(3*nJ*3*nJ); i++) {
        GSM[i] = 0;
        GSM2[i]= 0;
    }
    
    for (int i =0; i<([self.nodalConnectivity count]); i++) {
        NSArray *element = [self.nodalConnectivity objectAtIndex:i];
        NSInteger nodeOne = [[element objectAtIndex:0]integerValue];
        NSInteger nodeTwo = [[element objectAtIndex:1]integerValue];

        
        double *elemMatrix = [self createElementMatrix:element withElementLength:eL[i]];
        
        //NSLog(@" temp for Nodes %i and %i are %f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,",nodeOne, nodeTwo, temp[0], temp[1], temp[2], temp[3], temp[4], temp[5], temp[6], temp[7],temp[8],temp[9], temp[10], temp[11], temp[12], temp[13], temp[14], temp[15]);
        
        
        
        
        
        
        double *NSCEL = (double*)malloc(6*sizeof(double));

        NSCEL[0] = (3*nodeOne -3);
        NSCEL[1] = (3*nodeOne -2);
        NSCEL[2] = (3*nodeOne -1);
        NSCEL[3] = (3*nodeTwo -3);
        NSCEL[4] = (3*nodeTwo -2);
        NSCEL[5] = (3*nodeTwo -1);
        
        NSLog(@"%f,%f,%f,%f,%f,%f",NSCEL[0],NSCEL[1],NSCEL[2],NSCEL[3],NSCEL[4],NSCEL[5]);
        
        for (int j =0; j<(6); j++) {
            for (int k=0; k<(6); k++) {
                int mIndex = (NSCEL[j]*(nJ*3))+ NSCEL[k];
                NSLog(@"GSM index %i is %f",mIndex,GSM[mIndex]);
            
                GSM[mIndex] =  GSM[mIndex]+ elemMatrix[(j*6 + k)];
                GSM2[mIndex] = GSM2[mIndex] + elemMatrix[(j*6 + k)];
                
            }
        }

        
        
    }
    

    //APPLY SUPPORT CONDITIONS
    // inputs : kmod = GSM2, pmod, nsc=nscX,Y,Z, msup=self.supportData, SupportData=/
    // outputs : GSM2, pmod
    
    // sJ = length of MSUP* = 'NS'
    NSInteger sJ = [self.supportData count];
    
    float maxN=0;
    
    //Find Max Diagonal Element
    for (int i = 0; i<(nJ*3); i++) {
        // for each diagonal entry of GSM2 (3nJ x 3nJ)
        float test=GSM2[(i*(nJ*3) + i)];
        if (test > maxN) {
            // 'MAXDIAG'
            maxN = test;
        }
    }
    
    double *Pmod = UV;
    
    for (int p= 0; p<sJ; p++) {
        // array (row)
        NSArray *node = [self.supportData objectAtIndex:p];
        // 'NODE'
        NSInteger joint = [[node objectAtIndex:0]integerValue];
        
        BOOL restX;
        BOOL restY;
        BOOL restT;
        
        
        NSInteger nscX = joint*3-3; //1st nsc val
        NSInteger nscY = joint*3-2; //2nd
        NSInteger nscT = joint*3-1; //3rd
        
        
        //Supported Directions
        restX =  ([[node objectAtIndex:1]isEqualToNumber:@1]|[[node objectAtIndex:1]isEqualToNumber:@3]);
        
        // what is a row of sd? A:MSUP row
        // what is a row of 'sd'? A: node(same as MSUP) [restraint given for each dir 0 if no restraint in that dir]
        // to do: create support data matrix (supMat) row by row based on the first entry of MSUP rows and the supports chosen.
        // Each new support added should make a row in MSUP and a row of all zeros duh in supMat. and the MSUP is already there
        if (restX ==1) {
//            for (int i = 0; i<nJ*3; i++) {
//                Pmod[i] = Pmod[i]-GSM2[(nscX)];//sdpx
//            }
//            
            for (int i = 0; i<nJ*3; i++) {
                GSM2[(nscX*nJ*3)+i] = 0;
                GSM2[(nscX+(i*nJ*3))] = 0;

            }
            GSM2[nscX*nJ*3 + nscX] = maxN;
            Pmod[nscX] = 0;
            
        }
        
        restY = ([[node objectAtIndex:2]isEqualToNumber:@1]);
        
        if (restY ==1) {
//            for (int i = 0; i<nJ*3; i++) {
//                Pmod[i] = Pmod[i]-GSM2[nscY*nJ*3+i]*0;
//            }
            
            for (int i = 0; i<nJ*3; i++) {
                GSM2[(nscY*nJ*3) + i] = 0;
                GSM2[nscY+(i*nJ*3)] = 0;
                
            }
            GSM2[nscY*nJ*3 +nscY] = maxN;
            Pmod[nscY] = 0;
            
        }
        
        restT = ([[node objectAtIndex:3]isEqualToNumber:@1]);
        
        if (restT ==1) {
            // come back to this and fix with support data (SupData)
//            for (int i = 0; i<nJ*3; i++) {
//                Pmod[i] = Pmod[i]-GSM2[nscT*nJ*3+i]*0;
//            }
            
            for (int i = 0; i<nJ*3; i++) {
                GSM2[(nscT*nJ*3) + i] = 0;
                GSM2[nscT+(i*nJ*3)] = 0;
                
            }
            GSM2[nscT*nJ*3 +nscT] = maxN;
            Pmod[nscT] = 0;
            
        }
        
    }
    
    for (int i = 0; i<(3*3*nJ*nJ); i++) {
        NSLog(@"GSM %i is %f and %f",i,GSM[i], GSM2[i] );
        
    }
    
    // NSLog(@"%f, %f",GSM[35],GSM2[35]);
    NSLog(@"PMOD %f,%f,%f,%f,%f,%f",Pmod[0],Pmod[1],Pmod[2],Pmod[3],Pmod[4],Pmod[5]);

    // N	= number of columns of A.
    // NRHS	= number of columns of B, usually 1.
    // LDA	= number of rows of A.
    // IPIV	= pivot indices.
    // LDB	= number of rows of B.
   
    long node = (nJ*3);
    
    int NDIM = (int) node, N = NDIM, NRHS = 1, LDA = NDIM, LDB = NDIM;
    int IPIV[NDIM], INFO;
    
    dgesv_(&N, &NRHS, GSM2, &LDA, IPIV, Pmod, &LDB, &INFO);
    
    NSLog(@"Displacements are { %f %f %f %f %f,%f}",Pmod[0],Pmod[1],Pmod[2],Pmod[3],Pmod[4],Pmod[5]);
    
    double *disp = (double*)malloc(nJ*3*sizeof(double));
    double *dispModified = (double*)malloc(nJ*3*sizeof(double));
    for (int i = 0; i<(3*nJ); i++) {
        disp[i] = 0;
        dispModified[i] = 0;
    }
    
    

    //CHANGED HERE!
    for (int i=0; i<(3*nJ); i++) {
        float ival = Pmod[i];
        disp[i] = ival;
        //scaling
        dispModified[i] = ival * 40 *60;
        
    }
    
    for (int i = 0; i<[self.nodalCoordinates count]; i++) {
        
        NSArray *element = [self.nodalCoordinates objectAtIndex:i];
        float elemX = [[element objectAtIndex:0]floatValue];
        float elemY = [[element objectAtIndex:1]floatValue];
        
        NSLog(@" %i, point: [%f,%f], disp [%f,%f]",i,elemX,elemY,dispModified[3*i],dispModified[3*i + 1]);
        
        
        elemX = elemX + dispModified[3*i];
        elemY = elemY -dispModified[3*i + 1];
        NSLog(@"new Point %f,%f",elemX,elemY);
        
        NSArray * elemMod = [[NSArray alloc]initWithObjects:[NSNumber numberWithFloat:elemX],[NSNumber numberWithFloat:elemY],nil];
        if ([self.nodalCoordinatesMod count]==0) {
            self.nodalCoordinatesMod = [[NSMutableArray alloc]initWithObjects:elemMod, nil];
        }else{
            [self.nodalCoordinatesMod insertObject:elemMod atIndex:i];
        }

    }
    
    NSLog(@" Nodal Coordinates %@",self.nodalCoordinates);
    
    NSLog(@"Modified Nodal Coordinates %@", self.nodalCoordinatesMod);
    
    //ELEMENT FORCES
    /*
    NSMutableArray *elementForces = [[NSMutableArray alloc]init];
    for (int i=0; i<[self.nodalConnectivity count]; i++) {
        
        NSArray * currentMember = [self.nodalConnectivity objectAtIndex:i];
        
        int node1 = [[[self.nodalConnectivity objectAtIndex:i] objectAtIndex:0] integerValue];
        int node2 = [[[self.nodalConnectivity objectAtIndex:i] objectAtIndex:1] integerValue];
     
        NSMutableArray * nscEl = [[NSMutableArray alloc]init];
        [nscEl addObject: [NSNumber numberWithInteger:(node1*3-3)]];
        [nscEl addObject: [NSNumber numberWithInteger:(node1*3-2)]];
        [nscEl addObject: [NSNumber numberWithInteger:(node1*3-1)]];
        [nscEl addObject: [NSNumber numberWithInteger:(node2*3-3)]];
        [nscEl addObject: [NSNumber numberWithInteger:(node2*3-2)]];
        [nscEl addObject: [NSNumber numberWithInteger:(node2*3-1)]];
        
        NSMutableArray * dispEl = [[NSMutableArray alloc]init];
        [dispEl addObject: [NSNumber numberWithDouble:disp[node1*3-3]]];
        [dispEl addObject: [NSNumber numberWithDouble:disp[node1*3-2]]];
        [dispEl addObject: [NSNumber numberWithDouble:disp[node1*3-1]]];
        [dispEl addObject: [NSNumber numberWithDouble:disp[node2*3-3]]];
        [dispEl addObject: [NSNumber numberWithDouble:disp[node2*3-2]]];
        [dispEl addObject: [NSNumber numberWithDouble:disp[node2*3-1]]];
     
        double n1X = [[[self.nodalCoordinates objectAtIndex:node1] objectAtIndex:0] doubleValue];
        double n1Y = [[[self.nodalCoordinates objectAtIndex:node1] objectAtIndex:1] doubleValue];
        double n2X = [[[self.nodalCoordinates objectAtIndex:node2] objectAtIndex:0] doubleValue];
        double n2Y = [[[self.nodalCoordinates objectAtIndex:node2] objectAtIndex:1] doubleValue];
     
        double * kElem = [self createElementMatrix:currentMember withElementLength:eL[i]];
        double * rotMatTranspose = [self getRotationMatrix:currentMember withElementLength:eL[i]];
        
        NSMutableArray * fElGlobal = [[NSMutableArray alloc]init];
        NSMutableArray * fElLocal = [[NSMutableArray alloc]init];
        for (int p=0; p<6; p++) {
            double f = 0;
            for (int n=0; n<6; n++) {
                f = f + kElem[p*6+n]*[[dispEl objectAtIndex:n] doubleValue];
            }
            [fElGlobal addObject:[NSNumber numberWithDouble:f]];
        }
        for (int p=0; p<6; p++) {
            double f = 0;
            for (int n=0; n<6; n++) {
                f = f + rotMatTranspose[p*6+n]*[[fElGlobal objectAtIndex:n] doubleValue];
            }
            [fElLocal addObject:[NSNumber numberWithDouble:f]];
        }
        
        [elementForces addObject:fElLocal];
        
        
    }
    analysisDrawing.memberForces = elementForces;
     */
    
//    double *forces = (double*)malloc(nJ*3*sizeof(double));
//    
//    for (int i = 0; i<(3*nJ); i++) {
//        forces[i] = 0;
//    }
//    
//    
//    for (int i = 0; i<(3*nJ); i++) {
//        float ival = 0;
//        float ivalOld = 0;
//        for (int j = 0; j<(3*nJ); j++) {
//            ival = ivalOld + Pmod[j]*GSM[(3*nJ*j + i)];
//            ivalOld = ival;
//            
//        }
//        NSLog(@"Ival %f",ival);
//        
//
//        forces[i] = ival;
//
//    }
//    
//    self.memberList = [[NSMutableArray alloc] initWithCapacity:[self.nodalConnectivity count]];
//    double * tOrC = (double *)malloc([self.nodalConnectivity count]* sizeof(double));
//    for (int i = 0; i<([self.nodalConnectivity count]); i++) {
//        tOrC[i] = 0;
//        
//    }
//    
//    for (int i = 0; i<([self.nodalConnectivity count]); i++) {
//        NSArray * element = [self.nodalConnectivity objectAtIndex:i];
//        NSInteger nodeOne  = [[element objectAtIndex: 0 ]integerValue];
//        NSInteger nodeTwo = [[element objectAtIndex:0]integerValue];
//        
//        float dispXOne = Pmod[nodeOne*3];
//        float dispYOne = Pmod[nodeOne * 3  + 1];
//        float dispTOne = Pmod[nodeOne * 3  + 2];
//        
//        float dispXTwo = Pmod[nodeTwo * 3];
//        float dispYTwo = Pmod[nodeTwo * 3  + 1];
//        float dispTTwo = Pmod[nodeOne * 3  + 2];
//        
//        double *localD = (double * )malloc(6*sizeof(double));
//        double *localF = (double * )malloc(6*sizeof(double));
//        
//        localD[0] = dispXOne;
//        localD[1] = dispYOne;
//        localD[2] = dispTOne;
//        localD[3] = dispXTwo;
//        localD[4] = dispYTwo;
//        localD[5] = dispTTwo;
//        
//    
//
//        
//        double * elementMat = [self createElementMatrix:element withElementLength:eL[i]];
//        
//        
//        for (int k = 0; k<(6); k++) {
//            float kval = 0;
//            float kvalOld = 0;
//            for (int j = 0; j<(6); j++) {
//                kval = kvalOld + localD[j]*elementMat[(6*j + k)];
//                kvalOld = kval;
//                
//            }
//
//            
//            localF[k] = kval;
//            
//        }
//        
//        double * rotateM = [self getRotationMatrix:element withElementLength:eL[i]];
//        
//        double * f = (double *)malloc(6*sizeof(double));
//
//        
//        for (int k = 0; k<6; k++) {
//            float kval = 0;
//            float kvalOld = 0;
//            for (int j = 0; j<6; j++) {
//                kval = kvalOld + localF[j]*rotateM[6*j + k];
//                kvalOld = kval;
//                
//            }
//            NSLog(@"Kval %f",kval);
//            
//            f[k] = kval;
//            
//        }
//        
//        if (f[0] <0) {
//            tOrC[i] = -1;
//            
//        }else{
//            tOrC[i] = 1;
//        }
//        
//        
//        NSArray * elForces = [[NSArray alloc]initWithObjects:[NSNumber numberWithFloat:f[0]],[NSNumber numberWithFloat:f[1]],[NSNumber numberWithFloat:f[2]],[NSNumber numberWithFloat:f[3]],[NSNumber numberWithFloat:f[4]],[NSNumber numberWithFloat:f[5]],nil];
//        if ([self.memberList count]==0) {
//            self.memberList = [[NSMutableArray alloc]initWithObjects:elForces, nil];
//        }else{
//            [self.memberList insertObject:elForces atIndex:i];
//        }
    
        //NSLog(@"EL FORCES %f %f %f %f %f %f",elForces[0],elForces[1],elForces[2],elForces[3],elForces[4],elForces[5]);
                
//    }
    


    //NSLog(@"T or C %f %f",tOrC[0],tOrC[1]);
    
    
    
    
    //Send Data to Analysis View
    
    analysisDrawing.nodalCoordsMod= self.nodalCoordinatesMod;
    analysisDrawing.nodalConnectivity= self.nodalConnectivity;
    analysisDrawing.nodalCoordinates = self.nodalCoordinates;
    analysisDrawing.del = disp;
    //analysisDrawing.memberForces = self.memberList;
    
    
    
    
    
    
}




//Look at condition number of matrix--should be close to zero if matrix is singular
//look at lowest eigenvalue of the matrix--if close to zero then error message
//identify the dimension of null space
//scale 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
