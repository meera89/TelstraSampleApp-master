//
//  ViewController.h
//  TelstraSampleApp
//
//  Created by Meera on 9/2/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSAAsyncServiceCall.h"
#import "TSAImageDownloader.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,asyncCallProtocol,TSAImageDownloaderDelegate>

@end

