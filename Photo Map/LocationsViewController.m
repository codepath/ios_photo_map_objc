//
//  LocationsViewController.m
//  Photo Map
//
//  Created by Timothy Lee on 3/11/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationCell.h"

static NSString *const CLIENT_ID = @"CLIENT_ID GOES HERE";
static NSString *const CLIENT_SECRET = @"CLIENT_SECRET GOES HERE";

@interface LocationsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *results;

@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchBar.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    
    cell.location = self.results[indexPath.row];
    
    return cell;
}

#pragma mark - Search bar methods

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    
    [self fetchLocationsWithQuery:newText];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocationsWithQuery:searchBar.text];
}

#pragma mark - Private methods

- (void)fetchLocationsWithQuery:(NSString *)query {
    [self fetchLocationsWithQuery:query near:@"Sunnyvale,CA"];
}


- (void)fetchLocationsWithQuery:(NSString *)query near:(NSString *)near {
    NSString *baseUrlString = @"https://api.foursquare.com/v2/venues/search";
    NSString *queryString = [[NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@,CA&query=%@",
                              CLIENT_ID,
                              CLIENT_SECRET,
                              near,
                              query] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", baseUrlString, queryString]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                   options:0
                                                                                                                     error:NULL];
                                                NSLog(@"response:%@", responseDictionary);
                                                self.results = [responseDictionary valueForKeyPath:@"response.venues"];
                                                [self.tableView reloadData];
                                            }];
    
    [task resume];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
