//
//  ViewController.m
//  SababaApp
//
//  Created by mata on 12/29/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import "FirstOptionViewController.h"

@interface FirstOptionViewController ()

@end

@implementation FirstOptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 8;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return @"English";
        case 1:
            return @"French";
        case 2:
            return @"Hebrew";
        case 3:
            return @"Spanish";
        case 4:
            return @"Italian";
        case 5:
            return @"Mandarin";
        case 6:
            return @"Japanese";
        case 7:
            return @"German";
        default:
            NSAssert(false, @"Not supported");
            return @"";
    }
}

- (IBAction)continueAction:(id)sender {
    NSLog(@"Continue");
}

@end
