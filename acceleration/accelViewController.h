//
//  accelViewController.h
//  acceleration
//
//  Created by Joan Magno on 3/9/13.
//  Copyright (c) 2013 Joan Magno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface accelViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    //Outlet to connect to UI PickerView
    IBOutlet UIPickerView *pickerView;
    //Data source for PickerView
    NSArray *pickerViewArray;
    //For file manipulation
}


//Buttons
- (IBAction)buttonPressed:(id)sender;//GO BUTTON!
- (IBAction)clearButton:(id)sender;
//- (IBAction)changeButton:(id)sender;

//Picker View Array
@property (nonatomic, retain) NSArray *pickerViewArray;

//TextField
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UITextField *timeIntervalField;
@property (weak, nonatomic) IBOutlet UITextField *updatePerSecondField;

//Labels
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (weak, nonatomic) IBOutlet UILabel *xGyro;
@property (weak, nonatomic) IBOutlet UILabel *yGyro;
@property (weak, nonatomic) IBOutlet UILabel *zGyro;
@property (weak, nonatomic) IBOutlet UILabel *xDevice;
@property (weak, nonatomic) IBOutlet UILabel *yDevice;
@property (weak, nonatomic) IBOutlet UILabel *zDevice;

//CMMotion Manager
@property (strong,nonatomic) CMMotionManager *manager;


@property NSTimer *controlTimer;
@end
