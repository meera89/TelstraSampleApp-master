

#import "TSAImageDownloader.h"
#import "TSAFacts.h"

@interface TSAImageDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;

@end


@implementation TSAImageDownloader
@synthesize imgLoad,serviceURL,key,load,delegate,imageKey;
@synthesize imageConnection;

/*----------------------------------------------------------------------------------
 Method Name: start
 Parameters:nil
 Descriptions:
 This method start the async call for downloading the image . Once the image is downloaded
 it is set to the imageview object in imgLoad.
 
 return type: nil
 ----------------------------------------------------------------------------------*/
- (void)start
{
    async=[[TSAAsyncServiceCall alloc]init];
    
    NSURL *url=[[NSURL alloc]initWithString:self.serviceURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    self.imageConnection=connection;
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
    
    
}

#pragma marks -delegate methods Nsurlconnection

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
   
    
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return nil;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.activeDownload = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *errorDetails=[error.userInfo objectForKey:@"NSLocalizedDescription"];
    NSData* data = [errorDetails dataUsingEncoding:NSUTF8StringEncoding];
    [self serviceLoaded:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self serviceLoaded:self.activeDownload];

}
/*----------------------------------------------------------------------------------
 Method Name: serviceLoaded
 Parameters: NSData
 Descriptions:
 This method will recieve the image nsdata and will convert to UIImage . The UIImage
 is in turn set to the UIImageView object in img.Load .
 return type: nil
 ----------------------------------------------------------------------------------*/
-(void)serviceLoaded:(NSData*)data
{
        //add image into FactsDetail obejct 
        TSAFacts *factObj=[TSAFacts sharedManager];
        [factObj setImageToCell:data andUIImageView:self.imgLoad andKey:self.key];
        [delegate returnSuccess:self.key andActivityLoad:self.load];
    
}


@end

