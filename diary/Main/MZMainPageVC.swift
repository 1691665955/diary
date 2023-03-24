//
//  MZMainPageVC.swift
//  diary
//
//  Created by 曾龙 on 2018/7/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh
import MZExtension

class MZMainPageVC: MZFatherController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    lazy var diaryList:NSMutableArray = {
        let diaryList = NSMutableArray();
        return diaryList;
    }()
    
    var pageNum:NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "日记";
        self.view.backgroundColor = UIColor.white;
        let rightItem : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addDiary));
        rightItem.tintColor = UIColor.white;
        self.navigationItem.rightBarButtonItem = rightItem;
        
        self.tableView.register(UINib.init(nibName: "MZMainPageTextCell", bundle: nil), forCellReuseIdentifier: "MZMainPageTextCell");
        self.tableView.register(UINib.init(nibName: "MZMainPageImageCell", bundle: nil), forCellReuseIdentifier: "MZMainPageImageCell");
        self.tableView.register(UINib.init(nibName: "MZMainPageMutiCell", bundle: nil), forCellReuseIdentifier: "MZMainPageMutiCell");
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadNew));
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore));
        self.loadNew();
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
        MZAPI.getMyDiary(pageNum: self.pageNum, pageSize: "10") { (data, rmsg) in
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
    
    @objc func addDiary() -> Void {
        let addVC = MZAddDiaryVC();
        addVC.addSuccess = {
            self.loadNew();
        }
        addVC.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(addVC, animated: true);
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
        vc.hidesBottomBarWhenPushed = true;
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
