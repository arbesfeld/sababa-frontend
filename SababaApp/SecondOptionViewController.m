//
//  SecondOptionViewController.m
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import "SecondOptionViewController.h"
#import "FirstOptionViewController.h"

@interface SecondOptionViewController ()

@end

@implementation SecondOptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_pickerView selectRow:1 inComponent:0 animated:NO];
    [_numberPickerView selectRow:4 inComponent:0 animated:NO];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (thePickerView == _numberPickerView) {
        return 10;
    }
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (thePickerView == _numberPickerView) {
        return [NSString stringWithFormat:@"%d",row + 1];
    }
    
    switch (row) {
        case 0:
            return @"English";
        case 1:
            return @"French";
        case 2:
            return @"Hebrew";
        default:
            NSAssert(false, @"Not supported");
            return @"";
    }
}

- (IBAction)continueAction:(id)sender {
    NSUInteger selectedRow = [_pickerView selectedRowInComponent:0];
    NSString *language = [[_pickerView delegate] pickerView:_pickerView titleForRow:selectedRow forComponent:0];
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *idString = [oNSUUID UUIDString];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    float floatLevel = [[[_numberPickerView delegate] pickerView:_numberPickerView titleForRow:[_numberPickerView selectedRowInComponent:0] forComponent:0] floatValue] / 10.0;
    NSNumber *level = [NSNumber numberWithFloat:floatLevel];
    NSString *postURL = [NSString stringWithFormat:@"%@user/%@", BASE_URL, idString];
    NSString *nativeLanguage = [FirstOptionViewController sharedController].language;
    
    NSDictionary *json = [[NSDictionary alloc] initWithObjectsAndKeys:
                          nativeLanguage, @"native",
                          language, @"learning",
                          level, @"level",
                          nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    
    NSLog(@"POST: %@", postURL);
    NSLog(@"POST_DATA: %@", json);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:postData ];
    
    NSURLResponse *response;
    NSError *err;
    NSData *returnData = [ NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *content = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    
    if (err) {
        NSLog(@"Error: %@", [err localizedDescription]);
    }
    NSLog(@"responseData: %@", content);
}

@end
