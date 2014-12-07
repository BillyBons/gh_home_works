//
//  ViewController.m
//  HomeTask8
//
//  Created by Billy on 06.12.14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (weak, nonatomic) IBOutlet UIPageControl *myPageControl;

@property (weak, nonatomic) IBOutlet UIButton *myLoginButton;

@property (weak, nonatomic) IBOutlet UIButton *myRegistrationButton;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = (id)self.myCollectionView.collectionViewLayout;
    layout.itemSize = self.view.frame.size;
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"1"];
    self.myPageControl.numberOfPages = 5;
    
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    UICollectionViewFlowLayout *layout = (id)self.myCollectionView.collectionViewLayout;
    layout.itemSize = self.view.frame.size;
    [self.myCollectionView reloadData];
    self.myCollectionView.contentOffset = CGPointZero;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.myCollectionView dequeueReusableCellWithReuseIdentifier:@"1" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:1.0f/(indexPath.row + 1) green:1.0f/(indexPath.row + 1) blue:1.0f/(indexPath.row + 1) alpha:1.0f/(indexPath.row + 1)];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.myPageControl.currentPage = self.myCollectionView.contentOffset.x / self.myCollectionView.frame.size.width;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
