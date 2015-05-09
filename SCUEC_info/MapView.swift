//
//  ViewController.swift
//  testAmap
//
//  Created by  Lrcray on 15/4/12.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit
let APIKey = "87c029f74db9749e657c57de83d47568" //用了storyboard的原因，配置与appdelegate中

class MapView: UIViewController, MAMapViewDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate
{
       
    
    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var locateButton: UIButton!
    
    var search: AMapSearchAPI!
    var userCurrentLocation: CLLocation!
    
    //地图组件
    var pois:NSArray = []
    var annotations:NSMutableArray = []
    @IBOutlet weak var searchview: UITableView!
    
    //检查annotation的选中组数
    
    var anno_selected:NSMutableArray = []

    
//MARK: - Action
    
    //逆地理编码
    func reGeoAction() {
        if (userCurrentLocation != nil) {
            var request: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
            request.location = AMapGeoPoint.locationWithLatitude(CGFloat(userCurrentLocation.coordinate.latitude), longitude: CGFloat(userCurrentLocation.coordinate.longitude))
            search!.AMapReGoecodeSearch(request)
            
            
        }
    }
//MARK: - 按钮功能实现
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

    @IBAction func search(sender: UIButton) {
        if userCurrentLocation == nil || search == nil{
            println("搜索错误！")
            return
        }
        var request = AMapPlaceSearchRequest()
        request.searchType = AMapSearchType.PlaceAround
        request.location = AMapGeoPoint.locationWithLatitude(CGFloat(userCurrentLocation.coordinate.latitude), longitude: CGFloat(userCurrentLocation.coordinate.longitude))

        
        switch sender.tag{
        case 1:
            request.keywords = "餐饮"
        case 2:
            request.keywords = "电影"
        case 3:
            request.keywords = "商场"
        case 4:
            request.keywords = "公园"
        default:
            request.keywords = "图书馆"
        }
        
       
         search.AMapPlaceSearch(request)
    }
    //搜索餐馆
    @IBAction func searchfood() {
       
        
       
        
    }
    
//MARK: - tableview delegate 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return pois.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        
        var poi:AMapPOI = pois[indexPath.row] as! AMapPOI
        cell.textLabel?.text = poi.name
        cell.detailTextLabel?.text = poi.address
        anno_selected.addObject(poi.name)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        searchview.deselectRowAtIndexPath(indexPath, animated: true)
        if anno_selected[indexPath.row] as! String == "isselected"{
            println("已经在地图显示")
        }else{
          anno_selected[indexPath.row] = "isselected"
        searchview.deselectRowAtIndexPath(indexPath, animated: true)
        var poi:AMapPOI = pois[indexPath.row] as! AMapPOI
        var annotation = MAPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(Double(poi.location.latitude), Double(poi.location.longitude))
        annotation.title = poi.name
        annotation.subtitle = poi.address
        
        annotations .addObject(annotation)
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = annotation.coordinate
      
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
        self.view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

        //初始化地图
        initMapView()
        initSearch()
        
        
    }

//MARK: - map delegate
    func initMapView(){
        mapView.delegate = self
         mapView.showsScale = false
        mapView.showsCompass = false
        //打开用户定位
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingModeFollow
        
        
    }

    @IBAction func quite() {
        mapView.delegate = nil
        //高德地图bug！！！！！
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   //annotation回调
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation .isKindOfClass(MAPointAnnotation){
            let reuseindetifier = "annotationReuseIndentifier"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseindetifier)
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseindetifier)
            }
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
    }
    
    
    
    
    // 搜索回调
    
    
    func onPlaceSearchDone(request: AMapPlaceSearchRequest!, response: AMapPlaceSearchResponse!) {
        //println(request)
        //println(response)
        
        // println(response.pois)
         anno_selected.removeAllObjects()
        if response.pois != nil {
            pois = response.pois
            self.searchview.reloadData()
            
            mapView.removeAnnotations(annotations as [AnyObject])
            annotations.removeAllObjects()
            
            }
        
    }
    
    
    
    // 定位失败回调
    func mapView(mapView: MAMapView!, didFailToLocateUserWithError error: NSError!) {
        
        println(error)
    }
    // 定位回调
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        userCurrentLocation = userLocation.location.copy() as? CLLocation
        //println("location:\(userLocation.location)")
    }
    //选中图钉后的回调
    func mapView(mapView: MAMapView!, didSelectAnnotationView view: MAAnnotationView!) {
        if view.annotation.isKindOfClass(MAUserLocation){
            reGeoAction()
        }
    }

}

