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

FirstOptionViewController *_sharedController;

+ (FirstOptionViewController *)sharedController {
    return _sharedController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"set"]) {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TopicViewController"];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"set"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_pickerView selectRow:4 inComponent:0 animated:NO];
    _sharedController = self;
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
    NSUInteger selectedRow = [_pickerView selectedRowInComponent:0];
    _language = [[_pickerView delegate] pickerView:_pickerView titleForRow:selectedRow forComponent:0];
}

@end
