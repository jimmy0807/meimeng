import { Component } from '@angular/core';
import { NavController, NavParams, ViewController } from 'ionic-angular';
import { KpiData } from '../../providers/kpi-data';
@Component({
  selector: 'page-kpi-featured-detail',
  templateUrl: 'kpi-featured-detail.html'
})
export class KpiFeaturedDetailPage {

   sale: {
    id?: number,
    product_name?: string,
    list_price?: string,
    sale_cnt?: number,
    price_unit?: string,
    total_amount?: number,
     period_name?:string,
  } = {};

  product: any;
  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
    public kpiData: KpiData,
    public viewCtrl: ViewController) {
    if (navParams.data) {
      this.product = navParams.data;
    }
  }

   ngAfterViewInit() {
      this.getProductSaleinfo(0);
  }

  getProductSaleinfo(offset) {
    let params={
      'pid':this.product.product_id,
      'fid': this.product.id,
    }
    this.kpiData.getProductSaleinfo(params).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.sale = data.data;
        }
      },
      error => {
      }
    )
  }

  cancel() {
    let data = {
      'pid': this.product.product_id,
      'fid': this.product.id,
    };
    this.kpiData.cancelFeaturedProduct(data).then(
      info => {
        let data: any = info;
        if (data.errcode === 0) {
          this.viewCtrl.dismiss(data);
        }
      }
    )
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }

}
