//
//  HomeTableViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//
//App Key：3711226290
//App Secret：7e1b4ec154d0a6dfadf74e6c8287b84b

//https://api.weibo.com/oauth2/authorize
//https://api.weibo.com/oauth2/authorize?client_id=3711226290&redirect_uri=http://blog.csdn.net/feng2qing
//http://blog.csdn.net/feng2qing?code=0e7cf84e28415b5684e343287b819e99

import UIKit

let HomeTableViewReuseIdentifier = "HomeTableViewReuseIdentifier"

class HomeTableViewController: BaseTableViewController  {

    //保存微博数组
    var status: [Status]? {
        //设置数据后调用该方法
        didSet {
            //当设置完数据后，就刷新表格
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. 如果没有登录,就设置未登录界面信息
        if !userLogin {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人,回这里看看有什么惊喜")
            //没有登陆的时候,不需要执行下面的代码
            return
        }
        
        //2. 初始化导航条
        setupNav()
        
        //3. 注册通知,监听菜单状态,设置小箭头朝向
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: PopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.change), name: PopoverAnimatorWillDismiss, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.showPhotoBrowser(_:)), name: SFStatusPictureViewSelected, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTableViewController.gotoDetailPage), name: "gotoDetailPage", object: nil)
        
        //注册2个cell(默认的cell 和 转发的cell)
        tableView.registerClass(StatusNormalTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(StatusForwardTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.ForwardCell.rawValue)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //添加下拉刷新控件
        refreshControl = HomeRefreshControl()
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)

        //4. 加载微博数据
        loadData()
    }
    
    ///显示图片浏览器
    func showPhotoBrowser(notify: NSNotification) {
        
        guard let indexPath = notify.userInfo![SFStatusPictureViewIndexKey] else {
            //收到的值为空
            return
        }
        guard let urls = notify.userInfo![SFStatusPictureViewUrlsKey] else {
            //收到的值为空
            return
        }
        //创建图片浏览器
        let vc = PhotoBrowserViewController(index: indexPath.item, urls: urls as! [NSURL])
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func gotoDetailPage(notify: NSNotification) {
        
        hidesBottomBarWhenPushed = true
        let vc = HomeDetailViewController()
        vc.currentStatus = notify.userInfo!["dict"] as? Status
        navigationController?.pushViewController(vc, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    deinit {
        //deinit相当于dealloc,在这里移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //标记当前是上拉还是下拉
    var pullupRefreshFlag = false
    
    // MARK: - 加载微博数据
    // 被系统(如addTarget)调用的方法,不能是私有方法,或者去掉private,或者转换为OC的方法(@objc)
    @objc private func loadData() {
        
        //默认返回最新20条数据
        //since_id: 返回since_id大的微博
        //max_id: 返回小于等于max_id的微博
        //默认当做下拉处理
        var since_id = status?.first?.id ?? 0
        var max_id = 0
        //判断是上拉还是下拉
        if pullupRefreshFlag {
            since_id = 0
            max_id = status?.last?.id ?? 0
        }
        
        Status.loadStatus(since_id,max_id:max_id) { (models, error) -> () in
            
            //请求到数据就结束刷新
            self.refreshControl?.endRefreshing()
            
            if error != nil {
                return
            }
            
            //下拉刷新
            if since_id > 0 {
                //有新数据,数据拼接
                self.status = models! + self.status!
                //显示刷新后的提醒
                self.showNewStatusCount(models!.count ?? 0)
            } else if max_id > 0 {
                //上拉加载,把数据拼接到原来数据的后面
                self.status = self.status! + models!
            } else {
                //没有新数据
                self.status = models
            }
        }
    }
    
    private func showNewStatusCount(count: Int) {
        
        newStatusLabel.hidden = false
        newStatusLabel.text = (count == 0) ? "没有刷新到新的微博数据" : "刷新到\(count)条微博数据"
        
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.newStatusLabel.transform = CGAffineTransformMakeTranslation(0, self.newStatusLabel.frame.height)
            
        }) { (_) -> Void in
            UIView.animateWithDuration(2, animations: { () -> Void in
                
                self.newStatusLabel.transform = CGAffineTransformIdentity
                }, completion: { (_) -> Void in
                    self.newStatusLabel.hidden = true
            })
        }
    }
    
    //标题按钮状态
    func change() {
        
        //修改标题按钮箭头的朝向
        let titleButton = navigationItem.titleView as! TitleButton
        titleButton.selected = !titleButton.selected
    }
    
    private func setupNav() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftItemClcik))
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightItemClick))
        
        //创建标题按钮
        let titleButton = TitleButton()
        titleButton.setTitle("少锋 ", forState: UIControlState.Normal)
        titleButton.addTarget(self, action: #selector(HomeTableViewController.titleButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleButton
    }
    
    func titleButtonClick(button:TitleButton) {
        
        //1. 修改箭头方向
        //button.selected = !button.selected
        
        //2. 弹出菜单
        let storyBoard = UIStoryboard(name: "PopoverViewController", bundle: nil)
        //根据storyBoard创建控制器并弹出
        let viewController = storyBoard.instantiateInitialViewController()
        //2.1 设置转场代理
        //默认情况下,model会移除以前控制器的view,替换为当前弹出的view
        //如果自定义转场,那么不会移除以前控制器的View
        //viewController?.transitioningDelegate = self
        viewController?.transitioningDelegate = popoverAnimator

        //2.2 设置转场样式
        viewController?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(viewController!, animated: true, completion: nil)
    }
    
    func leftItemClcik() {
        //print(__FUNCTION__)
    }
    
    func rightItemClick() {
        
        let storyBoard = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let viewController = storyBoard.instantiateInitialViewController()
        presentViewController(viewController!, animated: true, completion: nil)
    }
    
    //MARK: - 懒加载
    //一定要定义一个属性来保持自定义转场对象
    //PopoverAnimator: 转场动画的对象 
    private lazy var popoverAnimator: PopoverAnimator = {
        
        let pa = PopoverAnimator()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return pa
    }()
    
    //刷新微博后提醒的通知
    private lazy var newStatusLabel: UILabel = {
        
        let label = UILabel()
        let height: CGFloat = 44
        //        label.frame =  CGRect(x: 0, y: -2 * height, width: UIScreen.mainScreen().bounds.width, height: height)
        label.frame =  CGRect(x: 0, y: 44, width: UIScreen.mainScreen().bounds.width, height: height)
        
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        
        // 加载 navBar 上面，不会随着 tableView 一起滚动
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        label.hidden = true
        return label
    }()
    
    //微博行高的缓存,利用字典作为容器,key就是微博的id,值就是对应微博的行高,
    //分类中不能定义,在这定义
    var rowCache: [Int: CGFloat] = [Int:CGFloat]()
    
    override func didReceiveMemoryWarning() {
        //有内存警告的时候.清空缓存
        rowCache.removeAll()
    }
}

extension HomeTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //如果没有值，就返回0
        return status?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let stat = status![indexPath.row]
        //根据模型加载cell（转发还是普通的）
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(stat), forIndexPath: indexPath) as! StatusTableViewCell
        
        //为每个cell赋值数据源
        cell.status = stat
        
        //判断是否滑动到了最后一个cell
        let count = status?.count ?? 0
        if indexPath.row == (count - 1) {
            pullupRefreshFlag = true
            loadData()
        }
        return cell
    }
    
    //返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //取出对应行的模型
        let stat = status![indexPath.row]
        
        //判断有没有缓存的行高
        if let height = rowCache[stat.id] {
            //有缓存过直接返回行高
            return height
        }
        
        //拿到cell(dequeue不要选用有IndexPath方法的)
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(stat)) as! StatusTableViewCell
        //拿到cell对应的行高
        let rowHeight = cell.rowHeight(stat)
        //缓存行高
        rowCache[stat.id] = rowHeight
        return rowHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        hidesBottomBarWhenPushed = true
        let vc = HomeDetailViewController()
        vc.currentStatus = status![indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        hidesBottomBarWhenPushed = false
    }
}
