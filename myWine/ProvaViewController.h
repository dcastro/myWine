//
//  ProvaViewController.h
//  myWine
//
//  Created by Diogo Castro on 5/9/12.
//  Copyright (c) 2012 FEUP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prova.h"
#import "Seccao.h"
#import "SeccaoCaracteristica.h"
#import "Criterio.h"
#import "CriterionCell.h"
#import "Caracteristica.h"
#import "CharacteristicCell.h"
#import "Vinho.h"
#import "MySplitViewViewController.h"
#import <QuartzCore/QuartzCore.h>

#define CRITERIA_MODE 0
#define CHARACTERISTICS_MODE 1

@protocol ProvaViewControllerDelegate

-(void) scoreUpdated:(int) score;

@end

@interface ProvaViewController : UITableViewController <SectionItemCellCellDelegate, TranslatableViewController> {
    BOOL keyboardIsShown;
    CGPoint originalOffset;
}

@property (strong, nonatomic) Prova* prova;
@property (strong, nonatomic) Vinho* vinho;

@property (nonatomic) int prova_mode;

@property (weak, nonatomic) IBOutlet UIView *upperView;


@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreContentLabel;
@property (weak, nonatomic) IBOutlet UIView *comentario;
@property (strong, nonatomic) IBOutlet UIView *header;

@property (strong, nonatomic) id<ProvaViewControllerDelegate> delegate;


- (void) setEditing:(BOOL)editing animated:(BOOL)animated done:(BOOL)done;

-(void) updateScoreLabelWithScore:(int) score;

- (void) translate;


@end
