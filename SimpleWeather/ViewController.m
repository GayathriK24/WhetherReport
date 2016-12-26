//
//  ViewController.m
//  SimpleWeather
//
//  Created by apple on 12/24/16.
//  Copyright © 2016 JPA Solutions. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "DetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Location.h"

@interface ViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableData *responseData;
    NSMutableData *DetailresponseData;
      CLLocationManager *locationManager;
    
    NSMutableArray *listingDatas;
    
    BOOL is_Celsius;
    NSURLConnection *Mainconnection;
    Location*locs;
      NSURLConnection *DetailConnection;
    NSString *data1,*data2;
}

@end


@implementation ViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setnavigation];
    self.locationTable.tableFooterView=[[UIView alloc]init];
    listingDatas=[[NSMutableArray alloc]init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    
    
        
    
    [locationManager startUpdatingLocation];
    

}
-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *status=[defaults valueForKey:@"isfetched"];
    if ([status isEqualToString:@"1"]) {
        [self FetchData];
    }
    else
    {
        NSString *urlPath=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=101675414547add523cd572155687717",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
        NSString *DetailPath=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=10&mode=json&appid=101675414547add523cd572155687717",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
        
        [self requestURL:urlPath];
        [self RequestDetails:DetailPath];
        
    }
    
    
    
    is_Celsius=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestURL:(NSString *)strURL
{
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    // Create url connection and fire request
     Mainconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [Mainconnection start];
    
}
-(void)RequestDetails:(NSString *)strURL{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    // Create url connection and fire request
    DetailConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [DetailConnection start];
    
}

#pragma GetingWeatherofParticularLocation
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Did Receive Response %@", response);
    responseData = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
  
          [responseData appendData:data];
   }
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Did Fail");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Did Finish");
    // Do something with responseData
 
    
   

    if (connection==Mainconnection) {
      data1=[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
       
    }
    else{
      data2=[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    }
    if (data1!=nil&&data2!=nil) {
        [self DatatoSave:data1 detaildata:data2];
    }
}


#pragma mark - CLLocationManagerDelegate
/*
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    NSLog(@"Latitude%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
    
    NSLog(@"Latitude%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
    if (currentLocation != nil) {
//        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        NSLog(@"Latitude%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        
        NSLog(@"Latitude%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        
        
    }
}
*/
#pragma mark - TableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return listingDatas.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        

    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationcell" forIndexPath:indexPath];
    
    
    NSString *str=[[listingDatas valueForKey:@"data"] objectAtIndex:indexPath.row];
    NSLog(@"Result%@",str);
    NSData *data = [str
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                  error:NULL];
    NSLog(@"[result class] = %@", [result class]);
    NSLog(@"result = %@", result);
cell.locationName.text=[NSString stringWithFormat:@"%@,%@",[result valueForKeyPath:@"name"],[result valueForKeyPath:@"sys.country"]];
    cell.locationWeathercondn.text=[NSString stringWithFormat:@"%@",[[result valueForKeyPath:@"weather.main"] objectAtIndex:0]];
     int temp_k=[[result valueForKeyPath:@"main.temp"] intValue];
    if (is_Celsius) {
        
        int temp_c=temp_k- 273.15;
    
      cell.locationTemperature.text=[NSString stringWithFormat:@"%d%@C",temp_c,@"\u00B0"];
        cell.locationSegment.selectedSegmentIndex=0;
    }
    else{
         int temp_f=temp_k*9/5 - 459.67;
        cell.locationTemperature.text=[NSString stringWithFormat:@"%d%@F",temp_f,@"\u00B0"];
         cell.locationSegment.selectedSegmentIndex=1;
    }
    NSString *imgstr=[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",[[result valueForKeyPath:@"weather.icon"] objectAtIndex:0]];
    NSURL *imgurl=[NSURL URLWithString:imgstr];
    NSLog(@"%@",imgurl);
    

    NSData *imgdata=[NSData dataWithContentsOfURL:imgurl];
    cell.locationStateImage.image=[UIImage imageWithData:imgdata];
    NSLog(@"%@",cell.locationStateImage.image);
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[listingDatas objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [listingDatas removeObjectAtIndex:indexPath.row];
        [self.locationTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _device=[listingDatas objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"PushDetail" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PushDetail"]) {
        DetailViewController *vc=(DetailViewController *)segue.destinationViewController;
        vc.device=_device;
    }
}
#pragma mark - Savingdata

-(void)DatatoSave:(NSString *)data detaildata:(NSString *)detail{
    
    NSLog(@"Datas%@",data);
   
    NSManagedObjectContext *context = [self managedObjectContext];
       // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
    [newDevice setValue:data forKey:@"data"];
     [newDevice setValue:detail forKey:@"detaildata"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else{
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"isfetched"];
        [defaults synchronize];
        [self FetchData];
    }
    
 }

-(void)FetchData{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Location"];

   listingDatas  = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (Location *loc in listingDatas) {
        NSLog(@"data %@",loc.data);
        NSLog(@"dataDetail %@",loc.detaildata);

    }
   
    [self.locationTable reloadData];
}
- (IBAction)ValueChagingAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.locationTable];
    NSIndexPath *indexPath = [self.locationTable indexPathForRowAtPoint:buttonPosition];
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
    switch (selectedSegment) {
        case 0:{
            is_Celsius=YES;
            // Launch reload for the two index path
            [self.locationTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case 1:{
            is_Celsius=NO;
            
            // Launch reload for the two index path
            [self.locationTable reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        default:
             break;

    
    }

}
-(void)setnavigation{
   
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(Add)];
    
    UIView *customizedTitleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,150,36)];
    customizedTitleView.center = self.navigationController.navigationBar.center;
    [customizedTitleView sizeToFit];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 150, 32)];
    
    navTitle.text = @"Weather Report";
    
    navTitle.textColor=[UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font=[UIFont boldSystemFontOfSize:17];
    [customizedTitleView addSubview:navTitle];
    
    self.navigationItem.titleView = customizedTitleView;
    
}
-(void)Add{
    
 
    
    [self performSegueWithIdentifier:@"addlocation" sender:self];
}

@end
