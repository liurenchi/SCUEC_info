//
//  ViewController.swift
//  testAmap
//
//  Created by  Lrcray on 15/4/12.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
let APIKey = "87c029f74db9749e657c57de83d47568" //用了storyboard的原因，配置与appdelegate中

class MapView: UIViewController, MAMapViewDelegate, AMapSearchDelegate
{
       
    
    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var locateButton: UIButton!
    
    var search: AMapSearchAPI!
    var userCurrentLocation: CLLocation!
    

    
//MARK: - Action
    
    //逆地理编码
    func reGeoAction() {
        if (userCurrentLocation != nil) {
            var request: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
            request.location = AMapGeoPoint.locationWithLatitude(CGFloat(userCurrentLocation.coordinate.latitude), longitude: CGFloat(userCurrentLocation.coordinate.longitude))
            search!.AMapReGoecodeSearch(request)
            
            
        }
    }
    //定位按钮
    @IBAction func Location() {
        
        //定位模式
        if mapView.userTrackingMode == MAUserTrackingModeNone {
            locateButton.setImage(UIImage(named:"207-Location"), forState: UIControlState.Normal)
            mapView.userTrackingMode = MAUserTrackingModeFollow
        }else if mapView.userTrackingMode == MAUserTrackingModeFollow {
            locateButton.setImage(UIImage(named:"165-Direction"), forState: UIControlState.Normal)
            mapView.userTrackingMode = MAUserTrackingModeNone
     
        }
    }

    
    
//MARK: - search delegate
    
    func initSearch() {
        search = AMapSearchAPI(searchKey: APIKey, delegate: self)
    }

    //编码成功回调
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        println("reponse:\(response)")
        
        var title: String = response.regeocode.addressComponent.city
        
        var length: Int = count(title)
        
        if (length == 0) {
            title = response.regeocode.addressComponent.province
        }
        mapView?.userLocation.title = title
        mapView?.userLocation.subtitle = response.regeocode.formattedAddress
        
    }

    //searchc出错回调方法
    func searchRequest(request: AnyObject!, didFailWithError error: NSError!) {
        println("searchRequesterror:\(error)")
    }
    
    
    
//MARK: - life cycle
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        //初始化地图
        initMapView()
        initSearch()
        
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
//MARK: - map delegate
    func initMapView(){
        
        mapView.delegate = self
        //指南针比例尺的x坐标
//        let compassX = mapView.compassOrigin.x
//        let compassY = mapView.frame.height - 22
////        let scaleY = mapView.frame.height - 22
        mapView.showsScale = false
        mapView.showsCompass = false
//        mapView.compassOrigin = CGPointMake(compassX,compassY)
//        //mapView.scaleOrigin = CGPointMake(scaleX, scaleY)
        //打开用户定位
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingModeFollow
        
        
    }

    @IBAction func quite() {
        mapView.delegate = nil
        //高德地图bug！！！！！
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    

    
    // 定位失败回调
    func mapView(mapView: MAMapView!, didFailToLocateUserWithError error: NSError!) {
        
        println(error)
    }
    // 定位回调
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        userCurrentLocation = userLocation.location.copy() as? CLLocation
        println("location:\(userLocation.location)")
    }
    //选中图钉后的回调
    func mapView(mapView: MAMapView!, didSelectAnnotationView view: MAAnnotationView!) {
        if view.annotation.isKindOfClass(MAUserLocation){
            reGeoAction()
        }
    }

}

