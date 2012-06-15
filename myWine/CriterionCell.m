//
//  CriterionCell.m
//  myWine
//
//  Created by Diogo Castro on 26/05/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "CriterionCell.h"
#import "UIColor+myWineColor.h"

@implementation CriterionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//template methods
- (int) minVal {
    return [[self item] minWeight];
}

- (int) maxVal {
    return [[self item] maxWeight];
}

- (int) itemChosenWeight {
    return [[[self item] classification_chosen] weight];
}

- (int) itemWeight:(Classificacao*) classification {
    return classification.weight;
}

- (NSString*) getClassificationLabel:(Classificacao*) classification {
    return [[NSString alloc] initWithFormat:@"%i  %@", classification.weight, classification.name];
}

-(NSString*) reuseIdentifier {
    return [NSString stringWithFormat:@"criterion %i", [[self item] criterion_id]];
}

@end
