//
//  accelViewController.m
//  acceleration
//
// Created by Joan Magno on 3/9/13.
//  Latest version Mar 10
//  Copyright (c) 2013 Joan Magno. All rights reserved.
//  Does not create 2nd new file...

#import <CoreMotion/CoreMotion.h>

#import "accelViewController.h"

@interface accelViewController ()
@end

@implementation accelViewController

@synthesize pickerViewArray;
@synthesize manager;
@synthesize controlTimer;

//In the first method we are saying that we want one component in our picker view. You may ask what a component is. Well, if you go to the clock application that comes stock on the iPhone, and add an alarm clock you will see that the picker view has 3 components.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//In the second method we are saying that we want the number of rows in the picker view to the be the number of objects in our NSArray. You should already understand this since we covered it in the last tutorial.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerViewArray count];
}
//In the third method we are populating the picker view with the contents of the NSArray. This works the same way as the table view methods work. We are setting the value of the row in the picker to the object in the NSArray that is at the same index as the picker view is currently selected.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerViewArray objectAtIndex:row];
}


- (void)viewDidLoad
{
    
    //VIEWPICKER: Here we are creating an NSArray and giving a list of strings.
        NSArray *arrayToLoadPicker = [[NSArray alloc] initWithObjects:@"WALK:Normal",@"WALK:Brisk",@"WALK:Slow",@"WALK:Pushcart",@"WALK:Hands_Behind",@"SCAN:Left_to_Right",@"SCAN:Right_to_Left",@"SCAN:R2L_No_Hands",@"SCAN:L2R_No_Hands",@"SCAN:Vertical",@"REACH:Mid",@"REACH:Up",@"REACH:Down",@"REACH:Way_up",@"REACH:Way_Down",@"RETURN:Mid",@"RETURN:Up",@"RETURN:Down",@"RETURN:Way_up",@"RETURN:Way_down", nil];
        self.pickerViewArray = arrayToLoadPicker;
    //CMMOTION MANAGER
    self.manager = [[CMMotionManager alloc] init];
    
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//FOR DELETE ALERT
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // For error information,
    NSError *error;
	if (buttonIndex == 0)
	{        
		// Yes, delete the file by first finding the location and then deleting. Not exactly DRY code, but hopefully it works.
        NSString *filePath = self.field.text;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *myFilePath = [documentsDirectoryPath stringByAppendingPathComponent:filePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtPath:myFilePath error:&error])
        {
            NSLog(@"CLEAR: File %@ is deleted", myFilePath);
            self.field.text = @"";
        }
        else {
            NSLog(@"CLEAR: File %@ was not deleted", myFilePath);
        }
	}
}

-(void) getValues:(NSTimer *) timer {
    //ACCELERATION
    self.xLabel.text = [NSString stringWithFormat:@"%.2f",self.manager.accelerometerData.acceleration.x];
    self.yLabel.text = [NSString stringWithFormat:@"%.2f",self.manager.accelerometerData.acceleration.y];
    self.zLabel.text = [NSString stringWithFormat:@"%.2f",self.manager.accelerometerData.acceleration.z];
    //GYRO
    self.xGyro.text = [NSString stringWithFormat:@"%.2f",self.manager.gyroData.rotationRate.x];
    self.yGyro.text = [NSString stringWithFormat:@"%.2f",self.manager.gyroData.rotationRate.y];
    self.zGyro.text = [NSString stringWithFormat:@"%.2f",self.manager.gyroData.rotationRate.z];
    //DEVICE MANAGER
    self.xDevice.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.manager.deviceMotion.attitude.pitch];
    self.yDevice.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.manager.deviceMotion.attitude.roll];
    self.zDevice.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.manager.deviceMotion.attitude.yaw];
    
    //Insert code here to add to file by calling writeToTextFile
    int selectedIndex = [pickerView selectedRowInComponent:0];
    NSString *message = [NSString stringWithFormat:@"%@",[pickerViewArray objectAtIndex:selectedIndex]];
    NSString *input = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",self.xLabel.text,self.yLabel.text,self.zLabel.text,self.xGyro.text,self.yGyro.text,self.zGyro.text,self.xDevice.text,self.yDevice.text,self.zDevice.text,message];
    
    NSLog(@"%@", input);
    
    //WRITE TO TEXT FILE HERE
    [self writeToTextFile:input];
}

//http://stackoverflow.com/questions/5619719/write-a-file-on-ios
//Call this function with a string to be appended to the text file...
-(void) writeToTextFile:(NSString*) toAppend {
    // For error information,
    NSError *error;
    
    //Get file name in text field in string
    NSString *filePath = self.field.text;
    
    //Read write code from http://stackoverflow.com/questions/4779877/how-to-write-in-append-mode-for-text-file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentTXTPath = [documentsDirectory stringByAppendingPathComponent:filePath];
    NSString *savedString = toAppend;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentTXTPath])
    {
        [savedString writeToFile:documentTXTPath atomically:YES encoding:NSStringEncodingConversionAllowLossy
                           error:&error];
        NSLog(@"File does not exist, new file created: %@",documentTXTPath);
    }
    else
    {
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:documentTXTPath];
        [myHandle seekToEndOfFile];
        [myHandle writeData:[savedString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"File exists, appending to file at: %@",documentTXTPath);

    }
}

- (BOOL)isTextFieldHasFloatValueOrNot:(NSString*)string
{
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet characterSetWithCharactersInString:@"09123456789."];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    if([string length] >0) {
        valid = [alphaNums isSupersetOfSet:inStringSet];
        NSLog(@"%@ i a valid Numeric Value: %i", string,valid);
    }
    return valid;
}

//In our IBAction we are creating an integer and setting the value to the selected index of the picker view.
- (IBAction)buttonPressed:(id)sender {
       
    //Check if start or stop
    UIButton *actionButton = (UIButton *)sender;
    
    bool isFloat = [self isTextFieldHasFloatValueOrNot:self.timeIntervalField.text];
  
    if ([self.field.text length] > 0 && isFloat) {
        if([[(UIButton *)sender currentTitle]isEqualToString:@"Start"])
        {
            //start the action here and change the button text to STOP
            float setTimeInterval = [self.timeIntervalField.text floatValue];
        
            [actionButton setTitle:@"Stop" forState:UIControlStateNormal];
            //CMMOTION MANAGER to start updates on accel, device and gyro. If you want to add a moving thingo to change the interval, you can add the variable here. Pero later na, friend.
            controlTimer = [NSTimer scheduledTimerWithTimeInterval:setTimeInterval target:self selector:@selector(getValues:) userInfo:nil repeats:YES];
        
            //Access ACCELERATION... not sure if these stuff should be here though
            self.manager.accelerometerUpdateInterval = 0.05;  // 20 Hz
            [self.manager startAccelerometerUpdates];
            //Access GYRO
            self.manager.gyroUpdateInterval = 0.05;  // 20 Hz
            [self.manager startGyroUpdates];
            //Device Manager
            self.manager.deviceMotionUpdateInterval = 0.05; // 20 Hz
            [self.manager startDeviceMotionUpdates];
            [actionButton setBackgroundColor:[UIColor redColor]];
            NSLog(@"Started");

        }
        else if([[(UIButton *)sender currentTitle]isEqualToString:@"Stop"])
        {
            //Stop Updates on accel, device and gyro.
            [self.manager stopAccelerometerUpdates];
            [self.manager stopDeviceMotionUpdates];
            [self.manager stopGyroUpdates];
            [actionButton setBackgroundColor:[UIColor greenColor]];
            [actionButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
            //Stop Timer
        
            [controlTimer invalidate];
            controlTimer = nil;
            //stop the action here and change the button text to START
            [actionButton setTitle:@"Start" forState:UIControlStateNormal];
            //Hindi ako sure kung bakit hindi siya bumabalik sa starting values na ito...topak ba ang simulator?-_-
            self.xLabel.text=@"0";
            self.yLabel.text=@"0";
            self.zLabel.text=@"0";
            self.xGyro.text=@"0";
            self.yGyro.text=@"0";
            self.zGyro.text=@"0";
            self.xDevice.text=@"0";
            self.yDevice.text=@"0";
            self.zDevice.text=@"0";
            NSLog(@"Stopped");
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"No acceptable file name or time interval indicated"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
         NSLog(@"No acceptable file name or time interval indicated");
    }
}

- (IBAction)clearButton:(id)sender {
    //Check if the file exists. If yes, prompt user to delete. If yes, delete; if no, don't do anything. If no, then just default to clearing the text field.

        NSString *filePath = self.field.text;
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //... gives you the path to the documents directory. The following checks if there's a file named like that:
        NSString* foofile = [documentsPath stringByAppendingPathComponent:filePath];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
        NSLog(@"File at %@ is being checked if it exists or not.", foofile);
    if (fileExists) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:filePath];
        [alert setMessage:@"Delete this file?"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"Yes"];
        [alert addButtonWithTitle:@"No"];
        [alert show];
        NSLog(@"CLEAR: File exists.");
        
        /** ALTERNATE CODE
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
         message:@"Are you sure you want to delete?"
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         [alert show];**/
    }
    else {
        NSLog(@"CLEAR: File does not exist.");
        self.field.text = @"";
    }
}

/**
- (IBAction)changeButton:(id)sender {
    //No need for change Button... I think
    NSString *filePath = self.field.text;
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //... gives you the path to the documents directory. The following checks if there's a file named like that:
    NSString* foofile = [documentsPath stringByAppendingPathComponent:filePath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    if (!fileExists) {
        //Put code here that creates that particular file
    }
}
 **/

//For the keyboard to return
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

//Stick to orientation portrait!
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UIInterfaceOrientationIsPortrait(interfaceOrientation));
}
/**
- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    [self.timeIntervalLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
}
**/

@end
