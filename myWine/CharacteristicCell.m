//
//  CharacteristicCell.m
//  myWine
//
//  Created by Diogo Castro on 5/31/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import "CharacteristicCell.h"

@implementation CharacteristicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//template methods
- (int) minVal {
    return 0;
}

- (int) maxVal {
    if ([[self.item classifications] count] <= 1)  {
        return 0;
    }
    return 100;
}

- (int) itemChosenWeight {
    if ([[self.item classifications] count] <= 1)  {
        return 0;
    }
    
    Classificacao* classification = [self.item classification_chosen];
    
    //find currently selected classification's index
    int i;
    for(i = 0; i < [self.item classifications].count && ![[((Classificacao*)[[self.item classifications] objectAtIndex:i]) name] isEqualToString:classification.name]; i++);
    
    return i * (100.0 / (float) ([[[self item] classifications] count] - 1 ));
    
}

- (int) itemWeight:(Classificacao*) classification {
    if ([[self.item classifications] count] <= 1)  {
        return 0;
    }
    
    int index = [[[self item] classifications] indexOfObject:classification];
    int weight = index * (100.0 / (float) ([[[self item] classifications] count]-1));
    
    return weight;
}

- (NSString*) getClassificationLabel:(Classificacao*) classification {
    return [[NSString alloc] initWithFormat:@"%@", classification.name];
}

-(NSString*) reuseIdentifier {
    return [NSString stringWithFormat:@"characteristic %i", [[self item] characteristic_id]];
}

@end
