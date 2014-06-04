//
//  PostsCDTVC.m
//  NetAppDemo
//
//  Created by David Butts on 5/29/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import "PostsCDTVC.h"
#import "PostTableViewCell.h"
#import "NSDate+ISO8601.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ID_POSTTABLEVIEWCELL @"postcell"
#define PLACEHOLDER_IMAGE @"Placeholder.png"
#define DEFAULT_ROW_HEIGHT @98

@interface PostsCDTVC ()

@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
@property (assign, nonatomic) BOOL isInsertingRow;

@end

@implementation PostsCDTVC

// Sample table view cell used for row height calculation
PostTableViewCell *mTableViewCell;

NSMutableArray *mHeightForRow;


#pragma mark - Properties

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.offscreenCells = [NSMutableDictionary dictionary];
        self.tableView.estimatedRowHeight = DEFAULT_ROW_HEIGHT.floatValue;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:ENTITY_KEY ascending:NO ]];
        request.predicate = nil; // All posts
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark - UITableViewDataSource

// To find this row's post in the table we will use NSFetchedResultsController's objectAtIndexPath: .
// The cell will then be setup using the Post object.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID_POSTTABLEVIEWCELL];
    
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.usernameLabel.text = post.username;
    cell.messageLabel.text = post.text;
    
    // Display simple time of post (e.g. 12:45 PM)
    cell.elapsedTimeLabel.text = [post.created_at shortFormattedTimeString];

    // Use SDWebImage category to load the avatar image (handles background loading and image cache)
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString: post.avatar_image]
                  placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMAGE]];

    // Apply rounded corners to avatar image
    cell.avatarImageView.layer.masksToBounds = YES;
    cell.avatarImageView.layer.cornerRadius = 5.0;

    
    if(!post.row_height){
        // Force layout based on the constraints using the cell's message text
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        // Calculate the required row height and save this information
        CGSize contentSize = [cell.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
        post.row_height = @(contentSize.height + 1.0f);
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Use calculated row height value if available else return default
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return (post.row_height) ? (CGFloat) post.row_height.floatValue : (CGFloat) DEFAULT_ROW_HEIGHT.floatValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // SDWebImage will automatically clear the memory cache due to memory warnings
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
