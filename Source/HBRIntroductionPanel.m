//
//  MYIntroductionPanel.m
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "HBRIntroductionPanel.h"

@interface HBRIntroductionPanel ()

@property (nonatomic, retain) UIView *panelHeaderView;
@property (nonatomic, retain) NSString *panelTitle;
@property (nonatomic, retain) NSString *panelDescription;
@property (nonatomic, retain) UILabel *panelTitleLabel;
@property (nonatomic, retain) UILabel *panelDescriptionLabel;
@property (nonatomic, retain) UIView *panelSeparatorLine;
@property (nonatomic, retain) UIImageView *panelImageView;

@property (nonatomic, assign) BOOL isCustomPanel;
@property (nonatomic, assign) BOOL hasCustomAnimation;

@end

@implementation HBRIntroductionPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeConstants];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description{
    return [self initWithFrame:frame title: title description: description header: nil];
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description header:(UIView *)headerView{
    return [self initWithFrame: frame title: title description: description image: nil header: headerView];
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image{
    return [self initWithFrame: frame title: title description: description image: image header: nil];
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image header:(UIView *)headerView{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeConstants];
        
        self.panelHeaderView = headerView;
        self.panelTitle = title;
        self.panelDescription = description;
        self.panelImageView = [[UIImageView alloc] initWithImage:image];
        [self buildPanelWithFrame:frame];
    }
    return self;
}

+ (NSArray *)allPanelsWithFrame:(CGRect)frame inNib:(NSString *)nibName {
    NSMutableArray *panels = [NSMutableArray array];
    NSArray *items = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (HBRIntroductionPanel *view in items) {
        if ([view isKindOfClass:[HBRIntroductionPanel class]]) {
            view.frame = frame;
            view.isCustomPanel = YES;
            view.hasCustomAnimation = NO;
            [panels addObject:view];
        }
    }
    return panels;
}

-(id)initWithFrame:(CGRect)frame nibNamed:(NSString *)nibName{
    self = [super init];
    if (self) {
        // Initialization code
        self = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][0];
        self.frame = frame;
        self.isCustomPanel = YES;
        self.hasCustomAnimation = NO;
    }
    return self;
}

-(void)initializeConstants{
    kTitleFont = [UIFont boldSystemFontOfSize:21];
    kTitleTextColor = [UIColor whiteColor];
    kDescriptionFont = [UIFont systemFontOfSize:14];
    kDescriptionTextColor = [UIColor whiteColor];
    kSeparatorLineColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)buildPanelWithFrame:(CGRect)frame{
    CGFloat panelTitleHeight = 0;
    CGFloat panelDescriptionHeight = 0;
    
    CGFloat runningYOffset = kTopPadding;
    
    //Process panel header view, if it exists
    if (self.panelHeaderView) {
        self.panelHeaderView.frame = CGRectMake((frame.size.width - self.panelHeaderView.frame.size.width)/2, runningYOffset, self.panelHeaderView.frame.size.width, self.panelHeaderView.frame.size.height);
        [self addSubview:self.panelHeaderView];
        
        runningYOffset += self.panelHeaderView.frame.size.height + kHeaderTitlePadding;
    }
    
    //Calculate title and description heights
    if ([HBRIntroductionPanel runningiOS7]) {
        //Calculate Title Height
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:kTitleFont forKey: NSFontAttributeName];
        panelTitleHeight = [self.panelTitle boundingRectWithSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size.height;
        panelTitleHeight = ceilf(panelTitleHeight);
        
        //Calculate Description Height
        NSDictionary *descriptionAttributes = [NSDictionary dictionaryWithObject:kDescriptionFont forKey: NSFontAttributeName];
        panelDescriptionHeight = [self.panelDescription boundingRectWithSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:descriptionAttributes context:nil].size.height;
        panelDescriptionHeight = ceilf(panelDescriptionHeight);
    } else {
        panelTitleHeight = [self.panelTitle boundingRectWithSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kTitleFont} context:nil].size.height;
        
        panelDescriptionHeight = [self.panelDescription boundingRectWithSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kDescriptionFont} context:nil].size.height;
    }
    
    //Create title label
    self.panelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftRightMargins, runningYOffset, frame.size.width - 2*kLeftRightMargins, panelTitleHeight)];
    self.panelTitleLabel.numberOfLines = 0;
    self.panelTitleLabel.text = self.panelTitle;
    self.panelTitleLabel.font = kTitleFont;
    self.panelTitleLabel.textColor = kTitleTextColor;
    self.panelTitleLabel.alpha = 0;
    self.panelTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.panelTitleLabel];
    runningYOffset += panelTitleHeight + kTitleDescriptionPadding;
    
    
    //Add small line in between title and description
    self.panelSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(kLeftRightMargins, runningYOffset - 0.5*kTitleDescriptionPadding, frame.size.width - 2*kLeftRightMargins, 1)];
    self.panelSeparatorLine.backgroundColor = kSeparatorLineColor;
     [self addSubview:self.panelSeparatorLine];
    
    //Create description label
    self.panelDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftRightMargins, runningYOffset, frame.size.width - 2*kLeftRightMargins, panelDescriptionHeight)];
    self.panelDescriptionLabel.numberOfLines = 0;
    self.panelDescriptionLabel.text = self.panelDescription;
    self.panelDescriptionLabel.font = kDescriptionFont;
    self.panelDescriptionLabel.textColor = kDescriptionTextColor;
    self.panelDescriptionLabel.alpha = 0;
    self.panelDescriptionLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.panelDescriptionLabel];
    
    runningYOffset += panelDescriptionHeight + kDescriptionImagePadding;
    
    //Add image, if there is room
    if (self.panelImageView.image) {
        self.panelImageView.frame = CGRectMake(kLeftRightMargins, runningYOffset, self.frame.size.width - 2*kLeftRightMargins, self.frame.size.height - runningYOffset - kBottomPadding);
        self.panelImageView.contentMode = UIViewContentModeCenter;
        self.panelImageView.clipsToBounds = YES;
        [self addSubview:self.panelImageView];
    }

    // If this is a custom panel, set the has Custom animation boolean
    if (self.isCustomPanel == YES) {
        self.hasCustomAnimation = YES;
    }
}

- (void) hideContent
{
    _panelTitleLabel.alpha = 0;
    _panelDescriptionLabel.alpha = 0;
    _panelSeparatorLine.alpha = 0;
    if (_panelHeaderView) {
        _panelHeaderView.alpha = 0;
    }
    _panelImageView.alpha = 0;
}

- (void) showContent
{
    if (_isCustomPanel && !_hasCustomAnimation) {
        return;
    }
    
    //Get initial frames
    CGRect initialHeaderFrame = CGRectZero;
    if ([self panelHeaderView]) {
        initialHeaderFrame = self.panelHeaderView.frame;
    }
    CGRect initialTitleFrame = [self panelTitleLabel].frame;
    CGRect initialDescriptionFrame = [self panelDescriptionLabel].frame;
    CGRect initialImageFrame = [self panelImageView].frame;
    
    //Offset frames
    [[self panelTitleLabel] setFrame:CGRectMake(initialTitleFrame.origin.x + 10, initialTitleFrame.origin.y, initialTitleFrame.size.width, initialTitleFrame.size.height)];
    [[self panelDescriptionLabel] setFrame:CGRectMake(initialDescriptionFrame.origin.x + 10, initialDescriptionFrame.origin.y, initialDescriptionFrame.size.width, initialDescriptionFrame.size.height)];
    [[self panelHeaderView] setFrame:CGRectMake(initialHeaderFrame.origin.x, initialHeaderFrame.origin.y - 10, initialHeaderFrame.size.width, initialHeaderFrame.size.height)];
    [[self panelImageView] setFrame:CGRectMake(initialImageFrame.origin.x, initialImageFrame.origin.y + 10, initialImageFrame.size.width, initialImageFrame.size.height)];
    
    //Animate title and header
    [UIView animateWithDuration:0.3 animations:^{
        [[self panelTitleLabel] setAlpha:1];
        [[self panelTitleLabel] setFrame:initialTitleFrame];
        [[self panelSeparatorLine] setAlpha:1];
        
        if ([self panelHeaderView]) {
            [[self panelHeaderView] setAlpha:1];
            [[self panelHeaderView] setFrame:initialHeaderFrame];
        }
    } completion:^(BOOL finished) {
        //Animate description
        [UIView animateWithDuration:0.3 animations:^{
            [[self panelDescriptionLabel] setAlpha:1];
            [[self panelDescriptionLabel] setFrame:initialDescriptionFrame];
            [[self panelImageView] setAlpha:1];
            [[self panelImageView] setFrame:initialImageFrame];
        }];
    }];
}

+(BOOL)runningiOS7{
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if (currSysVer.floatValue >= 7.0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Interaction Methods

-(void)panelDidAppear{
    //Implemented by subclass
}

-(void)panelDidDisappear{
    //Implemented by subclass
}


@end
