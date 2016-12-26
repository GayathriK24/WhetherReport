//
//  AddLocationViewController.m
//  SimpleWeather
//
//  Created by ahsanmac1 on 26/12/16.
//  Copyright © 2016 JPA Solutions. All rights reserved.
//

#import "AddLocationViewController.h"
#import <CoreData/CoreData.h>
@interface AddLocationViewController ()
{
    NSString *lattitude;
    NSString *longitude;
    NSData *responsedata;
    NSMutableData *responseData;
    NSURLConnection *Mainconnection;
    NSURLConnection *DetailConnection;
      NSString *data1,*data2;
    
}
@end

@implementation AddLocationViewController
@synthesize locationText;
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
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search Location" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.locationText.attributedPlaceholder = str;
    // _txtPlaceSearch.enabled = NO;

    
    locationText.autocorrectionType=UITextAutocorrectionTypeNo;
    self.navigationController.navigationBar.topItem.title=@"";
    locationText.hidden=NO;
    
    
    // _txtPlaceSearch.enabled = NO;
    locationText.placeSearchDelegate                 = self;
    // _txtPlaceSearch.strApiKey                           = Const_Places_Key;
  
    locationText.strApiKey                           = @"AIzaSyAGXzQ8j25x5yPH4uBDXs7aXFmWq1TRSoQ";
    locationText.superViewOfList                     = self.view;
    locationText.autoCompleteShouldHideOnSelection   = YES;
    locationText.maximumNumberOfAutoCompleteRows     = 5;
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    
    
    
    //[_txtPlaceSearch becomeFirstResponder];
    
    //Optional Properties
    
    locationText.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    
    locationText.autoCompleteBoldFontName = @"HelveticaNeue";
    
    locationText.autoCompleteTableCornerRadius=0.0;
    
    locationText.autoCompleteRowHeight=35;
    
    // _txtPlaceSearch.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    
    //    _txtPlaceSearch.autoCompleteTableCellBackgroundColor = [UIColor blackColor];
    
    locationText.autoCompleteTableBackgroundColor =[UIColor whiteColor];
    
    
    
    // _txtPlaceSearch.autoCompleteTableCellTextColor = [UIColor blackColor];
    
    locationText.autoCompleteFontSize=14;
    
    locationText.autoCompleteTableBorderWidth=0.7;
    
    locationText.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    
    locationText.autoCompleteShouldHideOnSelection=YES;
    
    locationText.autoCompleteShouldHideClosingKeyboard=YES;
    
    locationText.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
  locationText.autoCompleteTableFrame = CGRectMake((self.view.frame.size.width-locationText.frame.size.width)*0.5, locationText.frame.size.height+140.0, locationText.frame.size.width-10, 100.0);
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)placeSearchResponseForSelectedPlace:(NSMutableDictionary*)responseDict
{
    // _bkview.hidden = NO;
    lattitude=[NSString stringWithFormat:@"%@",[responseDict valueForKeyPath:@"result.geometry.location.lat"]];
    longitude=[NSString stringWithFormat:@"%@",[responseDict valueForKeyPath:@"result.geometry.location.lng"]];
   
    NSString *urlPath=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&appid=101675414547add523cd572155687717",lattitude,longitude];
    NSString *DetailPath=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=10&mode=json&appid=101675414547add523cd572155687717",lattitude,longitude];
    
    [self requestURL:urlPath];
    [self RequestDetails:DetailPath];
    
    }
-(void)requestURL:(NSString *)strURL
{
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    // Create url connection and fire request
    Mainconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [Mainconnection start];
    
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
       
    }
    
}


-(void)RequestDetails:(NSString *)strURL{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    // Create url connection and fire request
    DetailConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [DetailConnection start];
    
}


-(void)placeSearchWillShowResult{
    
    
    
}

-(void)placeSearchWillHideResult{
    
    
    
}

-(void)placeSearchResultCell:(UITableViewCell *)cell withPlaceObject:(PlaceObject *)placeObject atIndex:(NSInteger)index{
    
    if(index%2==0){
        
        NSLog(@"if");
        
        
        
    }else{
        
        NSLog(@"else");
        
    }
    
}

@end
