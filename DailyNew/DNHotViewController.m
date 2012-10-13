//
//  DNHotViewController.m
//  DailyNew
//
//  Created by ZongZiWang on 12-10-13.
//  Copyright (c) 2012年 3DayStartup. All rights reserved.
//

#import "DNHotViewController.h"
#import "Coffeepot.h"

@interface DNHotViewController () <iCarouselDelegate>

@property (strong, nonatomic) NSMutableArray *hotEventInfos;

@end

@implementation DNHotViewController

- (NSMutableArray *)hotEventInfos
{
	if (_hotEventInfos == nil) {
		_hotEventInfos = [@[@{@"theme" : @"三日初创", @"time" : @"这两天"}, @{@"theme" : @"测试数据2", @"time" : @"这三天"}, @{@"theme" : @"啦啦啦啦", @"time" : @"噗噗"}, @{@"theme" : @"试试看", @"time" : @"嘿嘿"}, @{@"theme" : @"牛", @"time" : @"一二三"}, @{@"theme" : @"三日初创", @"time" : @"这两天"}, @{@"theme" : @"测试数据2", @"time" : @"这三天"}, @{@"theme" : @"啦啦啦啦", @"time" : @"噗噗"}, @{@"theme" : @"试试看", @"time" : @"嘿嘿"}, @{@"theme" : @"牛", @"time" : @"一二三"}] mutableCopy];
	}
	return _hotEventInfos;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.hotEvents.type = iCarouselTypeTimeMachine;
	self.themeLabel.text = [[self.hotEventInfos objectAtIndex:0] objectForKey:@"theme"];
	self.timeLabel.text = [[self.hotEventInfos objectAtIndex:0] objectForKey:@"time"];
//	[[Coffeepot shared] requestWithMethodPath:@"university/" params:nil requestMethod:@"GET" success:^(CPRequest *request, id collection) {
//		;
//	} error:^(CPRequest *request, NSError *error) {
//		;
//	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.hotEventInfos count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
//		((UIImageView *)view).image = [[self.hotEventInfos objectAtIndex:index] objectForKey:@"poster"];
        ((UIImageView *)view).image = [UIImage imageNamed:@"page"];
//		view.backgroundColor = [UIColor yellowColor];
		view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [NSString stringWithFormat:@"%d", index];
    
    return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
	NSLog(@"%d", carousel.currentItemIndex);
	NSInteger index = carousel.currentItemIndex;
	self.themeLabel.text = [[self.hotEventInfos objectAtIndex:index] objectForKey:@"theme"];
	self.timeLabel.text = [[self.hotEventInfos objectAtIndex:index] objectForKey:@"time"];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
	NSLog(@"%d", carousel.currentItemIndex);
}

@end
