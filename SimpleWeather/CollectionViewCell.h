//
//  CollectionViewCell.h
//  SimpleWeather
//
//  Created by ahsanmac1 on 26/12/16.
//  Copyright © 2016 JPA Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *detaildayText;

@property (strong, nonatomic) IBOutlet UILabel *DetailTemptext;
@property (strong, nonatomic) IBOutlet UIImageView *DetailImage;

@end
