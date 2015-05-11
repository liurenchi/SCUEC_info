//
//  hotmovieTableView.swift
//  SCUEC_info
//
//  Created by  Lrcray on 15/5/9.
//  Copyright (c) 2015年  Lrcray. All rights reserved.
//

import UIKit

class hotmovieTableView: UITableViewController {

    var hotmovie = ["速度与激情7","赤道","左耳","悬战","战狼","万物生长","复仇者联盟2","我的个神啊",]

    var movieimg = [
        "http://img5.douban.com/view/movie_poster_cover/mpst/public/p2233706697.jpg",
        "http://img5.douban.com/view/movie_poster_cover/mpst/public/p2238375159.jpg",
        "http://img5.douban.com/view/movie_poster_cover/mpst/public/p2238949728.jpg",
        "http://img3.douban.com/view/movie_poster_cover/mpst/public/p2241237305.jpg",
        "http://img5.douban.com/view/movie_poster_cover/mpst/public/p2225660666.jpg",
        "http://img3.douban.com/view/movie_poster_cover/spst/public/p2236052651.jpg",
        "http://img3.douban.com/view/movie_poster_cover/mpst/public/p2237747953.jpg",
        "http://img3.douban.com/view/movie_poster_cover/mpst/public/p2215268072.jpg"]
    var moviedetail = [
        "经历了紧张刺激的伦敦大战，多米尼克·托雷托（范·迪塞尔 Vin Diesel 饰）和他的伙伴们重新回归平静的生活，但是江湖的恩恩怨怨却决不允许他们轻易抽身而去。棘手的死对头欧文·肖瘫在医院，不得动弹，他的哥哥戴克·肖（杰森·斯坦森 Jason Stantham 饰）则发誓要为弟弟复仇。戴克曾是美国特种部队的王牌杀手，不仅身怀绝技，而且心狠手辣。他干掉了远在东...",
        "韩国一所武器工厂铀原料球秘密失窃，同一时间一架韩国飞机在中国东北坠毁，军方手提装置神秘失踪，这意味着一枚超级武器就此诞生，无人知晓它将在何时何地引爆。各国得到可靠情报，一名代号“赤道”（张震 饰）的国际头号通缉犯策划了此次窃案，此人十多年前曾潜入日本东京皇宫，成功盗走天皇三神器中的八咫玉成名。而这次“赤道”将与其头号副手信差（文咏珊 饰）在香港与恐怖组织交易...",
        "单纯美丽的李珥（陈都灵 饰）左耳失聪，无法听见声音，然而，生理上的缺陷并没有令她感到自卑，正相反，她的个性温顺又温柔。一次偶然中，李珥结识了名叫吧啦（马思纯 饰）的女孩，吧啦的个性和李珥截然相反，她无拘无束，桀骜不驯，向往自由的生活。在吧啦的身上，李珥看到了自己内心里叛逆执着的一面。 让李珥没有想到的是，吧啦竟然和自己一直暗恋的男生许戈（杨洋 饰）走到了一起...",
        "洗黑钱组织的一号人物李鸿声（林津锋 饰）一笔500万的黑钱被骷髅蒙面人抢劫，大为恼火，“先生”要求他务必尽快找到，否则人头不保。与此同时，黑社会头目程剑锋（韩秋池 饰）的儿子程成也遭人绑架，双方都去寻求大律师姜东（焦恩俊 饰）的帮助。而以给人拉杂货为生的“囧司机”梁昆（ 胡双泉 饰），恍然发现自己车内莫名其妙地多了500万，并且被神秘人跟踪…… 随着警探王维...",
        "在南疆围捕贩毒分子的行动中，特种部队狙击手冷锋（吴京 饰）公然违抗上级的命令，开枪射杀伤害了战友的暴徒武吉（周晓鸥 饰）。这一行动令冷锋遭到军方禁闭甚至强制退伍的处罚，不过各特种部队精英组成超级特种部队战狼中队的中队长龙小云（余男 饰），却十分欣赏这个敢作敢为且业务过硬的血性男儿，于是将其召入自己的麾下。在新近的一次演习中，冷锋凭借冷静的判断力从老首长处拔得...",
        "秋水（韩庚 饰），医科大学的学生，与厚朴（张博宇 饰）、黄芪（杨迪 饰）、辛夷（赵一维 饰）是死党，正值青春期的他盛荷尔蒙支配下异常生猛，不停地寻找着“猎食”对象。含苞待放的小满（李梦 饰）是秋水念念不忘的初恋；大腿紧实的白露（齐溪 饰）是与秋水互相奉献童贞的前任....",
        "托尼·斯塔克（小罗伯特·唐尼 Robert Downey Jr. 饰）试图重启一个已经废弃的维和项目，不料该项目却成为危机导火索。世上最强大的超级英雄——钢铁侠、美国队长（克里斯·埃文斯 Chris Evans 饰）、雷神（克里斯·海姆斯沃斯 Chris Hemsworth 饰）、绿巨人（马克·鲁弗洛 Mark Ruffalo 饰）、黑寡妇（斯嘉丽·约翰逊 Scarlett Johansson 饰）和鹰眼（杰瑞米·雷纳 Jeremy Renner 饰），不得不接受终极考验，拯救危在旦夕的地球。神秘反派奥创（詹姆斯·斯派德 James Spader 配音）逐渐崛起，超级英雄们必须重新集结，竭力阻止奥创实施人类灭绝计划。战斗中，复仇者联盟成员们还遇到",
        "贾古（安努舒卡·莎玛 Anushka Sharma 饰）和男友相恋多年，感情十分要好的两人终于决定步入婚姻的殿堂，然而，一场意外的突然降临让贾古所期望的一切都化为了泡影，因此，伤心欲绝的贾古决定返回家乡，成为了一名记者。"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return hotmovie.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! hotTableViewCell

        cell.title.text = "《\(hotmovie[indexPath.row])》"
        cell.detail.text = moviedetail[indexPath.row]
        var imgurl = NSURL(string: movieimg[indexPath.row])
        cell.img.sd_setImageWithURL(imgurl)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
