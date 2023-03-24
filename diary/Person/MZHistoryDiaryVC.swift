//
//  MZHistoryDiaryVC.swift
//  diary
//
//  Created by 曾龙 on 2019/3/2.
//  Copyright © 2019年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh
import MZExtension

enum MZDiaryListType {
    case history
    case star
}

class MZHistoryDiaryVC: MZFatherController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    lazy var diaryList:NSMutableArray = {
        let diaryList = NSMutableArray();
        return diaryList;
    }()
    var type: MZDiaryListType!
    var pageNum:NSInteger!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "浏览历史";
        if self.type == MZDiaryListType.star {
            self.title = "我的点赞";
        }
        
        self.tableView.register(UINib.init(nibName: "MZMainPageTextCell", bundle: nil), forCellReuseIdentifier: "MZMainPageTextCell");
        self.tableView.register(UINib.init(nibName: "MZMainPageImageCell", bundle: nil), forCellReuseIdentifier: "MZMainPageImageCell");
        self.tableView.register(UINib.init(nibName: "MZMainPageMutiCell", bundle: nil), forCellReuseIdentifier: "MZMainPageMutiCell");
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadNew));
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore));
        self.tableView.mj_header.beginRefreshing();
    }
    
    @objc func loadNew() -> Void {
        self.pageNum = 1;
        self.loadData();
    }
    
    @objc func loadMore() -> Void {
        self.pageNum += 1;
        self.loadData();
    }
    
    func loadData() -> Void {
        if self.type == MZDiaryListType.history {
            MZAPI.getHistoryDiary(pageNum: self.pageNum, pageSize: "10") { (data, rmsg) in
                if (self.pageNum == 1) {
                    self.tableView.mj_header.endRefreshing();
                } else {
                    self.tableView.mj_footer.endRefreshing();
                }
                if rmsg == "ok" {
                    if (self.pageNum == 1) {
                        self.diaryList.removeAllObjects();
                    }
                    let array:[NSDictionary] = data?.value(forKey: "diaryList") as! [NSDictionary];
                    for i in 0 ..< array.count {
                        if let model = MZDiaryModel.deserialize(from: (array[i])) {
                            self.diaryList.add(model);
                        };
                    }
                    self.tableView.reloadData();
                } else {
                    MBProgressHUD.showError(error: rmsg);
                }
            }
        } else {
            MZAPI.getStarDiary(pageNum: self.pageNum, pageSize: "10") { (data, rmsg) in
                if (self.pageNum == 1) {
                    self.tableView.mj_header.endRefreshing();
                } else {
                    self.tableView.mj_footer.endRefreshing();
                }
                if rmsg == "ok" {
                    if (self.pageNum == 1) {
                        self.diaryList.removeAllObjects();
                    }
                    let array:[NSDictionary] = data?.value(forKey: "diaryList") as! [NSDictionary];
                    for i in 0 ..< array.count {
                        if let model = MZDiaryModel.deserialize(from: (array[i])) {
                            self.diaryList.add(model);
                        };
                    }
                    self.tableView.reloadData();
                } else {
                    MBProgressHUD.showError(error: rmsg);
                }
            }
        }
    }
    
    //MARK:-UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diaryList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:MZDiaryModel = self.diaryList[indexPath.row] as! MZDiaryModel;
        if model.type == "1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MZMainPageTextCell") as! MZMainPageTextCell;
            cell.model = model;
            cell.showUserDetail = { userID in
                
            }
            return cell;
        } else if model.type == "2" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MZMainPageImageCell") as! MZMainPageImageCell;
            cell.model = model;
            cell.showUserDetail = { userID in
                
            }
            cell.previewImage = { (imageViewList, currentIndex) in
                let imageBrowsingVC = MZImageBrowsingVC.init(imageViewArray: imageViewList, currentIndex: currentIndex);
                self.present(imageBrowsingVC!, animated: true, completion: nil);
            }
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MZMainPageMutiCell") as! MZMainPageMutiCell;
            cell.model = model;
            cell.showUserDetail = { userID in
                
            }
            cell.previewImage = { (imageViewList, currentIndex) in
                let imageBrowsingVC = MZImageBrowsingVC.init(imageViewArray: imageViewList, currentIndex: currentIndex);
                self.present(imageBrowsingVC!, animated: true, completion: nil);
            }
            return cell;
        }
    }
    
    //MARK:-UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MZDiaryDetailVC.init(nibName: "MZDiaryDetailVC", bundle: nil);
        vc.model = (self.diaryList[indexPath.row] as! MZDiaryModel);
        vc.updateData = {
            self.tableView.reloadData();
        }
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model:MZDiaryModel = self.diaryList[indexPath.row] as! MZDiaryModel;
        if model.type == "1" {
            let cell = self.tableView(self.tableView, cellForRowAt: indexPath) as! MZMainPageTextCell;
            return cell.Height;
        } else if model.type == "2" {
            let cell = self.tableView(self.tableView, cellForRowAt: indexPath) as! MZMainPageImageCell;
            return cell.Height;
        } else {
            let cell = self.tableView(self.tableView, cellForRowAt: indexPath) as! MZMainPageMutiCell;
            return cell.Height;
        }
    }

}
