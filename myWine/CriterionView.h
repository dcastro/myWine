//
//  CriterionView.h
//  myWine
//
//  Created by Diogo Castro on 5/10/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Criterio;

@interface CriterionView : UIView {
    BOOL highlighted;
	BOOL editing;
}

@property (weak, nonatomic) Criterio* criterion;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;


@end
