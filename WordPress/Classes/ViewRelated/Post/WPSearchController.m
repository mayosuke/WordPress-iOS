#import "WPSearchController.h"

@interface WPSearchController () <UISearchBarDelegate>

@property (nonatomic, strong, readwrite) UIViewController *searchResultsController;
@property (nonatomic, strong, readwrite) UISearchBar *searchBar;
@property (nonatomic, assign) BOOL transitioningActiveState;
@end

@implementation WPSearchController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _searchBar = [[UISearchBar alloc] init];
    }
    return self;
}

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
{
    self = [self init];
    if (self) {
        _searchResultsController = searchResultsController;
    }
    return self;
}


#pragma mark - Accessors

- (void)setActive:(BOOL)active
{
    if (_active == active || self.transitioningActiveState) {
        return;
    }

    self.transitioningActiveState = YES;

    if (active) {
        [self presentSearchController];
    } else {
        [self dismissSearchController];
    }
}


#pragma mark - Instance Methods

- (void)presentSearchController
{
    if ([self.delegate respondsToSelector:@selector(presentSearchController:)]) {
        [self.delegate presentSearchController:self];
    }

    if ([self.delegate respondsToSelector:@selector(willPresentSearchController:)]) {
        [self.delegate willPresentSearchController:self];
    }

    _active = YES;
    self.transitioningActiveState = NO;

    [self updateResults];

    if ([self.delegate respondsToSelector:@selector(didPresentSearchController:)]) {
        [self.delegate didPresentSearchController:self];
    }
}

- (void)dismissSearchController
{
    if ([self.delegate respondsToSelector:@selector(willDismissSearchController:)]) {
        [self.delegate willDismissSearchController:self];
    }

    [self.searchBar resignFirstResponder];

    _active = NO;
    self.transitioningActiveState = NO;

    [self updateResults];

    if ([self.delegate respondsToSelector:@selector(didDismissSearchController:)]) {
        [self.delegate didDismissSearchController:self];
    }
}

- (void)updateResults
{
    [self.searchResultsUpdater updateSearchResultsForSearchController:self];
}


#pragma mark - SearchBar Delegate Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.active = YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self updateResults];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.active = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.active = NO;
}

@end