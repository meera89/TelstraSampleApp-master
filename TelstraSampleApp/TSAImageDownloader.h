

#import <Foundation/Foundation.h>
#import "TSAAsyncServiceCall.h"
#import <UIKit/UIKit.h>


@protocol TSAImageDownloaderDelegate <NSObject>

@optional


-(void)returnSuccess:(NSIndexPath *)key andActivityLoad:(id)activityLoad;
@end
@interface TSAImageDownloader : NSObject

{
    TSAAsyncServiceCall *async;
}
@property(strong,nonatomic)id imgLoad;
@property(strong,nonatomic) UIActivityIndicatorView *load;
@property(strong,nonatomic)NSString *serviceURL;
@property(strong,nonatomic)NSIndexPath *key;
@property(strong,nonatomic)NSString *imageKey;


@property(weak,nonatomic)id<TSAImageDownloaderDelegate> delegate;
@property (nonatomic, strong)   NSURLConnection *imageConnection;

- (void)start;
@end
