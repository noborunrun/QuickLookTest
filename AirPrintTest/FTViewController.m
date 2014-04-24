//
//  FTViewController.m
//  AirPrintTest
//
//  Created by NineDrafts Inc. on 4/24/14.
//  Copyright (c) 2014 noboru YANAGISAWA. All rights reserved.
//

#import "FTViewController.h"

@interface FTViewController ()
{
    NSArray *previewData;
}

- (IBAction)createPDF:(id)sender;
@end

@implementation FTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PDF
-(NSMutableData *)createPDFDatafromUIView:(UIView*)aView
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    return pdfData;
}


-(NSString*)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [self createPDFDatafromUIView:aView];
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    return documentDirectoryFilename;
}

- (IBAction)createPDF:(id)sender {
    NSString *fileName = [self createPDFfromUIView:self.view saveToDocumentsWithFileName:@"a.pdf"];
    previewData = @[@"a.pdf"];
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
//    previewController.currentPreviewItemIndex = 0;

    [self presentViewController:previewController animated:YES completion:nil];
}

#pragma mark - QuickLookPreviewControllerDatasource
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller;
{
    return previewData.count;
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index
{
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];

    NSString *fileNamePath = [NSString stringWithFormat:@"%@/%@",documentDirectory,previewData[0]];
    return [NSURL fileURLWithPath:fileNamePath];
}

#pragma mark - QuickLookPreviewControllerDelegate
//- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item
//{
//    
//}
@end
