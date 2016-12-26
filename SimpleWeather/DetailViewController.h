//
//  DetailViewController.h
//  SimpleWeather
//
//  Created by ahsanmac1 on 26/12/16.
//  Copyright © 2016 JPA Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CoreData/CoreData.h>
@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *detailCollectionView;
@property (strong) NSManagedObject *device;
@property (strong, nonatomic) IBOutlet UILabel *titleLocation;
@property (strong, nonatomic) IBOutlet UILabel *titleSate;
@property (strong, nonatomic) IBOutlet UILabel *titledetail;
@property (strong, nonatomic) NSMutableArray *listingData;
@end
