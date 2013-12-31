//
//  ViewController.h
//  SababaApp
//
//  Created by mata on 12/29/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstOptionViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) NSString *language;

+ (FirstOptionViewController *) sharedController;
- (IBAction)continueAction:(id)sender;

@end
