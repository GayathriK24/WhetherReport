//
//  Location+CoreDataProperties.h
//  SimpleWeather
//
//  Created by ahsanmac1 on 26/12/16.
//  Copyright © 2016 JPA Solutions. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *data;
@property (nullable, nonatomic, retain) NSString *detaildata;

@end

NS_ASSUME_NONNULL_END
