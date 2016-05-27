//
//  OAuthViewController.swift
//  SFWeiBo
//
//  Created by mac on 16/4/6.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//
//https://api.weibo.com/oauth2/authorize
//https://api.weibo.com/oauth2/authorize?client_id=3711226290&redirect_uri=http://blog.csdn.net/feng2qing
//http://blog.csdn.net/feng2qing?code=0e7cf84e28415b5684e343287b819e99

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    let WB_App_Key = "3711226290"
    let WB_App_Secret = "7e1b4ec154d0a6dfadf74e6c8287b84b"
    let WB_redirect_url = "http://blog.csdn.net/feng2qing"
    
    override func loadView() {
        
        //替换控制器的view为webView
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化导航条
        navigationItem.title = "少锋微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(OAuthViewController.close))
        
        //获取未授权的RequestToken
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_url)"
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - 懒加载
    private lazy var webView: UIWebView = {
        
        let wv = UIWebView()
        wv.delegate = self
        return wv
    }()
}

extension OAuthViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //判断是否授权回调页,如果不是就继续加载
        let urlString = request.URL!.absoluteString
        if !urlString.hasPrefix(WB_redirect_url) {
            //继续加载
            return true
        }
        
        //判断是否授权成功
        let codeString = "code="
        //request.URL.query可以取出链接中的参数
        if request.URL!.query!.hasPrefix(codeString) {
            //授权成功
            //取出已经授权的RequestToken
            let code = request.URL!.query?.substringFromIndex(codeString.endIndex)
            //用已经授权的RequestToken换取AccessToken
            loadAccessToken(code!)
        } else {
            //取消授权
            close()
        }
        return false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        //提示用户正在加载
        SVProgressHUD.showInfoWithStatus("正在加载中...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //关闭加载进度
        SVProgressHUD.dismiss()
    }
    
    //根据已经授权的RequestToken换取AccessToken
    private func loadAccessToken(code:String) {
        
        //定义路径
        let path = "oauth2/access_token"
        //封装字典参数
        let params = ["client_id":WB_App_Key,"client_secret":WB_App_Secret,"grant_type":"authorization_code","code":code,"redirect_uri":WB_redirect_url]
        //发送POST请求
        
        NetworkTools.shareNetworkTools().POST(path, parameters: params, progress: nil, success: { (_, JSON) -> Void in

            //字典转模型
            let account = UserAccount(dict: JSON as! [String: AnyObject])
            
            //获取用户信息
            account.loadUserInfo({ (account, error) -> () in
                if account != nil {
                    account!.saveAccount()
                    NSNotificationCenter.defaultCenter().postNotificationName(SFSwitchRootViewController, object: false)
                    return
                }
                
                SVProgressHUD.showInfoWithStatus("网络不给力...")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            })
            //归档模型
            account.saveAccount()
            
            }) { (_, error) -> Void in
                print(error)
        }
    }
}

