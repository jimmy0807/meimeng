import { Component } from '@angular/core';
import { NavController ,ViewController} from 'ionic-angular';

import { AppGlobal } from '../../app-global';

@Component({
  selector: 'page-shop',
  templateUrl: 'shop.html'
})
export class ShopPage {

  shops: any[];
  sid:number=0;
  constructor(public navCtrl: NavController, public viewCtrl: ViewController,) { }

  ionViewDidLoad() {
    this.shops = AppGlobal.getInstance().shops;
    this.sid=AppGlobal.getInstance().sid;
  }

  itemSelected(item){
    AppGlobal.getInstance().sid=item.id;
    let data = { 'change': true,'shop':item };
     this.viewCtrl.dismiss(data);
  }

   dismiss() {
     let data = { 'change': false };
     this.viewCtrl.dismiss(data);
  }
}
