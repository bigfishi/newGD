//
//  gdiInfoTableViewCell.m
//  GDiPhone
//
//  Created by YuDa on 14-9-25.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiInfoTableViewCell.h"
#import "gdiSingleton.h"

@implementation gdiInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellDidLoad
{
    CGFloat offsetX = 8;
    if (self.titleLabel == nil)
    {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = self.title;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.titleLabel sizeToFit];
        [self.contentView addSubview:self.titleLabel];
        CGRect frame = self.contentView.frame;
        frame.origin.x = offsetX;
        frame.size.width = self.titleLabel.frame.size.width;
        self.titleLabel.frame = frame;
    }
    offsetX += 50;
    if (self.contentLabel == nil)
    {
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.text = self.content;
        [self.contentLabel sizeToFit];
        [self.contentView addSubview:self.contentLabel];
        CGRect frame = self.contentView.frame;
        frame.origin.x = offsetX + 10;
        frame.size.width = self.contentLabel.frame.size.width;
        self.contentLabel.frame = frame;
        // 特点两行
        if ([self.enTitle isEqualToString:kInfoFeature] && self.contentLabel.frame.size.width > 470)
        {
            CGSize maxSize = CGSizeMake(470, 30);
//            self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, maxSize.width, maxSize.height)];
            self.contentLabel.numberOfLines = 2;
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle.copy};
            
            CGSize labelSize = [self.content boundingRectWithSize:CGSizeMake(maxSize.width, maxSize.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            labelSize.height = ceil(labelSize.height);
            labelSize.width = ceil(labelSize.width);
            // 最长的字符串  177 29
            self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, labelSize.width, 45);
        }
        else if ([self.enTitle isEqualToString:kInfoPrice])
        {
//            self.contentLabel.textColor = priceColor;
            self.contentLabel.font = priceFont;
            CGRect frame = self.contentLabel.frame;
            frame.size = CGSizeMake(frame.size.width + 100, frame.size.height);
            self.contentLabel.frame = frame;
        }
    }
}

@end
