//
//  ViewController.m
//  Calculadora UESC
//
//  Created by Wildson Jr. on 12/2/14.
//  Copyright (c) 2014 Wildson Jr. All rights reserved.
//

#import "ViewController.h"

#import "UIColor+Additions.h"

#define MAX_COUNT 10
#define MIN_COUNT 1

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *list;
}

#pragma mark -
#pragma mark Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark Initializer

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        list = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:-1.0f], nil];
    }
    return self;
}

#pragma mark -
#pragma mark View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    UITapGestureRecognizer *tapGestureRecognizer;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    [self.clearButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.equalsButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.addButton setBackgroundColor:[UIColor lightGrayColor]];
    
    [self btnClearTapped:nil];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)btnAddPressed:(id)sender
{
    [self.view endEditing:YES];
    
    if ([list count] < MAX_COUNT)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[list count] inSection:0];
        if (indexPath != nil)
        {
            NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
            
            [list addObject:[NSNumber numberWithDouble:-1.0f]];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
            
            [self updatePlaceholders];
        }
    }
}

- (IBAction)btnRemovePressed:(id)sender
{
    [self.view endEditing:YES];
    
    if ([list count] > MIN_COUNT)
    {
        CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath != nil)
        {
            NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
            
            [list removeObjectAtIndex:indexPath.row];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
            
            [self updatePlaceholders];
        }
    }
}

- (IBAction)btnEqualsPressed:(id)sender
{
    [self.view endEditing:YES];
    
    double sum = 0.0f;
    
    for (int i = 0; i < [list count]; i++)
    {
        NSNumber *number = [list objectAtIndex:i];
        if ([number doubleValue] >= 0.0f)
        {
            sum += [[list objectAtIndex:i] doubleValue];
        }
    }
    
    double mean = sum / [list count];
    
    if (mean >= 7.0f)
    {
        [self.statusBarView setBackgroundColor:[UIColor greenColor]];
        [self.statusLabel setText:@"Aprovado"];
        [self.messageLabel setText:@"Parabéns!"];
    }
    else
    {
        double final = (50 - (mean * 6)) / 4;
        
        if (final > 10.0f)
        {
            [self.statusBarView setBackgroundColor:[UIColor maroonColor]];
            [self.statusLabel setText:@"Reprovado"];
            [self.messageLabel setText:@"Não há como passar!"];
        }
        else
        {
            [self.statusBarView setBackgroundColor:[UIColor redColor]];
            [self.statusLabel setText:@"Final"];
            [self.messageLabel setText:[NSString stringWithFormat:@"Precisa de %.2f!", final]];
        }
    }
    
    [self.resultLabel setText:[NSString stringWithFormat:@"%.2f", mean]];
}

- (IBAction)btnClearTapped:(id)sender
{
    [self.view endEditing:YES];
    
    [self.statusBarView setBackgroundColor:[UIColor orangeColor]];
    
    [self.statusLabel setText:@""];
    [self.resultLabel setText:@""];
    [self.messageLabel setText:@""];
    
    list = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:-1.0f], nil];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UITextField *textField = (UITextField *)[cell viewWithTag:1];
    [textField setText:@""];
    [textField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)]];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    [textField setBackgroundColor:[UIColor darkGrayColor]];
    [self updatePlaceholder:textField atIndex:indexPath.row];
    
    UIButton *removeButton = (UIButton *)[cell viewWithTag:2];
    [removeButton setBackgroundColor:[UIColor lightGrayColor]];
    
    NSNumber *number = [list objectAtIndex:indexPath.row];
    if ([number doubleValue] >= 0.0f)
    {
        [textField setText:[number stringValue]];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setUsesGroupingSeparator:YES];
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    double value = [[numberFormatter numberFromString:text] doubleValue];
    
    NSUInteger index = [text rangeOfString:numberFormatter.decimalSeparator].location;
    if (index != NSNotFound)
    {
        if (index != 1 || (([text length] - index - 1) > 2))
        {
            return NO;
        }
        
        if ([[text componentsSeparatedByString:numberFormatter.decimalSeparator] count] > 2)
        {
            return NO;
        }
    }
    else if ((value < 10 && [text length] > 1) || value > 10)
    {
        return NO;
    }
    
    CGPoint senderPosition = [textField convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:senderPosition];
    
    if (indexPath != nil)
    {
        NSNumber *number = [NSNumber numberWithDouble:value];
        [list replaceObjectAtIndex:indexPath.row withObject:number];
    }
    
    return YES;
}

#pragma mark -
#pragma mark Methods

- (void)handleTap
{
    [self.view endEditing:YES];
}

- (void)updatePlaceholders
{
    for (int i = 0; i < [list count]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        UITextField *textField = (UITextField *)[cell viewWithTag:1];
        [self updatePlaceholder:textField atIndex:i];
    }
}

- (void)updatePlaceholder:(UITextField *)textField atIndex:(NSUInteger)i
{
    NSAttributedString *placeholder;
    placeholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d° crédito", i + 1]
                                                  attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [textField setAttributedPlaceholder:placeholder];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
