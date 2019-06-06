import { Component } from '@angular/core';
import { NavController, NavParams, ViewController} from 'ionic-angular';
import { AppGlobal } from '../../app-global';
import { ShopData } from '../../providers/shop-data';
import { ShopManagerDetailPage } from '../shop-manager-detail/shop-manager-detail';

@Component({
  selector: 'page-shop-manager',
  templateUrl: 'shop-manager.html'
})
export class ShopManagerPage {
 user_role:string='';
  shops: any[];
  constructor(public navCtrl: NavController,
   public navParams: NavParams,
   public viewCtrl: ViewController,
   public shopData: ShopData) {
      this.user_role = AppGlobal.getInstance().user.role;
   }

  ngAfterViewInit() {
    this.shops = AppGlobal.getInstance().shops;
  }

  itemSelected(item) {
    this.navCtrl.push(ShopManagerDetailPage, {"shop":item, "finishCallback":shop => {
      for (var i=0;i<this.shops.length;i++)
      {
        var _shop = this.shops[i];
        if ( _shop.id == shop.id )
        {
          this.shops.splice(i,1,shop);
          break;
        }
      }
    }});
  }

  addShop()
  {
    this.navCtrl.push(ShopManagerDetailPage, {"shop":{}, "finishCallback":shop => {
      this.shops.splice(0,0,shop);
    }});
  }
}
