//
//  ViewController.m
//  BlueLibrary
//
//  Created by Eli Ganem on 31/7/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//
//  Modified by Luke Schoen in 2014

#import "ViewController.h"

#import "LibraryAPI.h"                  // API (Facade Design Pattern)
#import "Album+TableRepresentation.h"   // Category (Decorator Design Pattern)

#import "HorizontalScroller.h"

//
//  delegate (ViewController) promises to fulfil the method contract in conformance to protocols
//  shown to satisfy UITableView that required methods are implemented by its delegate
//

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, HorizontalScrollerDelegate> {
    
    //
    //  private variables in class extension
    //
    
    UITableView *dataTable;
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    int currentAlbumIndex;
    HorizontalScroller *scroller;
}

// private properties not required by other classes
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation ViewController

@synthesize coverImage;
@synthesize indicator;

- (void)viewWillAppear:(BOOL)animated
{
    self.coverImage.backgroundColor = [UIColor redColor];
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.indicator startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //
    //  1 - update UI
    //
    
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
    
    
    //
    //  2 - predefine album index
    //
    
    currentAlbumIndex = 0;
    
    //
    //  3 - read data indirectly
    //
    
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    
    //
    //  4 - create UITableView to present album data.
    //      declare ViewController as delegate & data source of UITableView
    //
    
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    //
    //  5 - load current album at app launch
    //
    //  note: we have predefined value of currentAlbumIndex to 0 already
    //
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

- (void)showDataForAlbumAtIndex:(int)albumIndex
{
    //
    //  defensive code: ensure requested index is lower than amount of albums
    //
    
    if (albumIndex < allAlbums.count)
    {
        //
        //  fetch album from array of albums
        //
        
        Album *album = allAlbums[albumIndex];
        
        //
        //  save album data. present later in tableview
        //
        
        currentAlbumData = [album tr_tableRepresentation];
    }
    else
    {
        currentAlbumData = nil;
    }
    
    //
    //  refresh tableview with data obtained. causes UITableView to ask
    //  delegate how to present the new data (sections, rows, cells)
    //
    
    [dataTable reloadData];
}

# pragma mark - HorizontalScrollerDelegate methods

//
//  set variable that stores current album.
//  call showDataForAlbumAtIndex: method to display data for new album
//

- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index
{
    currentAlbumIndex = index;
    [self showDataForAlbumAtIndex:index];
}

# pragma mark - Table View Delegate & Data Source (Conformance to Required Methods of Protocol)

//
//  returns number of rows to display in the table view
//  matches the number of titles in the data structure
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentAlbumData[@"titles"] count];
}

//
//  creates and returns a cell with title and associated value.
//

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
