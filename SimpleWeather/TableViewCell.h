//
//  TableViewCell.h
//  SimpleWeather
//
//  Created by apple on 12/24/16.
//  Copyright © 2016 JPA Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LocationTemp_F;
@property (weak, nonatomic) IBOutlet UISegmentedControl *locationSegment;
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *locationWeathercondn;
@property (weak, nonatomic) IBOutlet UIImageView *locationStateImage;
@property (weak, nonatomic) IBOutlet UILabel *locationTemperature;
@property (weak, nonatomic) IBOutlet UILabel *locationDetails;

@end
