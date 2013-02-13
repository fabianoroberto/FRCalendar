//
//  FRHeaderView.h
//  FRCalendar
//
//  Created by Dr Thief on 13/02/13.
//  Copyright (c) 2013 Dr Thief. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *currentMonth;
@property (weak, nonatomic) IBOutlet UILabel *currentYear;
@end
