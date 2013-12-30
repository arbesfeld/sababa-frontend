//
//  TopicViewController.h
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)startAction:(id)sender;

@end
