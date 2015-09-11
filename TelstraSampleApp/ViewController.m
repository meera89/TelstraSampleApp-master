//
//  ViewController.m
//  TelstraSampleApp
//
//  Created by Meera on 9/2/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "ViewController.h"
#import "TSACustomCell.h"
#import "TSAConstants.h"
#import "TSAFacts.h"
#import "TSAFactDetails.h"
#import "TSAImageDownloader.h"
@interface ViewController ()<UIAlertViewDelegate>
{
    UITableView *factsTableView;
    UIActivityIndicatorView *spinnerActivityIndicator;
    UILabel *titleLabel;
    UIButton *syncButton;
    TSAAsyncServiceCall *async;
    TSAFacts *factSharedManager;
    TSAFactDetails *factDetailRow;
}
@property(nonatomic)BOOL waitingForResponse;
@property(nonatomic,strong)NSMutableArray *connections;

@end

@implementation ViewController
@synthesize connections;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    factSharedManager=[TSAFacts sharedManager];
    async=[[TSAAsyncServiceCall alloc]init];
    async.delegate=self;
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-kTitleWidth/2, 10, kTitleWidth, kTitleHeight)];
    [self.view addSubview:titleLabel];
    syncButton=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-kSyncWidth, 15, kSyncWidth, kSyncHeight)];
    
    [self.view addSubview:syncButton];
    self.waitingForResponse = NO;
    [self refreshDataButton];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*----------------------------------------------------------------------------------
 Method Name: initializeSpinner
 Parameters:nil
 Descriptions:
 This method will initialize the spinner on the master data download section
 return type: nil
 ----------------------------------------------------------------------------------*/

-(void)initializeSpinner
{
    spinnerActivityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    spinnerActivityIndicator.color=[UIColor blackColor];
    CGRect bounds = [UIScreen mainScreen].bounds;
    spinnerActivityIndicator.center=CGPointMake(bounds.size.width/2, bounds.size.height/2);
}
/*----------------------------------------------------------------------------------
 Method Name: startSpinner
 Parameters:nil
 Descriptions:
 This method will add the spinner to the current view and start the animation
 return type: nil
 ----------------------------------------------------------------------------------*/

-(void)startSpinner
{
    [self.view addSubview:spinnerActivityIndicator];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [spinnerActivityIndicator bringSubviewToFront:self.view];
    [spinnerActivityIndicator startAnimating];
    
}
/*----------------------------------------------------------------------------------
 Method Name: stopSpinner
 Parameters:nil
 Descriptions:
 This method will stop the animation of the spinner and remove it from super view
 return type: nil
 ----------------------------------------------------------------------------------*/

-(void)stopSpinner
{
    [spinnerActivityIndicator stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [spinnerActivityIndicator removeFromSuperview];
}

/*----------------------------------------------------------------------------------
 Method Name: reloadBrandsOnScroll
 Parameters:nil
 Descriptions:
 This method reloads the visible cells once the scrolling is done
 return type: nil
 ----------------------------------------------------------------------------------*/

-(void)reloadBrandsOnScroll
{
    NSArray *visiblePaths = [factsTableView indexPathsForVisibleRows];
    
    [factsTableView reloadRowsAtIndexPaths:visiblePaths withRowAnimation:UITableViewRowAnimationNone];
    
}
# pragma marks -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadBrandsOnScroll];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self reloadBrandsOnScroll];
}
/*----------------------------------------------------------------------------------
 Method Name: clearConnections
 Parameters:nil
 Descriptions:
 This method will remove all the connections going on when the current view disappears.
 return type: nil
 ----------------------------------------------------------------------------------*/

-(void)clearConnections
{
    
    for(NSURLConnection *connection in self.connections)
        [connection cancel];
    [self.connections removeAllObjects];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self clearConnections];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [factSharedManager.factsCollection count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HistoryCell";
    
    TSACustomCell *cell = (TSACustomCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell ==nil)
    {
        cell=[[TSACustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
   
    [factsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    if (indexPath.row % 2 ==0) {
        
        [cell setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0]];
    }
    else{
        
        [cell setBackgroundColor:[UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:1.0]];

    }

    //data is added to the custom cell
    factDetailRow=[[TSAFactDetails alloc]init];
    factDetailRow=[factSharedManager.factsCollection objectAtIndex:indexPath.row];
    
    cell.descriptionTitle.text =factDetailRow.factsTitle;
    cell.descriptionText.text=factDetailRow.factsDescritpion;
    cell.descriptionText.font=factDetailRow.factsDescriptionLblFont;
    cell.descriptionText.frame=CGRectMake(cell.descriptionTitle.frame.origin.x, kTextYAxis, [UIScreen mainScreen].bounds.size.width-(cell.descriptionImage.frame.size.width+kImageLeftPadding), ktableViewCellPadding);
    cell.descriptionText.lineBreakMode = NSLineBreakByWordWrapping;
    cell.descriptionText.numberOfLines = 0;
    
    cell.descriptionImage.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-kImagePadding ,  cell.descriptionTitle.frame.size.height+kDescriptionIndicatorHeight, kDescriptionImageHeight, kDescriptionImageHeight);
    cell.indicatorView.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-kImagePadding ,  cell.descriptionTitle.frame.size.height+kDescriptionIndicatorHeight, kDescriptionImageHeight, kDescriptionImageHeight);

    cell.descriptionImage.image=nil;
    NSIndexPath *cellIndex=indexPath;
    if(factDetailRow.factsImage ==nil){
        
        [cell.indicatorView startAnimating];
        [cell.indicatorView setHidden:NO];

        //code for lazy loading of the image
        if (factsTableView.dragging == NO && factsTableView.decelerating == NO )
        {
            TSAImageDownloader *newcall=[[TSAImageDownloader alloc]init];
                      newcall.serviceURL=factDetailRow.factsImageUrl;
            newcall.imgLoad=cell.descriptionImage;
            newcall.delegate=self;
            newcall.load=cell.indicatorView;
            newcall.key=cellIndex;
            [newcall start];
            [self.connections addObject:newcall.imageConnection];
        }
    }
    
    else{
        UIImage *img =factDetailRow.factsImage;
        cell.descriptionImage.image=nil;
        [cell.descriptionImage setImage:img];
        
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    factDetailRow=[factSharedManager.factsCollection objectAtIndex:indexPath.row];
    NSString *content = factDetailRow.factsDescritpion;
    CGSize sizeForHeight = [ViewController findSizeOfString:content andFont:factDetailRow.factsDescriptionLblFont andWidth:tableView.frame.size.width];
    
    
    if(sizeForHeight.height+ktableViewCellPadding>kDefaultCellHeight)
        return sizeForHeight.height+ktableViewCellPadding;
    else
        return ktableViewCellPadding;
    
}


/*----------------------------------------------------------------------------------
 Method Name: setUpUI
 Parameters: NSArray
 Descriptions:
 This method is to set up the UI after the data is recieved from Master data download
 return type: nil
 ----------------------------------------------------------------------------------*/
-(void)setUpUI :(NSArray *)parsedResponse
{
    self.waitingForResponse = false;
    CGRect frame = [UIScreen mainScreen].bounds;
    
    factsTableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, titleLabel.frame.size.height+titleLabel.frame.origin.y, frame.size.width, frame.size.height-kTitleHeight) style:UITableViewStylePlain];
    [syncButton setBackgroundImage:[UIImage imageNamed:@"Sync"] forState:UIControlStateNormal];
    [syncButton addTarget:self action:@selector(refreshDataButton) forControlEvents:UIControlEventTouchUpInside];
    [syncButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:factsTableView];
    
    factsTableView.delegate = self;
    factsTableView.dataSource = self;
    
    titleLabel.text=[parsedResponse valueForKey:@"title"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
#pragma mark - async delegate method
-(void)receiveSuccessResponse:(NSArray*)parsedResponse
{
    [self stopSpinner];
    // If the response is not empty will set up the UI and table view is loaded .
    [factSharedManager insertFactsCollection:parsedResponse];
    [self setUpUI:parsedResponse];

    [factsTableView reloadData];
    
    
}
-(void)failedStatus:(NSError *)error
{
    [self stopSpinner];
    NSString *errorDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
    UIAlertView *alert;
    if([factSharedManager.factsCollection count]>0){
    alert=[[UIAlertView alloc]initWithTitle:@"Telstra" message:[NSString stringWithFormat:@" %@  please try later",errorDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    else {
        alert=[[UIAlertView alloc]initWithTitle:@"Telstra" message:[NSString stringWithFormat:@" %@  please Launch the application as the data was not downloaded",errorDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    alert.delegate=self;
    [alert show];
}
#pragma marks-UIViewControllerRotation

- (BOOL)shouldAutorotate {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait) {
        CGRect frame = [UIScreen mainScreen].bounds;

        CGRect tableViewFrame = CGRectMake(frame.origin.x, titleLabel.frame.size.height+titleLabel.frame.origin.y, frame.size.width, frame.size.height-kTitleHeight);
        factsTableView.frame = tableViewFrame;
        titleLabel.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-kTitleWidth/2, 10, kTitleWidth, kTitleHeight) ;
        syncButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-40, 15, kSyncWidth, kSyncHeight);

    }
    else{
        CGRect frame = [UIScreen mainScreen].bounds;

        CGRect tableViewFrame = CGRectMake(frame.origin.x, titleLabel.frame.size.height+titleLabel.frame.origin.y, frame.size.width, self.view.frame.size.height-kTitleHeight);
        factsTableView.frame = tableViewFrame;
        titleLabel.frame=CGRectMake([UIScreen mainScreen].bounds.size.width/2-kTitleWidth/2, 10, kTitleWidth, kTitleHeight) ;
        syncButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-kSyncWidth, 15, kSyncWidth, kSyncHeight);


    }
    [factsTableView reloadData];

    return YES;
}
-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    if(self.waitingForResponse) {
        
        [self stopSpinner];
        spinnerActivityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        spinnerActivityIndicator.color=[UIColor blackColor];
        spinnerActivityIndicator.center=CGPointMake(size.width/2, size.height/2);
        [self startSpinner];
    }
}


#pragma marks - delegate method for ImageDownloader
-(void)returnSuccess:(NSIndexPath *)key andActivityLoad:(id)activityLoad;
{
    
    TSACustomCell *cell=(TSACustomCell*)[factsTableView cellForRowAtIndexPath:key];
    TSAFactDetails *factDetail=[factSharedManager.factsCollection objectAtIndex:key.row
                                ];
    cell.descriptionImage.image=nil;
    cell.descriptionImage.image=factDetail.factsImage;
    [activityLoad stopAnimating];
    [activityLoad setHidden:YES];
    
    
    
}

/*----------------------------------------------------------------------------------
 Method Name: refreshDataButton
 Parameters: nil
 Descriptions:
 This method is to start the master data download
 return type: nil
 ----------------------------------------------------------------------------------*/
-(void)refreshDataButton{
    
    [self initializeSpinner];
    [self startSpinner];
    
    self.waitingForResponse = YES;
    NSURL *url= [NSURL URLWithString:kMasterDataDownloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    [async callRequestBlock:request];
   
    
}
#pragma marks - UIAlertView Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
/*----------------------------------------------------------------------------------
 Method Name: findSizeOfString
 Parameters: NSString,UIView,CGFloat
 Descriptions:
 This method is to find the size of the string to set of the width of the label
 return type: CGSize
 ----------------------------------------------------------------------------------*/

+ (CGSize)findSizeOfString:(NSString *)string andFont:(UIFont *)descriptionLabelFont andWidth:(CGFloat)width {
    CGSize labelSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :descriptionLabelFont } context:nil].size;
    return labelSize;
}
@end
