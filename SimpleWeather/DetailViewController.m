//
//  DetailViewController.m
//  SimpleWeather
//
//  Created by ahsanmac1 on 26/12/16.
//  Copyright © 2016 JPA Solutions. All rights reserved.
//

#import "DetailViewController.h"
#import "CollectionViewCell.h"
@interface DetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _listingData=[[NSMutableArray alloc]init];
  
    // Do any additional setup after loading the view.
    
    
    NSString *str=[_device valueForKey:@"detaildata"] ;
    NSLog(@"Result%@",str);
    NSData *data = [str
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                  error:NULL];
    NSLog(@"[result class] = %@", [result class]);
    NSLog(@"result = %@", result);
    
    
    
    _listingData=[result valueForKeyPath:@"list"];
    
    NSString *str1=[_device valueForKey:@"data"] ;
    NSLog(@"Result%@",str);
    NSData *detail = [str1
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    id detailresult = [NSJSONSerialization JSONObjectWithData:detail
                                                      options:NSJSONReadingAllowFragments
                                                        error:NULL];
    NSLog(@"[result class] = %@", [result class]);
    NSLog(@"result = %@", result);
    _titleLocation.text=[NSString stringWithFormat:@"%@,%@",[detailresult valueForKeyPath:@"name"],[detailresult valueForKeyPath:@"sys.country"]];
    _titleSate.text=[NSString stringWithFormat:@"%@",[[detailresult valueForKeyPath:@"weather.main"] objectAtIndex:0]];
    int temp_k=[[detailresult valueForKeyPath:@"main.temp"] intValue];
    int temp_c=temp_k- 273.15;
    
    _titledetail.text=[NSString stringWithFormat:@"%d%@C",temp_c,@"\u00B0"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _listingData.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell;
    
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"detailcell" forIndexPath:indexPath];

    
    NSDictionary *result=[_listingData objectAtIndex:indexPath.row];
   
 
  
    cell.DetailTemptext.text=[NSString stringWithFormat:@"%@%@",[result valueForKeyPath:@"deg"],@"\u00B0"];
    
    NSString *imgstr=[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",[[result valueForKeyPath:@"weather.icon"] objectAtIndex:0]];
    NSURL *imgurl=[NSURL URLWithString:imgstr];
    NSLog(@"%@",imgurl);
    
    //http://openweathermap.org/img/w/10d.png
    NSData *imgdata=[NSData dataWithContentsOfURL:imgurl];
  
    cell.DetailImage.image=[UIImage imageWithData:imgdata];
    
    
   
        NSDate *now = [NSDate date];
        NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*indexPath.row];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"EEEE"];
        NSLog(@"The day of the week: %@", [dateFormatter stringFromDate:newDate1]);
       cell.detaildayText.text=[dateFormatter stringFromDate:newDate1];
    
     return cell;
    
}
-(void)setNavigation
{
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(popToViewController:animated:)];
    
    UIView *customizedTitleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,150,36)];
    customizedTitleView.center = self.navigationController.navigationBar.center;
    [customizedTitleView sizeToFit];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 150, 32)];
    
    navTitle.text = @"Detailed Report";
    
    navTitle.textColor=[UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.font=[UIFont boldSystemFontOfSize:17];
    [customizedTitleView addSubview:navTitle];
    
    self.navigationItem.titleView = customizedTitleView;
    
}
@end
