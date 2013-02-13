//
//  FRCalendarCell.h
//  FRCalendar
//
//  Created by Dr Thief on 13/02/13.
//  Copyright (c) 2013 Dr Thief. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRCalendarCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *buttonCell;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *labelA;
@property (weak, nonatomic) IBOutlet UILabel *labelB;
@property (weak, nonatomic) IBOutlet UIImageView *imageCell;
@end
