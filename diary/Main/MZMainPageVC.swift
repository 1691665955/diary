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

class MZMainPageVC: MZFatherController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var otherDiaryBtn: UIButton!
    @IBOutlet weak var myDiaryBtn: UIButton!
    @IBOutlet weak var animationView: UIView!
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
        self.viewOtherDiarys(self.otherDiaryBtn);
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
        if self.myDiaryBtn.isSelected == false {
            MZAPI.getOtherDiary { (data, rmsg) in
                self.tableView.mj_header.endRefreshing();
                if rmsg == "ok" {
                    let array:[NSDictionary] = data?.value(forKey: "diaryList") as! [NSDictionary];
                    for i in (0 ..< array.count).reversed() {
                        if let model = MZDiaryModel.deserialize(from: (array[i])) {
                            self.diaryList.insert(model, at: 0);
                        };
                    }
                    MZDataUtil.saveOtherDiary(diaryList: array);
                    self.tableView.reloadData();
                } else {
                    MBProgressHUD.showError(error: rmsg);
                }
            }
        } else {
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
            cell.starBlock = {
                if self.otherDiaryBtn.isSelected {
                    let arr = (self.diaryList as! [MZDiaryModel]).toJSON();
                    MZDataUtil.resetOtherDiary(diaryList: arr as! [NSDictionary]);
                }
            }
            cell.showUserDetail = { userID in
                
            }
            return cell;
        } else if model.type == "2" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MZMainPageImageCell") as! MZMainPageImageCell;
            cell.model = model;
            cell.starBlock = {
                if self.otherDiaryBtn.isSelected {
                    let arr = (self.diaryList as! [MZDiaryModel]).toJSON();
                    MZDataUtil.resetOtherDiary(diaryList: arr as! [NSDictionary]);
                }
            }
            cell.showUserDetail = { userID in
                
            }
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MZMainPageMutiCell") as! MZMainPageMutiCell;
            cell.model = model;
            cell.starBlock = {
                if self.otherDiaryBtn.isSelected {
                    let arr = (self.diaryList as! [MZDiaryModel]).toJSON();
                    MZDataUtil.resetOtherDiary(diaryList: arr as! [NSDictionary]);
                }
            }
            cell.showUserDetail = { userID in
                
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
            if self.otherDiaryBtn.isSelected {
                let arr = (self.diaryList as! [MZDiaryModel]).toJSON();
                MZDataUtil.resetOtherDiary(diaryList: arr as! [NSDictionary]);
            }
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

    @IBAction func viewOtherDiarys(_ sender: UIButton) {
        if sender.isSelected {
            self.tableView.mj_header.beginRefreshing();
        } else {
            self.tableView.mj_footer = nil;
            sender.isSelected = true;
            self.myDiaryBtn.isSelected = false;
            self.diaryList.removeAllObjects();
            let otherDiarys = MZDataUtil.getOtherDiary();
            for i in 0 ..< otherDiarys.count {
                if let model = MZDiaryModel.deserialize(from: (otherDiarys[i])) {
                    self.diaryList.add(model);
                };
            }
            self.tableView.reloadData();
            self.tableView.mj_header.beginRefreshing();
            UIView.animate(withDuration: 0.3) {
                var center = self.animationView.center;
                center.x = sender.center.x;
                self.animationView.center = center;
            };
        }
    }
    
    @IBAction func viewMyDiarys(_ sender: UIButton) {
        if sender.isSelected {
            self.tableView.mj_header.beginRefreshing();
        } else {
            self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore));
            sender.isSelected = true;
            self.otherDiaryBtn.isSelected = false;
            self.diaryList.removeAllObjects();
            self.tableView.reloadData();
            self.tableView.mj_header.beginRefreshing();
            UIView.animate(withDuration: 0.3) {
                var center = self.animationView.center;
                center.x = sender.center.x;
                self.animationView.center = center;
            };
        }
    }
}
