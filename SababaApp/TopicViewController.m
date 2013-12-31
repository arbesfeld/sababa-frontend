//
//  TopicViewController.m
//  SababaApp
//
//  Created by mata on 12/30/13.
//  Copyright (c) 2013 Matthew Arbesfeld. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicCell.h"
#import "WebViewController.h"

@interface TopicViewController ()

@end

@implementation TopicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loading:NO];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loading:NO];
}

- (void)loading:(BOOL)isLoading
{
    if (isLoading) {
        _loadingView.hidden = NO;
        [_collectionView setAllowsSelection:NO];
        for (int i = 0; i < 9; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            TopicCell *cell = (TopicCell *)[_collectionView cellForItemAtIndexPath:indexPath];
            [cell select];
        }
    } else {
        _loadingView.hidden = YES;
        [_collectionView setAllowsSelection:YES];
        for (int i = 0; i < 9; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            TopicCell *cell = (TopicCell *)[_collectionView cellForItemAtIndexPath:indexPath];
            [cell deselect];
        }
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TopicCell" forIndexPath:indexPath];
    [cell set:indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCell *cell = (TopicCell *)[collectionView cellForItemAtIndexPath:indexPath];

    [self loading:YES];
    [cell selectSpecial];
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *idString = [oNSUUID UUIDString];
    
    NSString *url = [NSString stringWithFormat:@"%@user/%@/article/%@", BASE_URL, idString, cell.titleLabel.text];
    NSLog(@"Getting %@", url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _articleData = [[NSMutableData alloc] init];
    [connection start];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_articleData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Fail");
    _articleData = nil;
    [self loading:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (!_articleData) {
        NSLog(@"No article data");
        return;
    }
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:_articleData
                          options:kNilOptions
                          error:&error];
    
    if (error) {
        NSLog(@"Error converting to json, %@", [error localizedDescription]);
    }
    
    NSLog(@"%@",json);
    _articleData = nil;
    
    WebViewController *webViewer = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webViewer setContent:json];
    webViewer.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:webViewer animated:YES];
}

#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(88, 88);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(18, 18, 18, 18);
}

- (IBAction)settingsButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"set"];
}
@end
