//
//  DNHotViewController.m
//  DailyNew
//
//  Created by ZongZiWang on 12-10-13.
//  Copyright (c) 2012年 3DayStartup. All rights reserved.
//

#import "DNHotViewController.h"
#import "Coffeepot.h"
#import "ActionSheetStringPicker.h"
#import "DNEventsData.h"

@interface DNHotViewController () <iCarouselDelegate>

@property (strong, nonatomic) NSMutableArray *hotEvents;
@property (strong, nonatomic) NSMutableArray *universities;

@end

@implementation DNHotViewController

- (NSMutableArray *)hotEvents
{
	if (_hotEvents == nil) {
		_hotEvents = [[DNEventsData shared] hotEvents];
	}
	return _hotEvents;
}

- (NSMutableArray *)universities
{
	if (_universities == nil) {
		_universities = [[DNEventsData shared] universities];
	}
	return _universities;
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
	
	[self.carousel setScrollToItemBoundary:NO];
	[self carouselCurrentItemIndexDidChange:self.carousel];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSNumber *carouselType = [[NSUserDefaults standardUserDefaults] objectForKey:@"display_type"];
	if (!carouselType) self.carousel.type = iCarouselTypeCoverFlow2;
	else self.carousel.type = [carouselType integerValue];
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
    return [self.hotEvents count];
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
	NSInteger index = carousel.currentItemIndex;
	self.titleLabel.text = [[self.hotEvents objectAtIndex:index] objectForKey:@"title"];
	self.timeLabel.text = [[self.hotEvents objectAtIndex:index] objectForKey:@"time"];
	self.locationLabel.text = [[self.hotEvents objectAtIndex:index] objectForKey:@"location"];
	self.likeLabel.text = [NSString stringWithFormat:@"%@", [[self.hotEvents objectAtIndex:index] objectForKey:@"like"]];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
	[self performSegueWithIdentifier:@"EventDetail" sender:self];
}

#pragma mark - IBAction

- (IBAction)likeEvent:(id)sender {
	NSInteger index = self.carousel.currentItemIndex;
	[[self.hotEvents objectAtIndex:index] setObject:[NSNumber numberWithInteger:[[[self.hotEvents objectAtIndex:index] objectForKey:@"like"] integerValue] + 1] forKey:@"like"];
	
	self.likeLabel.text = [NSString stringWithFormat:@"%@", [[self.hotEvents objectAtIndex:index] objectForKey:@"like"]];
}

- (IBAction)changeUniversity:(id)sender {
	
	NSMutableArray *universityNames = [@[] mutableCopy];
	for (NSDictionary *university in self.universities) {
		[universityNames addObject:[university objectForKey:@"name"]];
	}
	
	ActionSheetStringPicker *universityPicker =
	[[ActionSheetStringPicker alloc] initWithTitle:@"选择学校"
											  rows:universityNames
								  initialSelection:[[DNEventsData shared].universities indexOfObject:[[DNEventsData shared] university]]
										 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
											 [[DNEventsData shared] setUniversity:[self.universities objectAtIndex:selectedIndex]];
											 self.navigationItem.title = [NSString stringWithFormat:@"一周热点@%@", selectedValue];
										 }
									   cancelBlock:^(ActionSheetStringPicker *picker) {
										 
									   }
											origin:sender];
	
	[universityPicker showActionSheetPicker];
}

@end
