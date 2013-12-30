//
//  SecondOptionViewController.m
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import "SecondOptionViewController.h"

@interface SecondOptionViewController ()

@end

@implementation SecondOptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    NSString *language = [[_pickerView delegate] pickerView:_pickerView titleForRow:selectedRow forComponent:0];
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *idString = [oNSUUID UUIDString];
    
    NSString *postURL = [NSString stringWithFormat:@"%@user/%@", BASE_URL, idString];
    NSDictionary *json = [[NSDictionary alloc] initWithObjectsAndKeys:
                          language, @"native",
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
