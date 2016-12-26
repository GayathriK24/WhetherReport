//
//  ViewController.h
//  SimpleWeather
//
//  Created by apple on 12/24/16.
//  Copyright © 2016 JPA Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<CoreData/CoreData.h>
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *locationTable;

@property (strong) NSManagedObject *device;
- (IBAction)ValueChagingAction:(id)sender;

@end

