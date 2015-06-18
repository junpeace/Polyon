//
//  factoryView.m
//  polyon
//
//  Created by Jun on 15/5/26.
//  Copyright (c) 2015年 jun. All rights reserved.
//

#import "factoryView.h"

@interface factoryView ()

@end

@implementation factoryView

@synthesize fs, imgFactory, imgFactoryHeightConstraint, lblDescription;
@synthesize factoryDetailViewHeightConstraint;
@synthesize lbl;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setUpView];
}

-(void) setUpView
{
    self.navigationItem.title = fs.title;
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    [imgFactory setImageWithURL: [NSURL URLWithString: fs.imageURL] placeholderImage:nil];
    
    imgFactoryHeightConstraint.constant = imgFactory.image.size.height;
        
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[fs.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [lblDescription setAttributedText: attrStr];
    [lblDescription setFont: [UIFont fontWithName: @"Century Gothic" size:15]];
    [lblDescription setAlpha: 0];
    
    CGFloat maxLabelWidth = lblDescription.frame.size.width;
    CGSize neededSize = [lblDescription sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    
    if((imgFactory.image.size.height + neededSize.height) > factoryDetailViewHeightConstraint.constant)
    {
        factoryDetailViewHeightConstraint.constant = imgFactory.image.size.height + neededSize.height + 20;
    }
    
    lbl = [[RTLabel alloc] init];
    
    // instead of using uilabel to show the text
    // use the label to get the height needed
    // then hide the label
    // use RTLabel to show the html tagged text
    // RTLabel - Able to show <b> / <em> tag with no problem after we changed font type
    
    [lbl setFrame: CGRectMake(lblDescription.frame.origin.x, imgFactory.image.size.height + 7, neededSize.width, neededSize.height)];
    [lbl setFont: [UIFont fontWithName: @"Century Gothic" size: 15]];
    [lbl setLineSpacing: 1];
    [lbl setText: fs.desc];
    
    [self.scrollView addSubview: lbl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
