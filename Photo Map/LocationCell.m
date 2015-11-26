//
//  LocationCell.m
//  Photo Map
//
//  Created by Timothy Lee on 3/11/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

#import "LocationCell.h"
#import "UIImageView+AFNetworking.h"

@interface LocationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation LocationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLocation:(NSDictionary *)location {
    _location = location;
    
    self.nameLabel.text = location[@"name"];
    self.addressLabel.text = [location valueForKeyPath:@"location.address"];
    
    NSArray *categories = location[@"categories"];
    if (categories.count > 0) {
        NSDictionary *category = categories[0];
        NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
        NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
        
        NSString *url = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        [self.categoryImageView setImageWithURL:[NSURL URLWithString:url]];
    }
}

@end
