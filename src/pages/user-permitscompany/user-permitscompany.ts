import { Component } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { ConsumerData } from '../../providers/consumer-data';

@Component({
  selector: 'page-user-permitscompany',
  templateUrl: 'user-permitscompany.html'
})
export class UserPermitscompanyPage {

  companys:any[];

  constructor(public navCtrl: NavController, public navParams: NavParams, public consumerData: ConsumerData) {}

  ionViewDidLoad() {
    // this.consumerData.getCompanyList().then(
    //   info=>{
    //     let data: any = info;
    //     if (data.errcode == 0) {
    //       this.companys = data.data;
    //     }
    //     else
    //     {
    //       alert("got shop" + this.companys.length)
    //     }
    //   },error=>{
    //     alert("got error")
    //   }
    // )
  }

}
