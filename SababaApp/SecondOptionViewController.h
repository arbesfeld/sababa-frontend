//
//  SecondOptionViewController.h
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondOptionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)continueAction:(id)sender;

@end
