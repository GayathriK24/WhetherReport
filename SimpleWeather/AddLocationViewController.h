//
//  AddLocationViewController.h
//  SimpleWeather
//
//  Created by ahsanmac1 on 26/12/16.
//  Copyright © 2016 JPA Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPlaceSearchTextField.h"
@interface AddLocationViewController : UIViewController<PlaceSearchTextFieldDelegate>
@property (strong, nonatomic) IBOutlet MVPlaceSearchTextField *locationText;

@end
