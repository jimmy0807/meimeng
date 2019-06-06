import { Component } from '@angular/core';
import { NavController, NavParams, InfiniteScroll, ViewController } from 'ionic-angular';
import { KpiData } from '../../providers/kpi-data';

@Component({
  selector: 'page-kpi-featured',
  templateUrl: 'kpi-featured.html'
})

export class KpiFeaturedPage {

  holdProducts: any = [];
  products: any = [];
  keyword: string = '';
  currentDate: any;

  constructor(
    public navParams: NavParams,
    public navCtrl: NavController,
    public kpiData: KpiData,
    public viewCtrl: ViewController) {
    if (navParams.data) {
      this.currentDate = navParams.data;
    }
  }

  ngAfterViewInit() {
    if (this.currentDate) {
      this.getFollowProduct(0);
    }
  }

  getFollowProduct(offset) {
    this.kpiData.getFollowProduct(this.currentDate, offset, this.keyword).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.products = data.data;
          this.holdProducts = this.products;
        }
      },
      error => {
      }
    )
  }

  onConfirm() {
    let selected: any = []
    this.products.forEach(function (e) {
      if (e.checked) {
        selected.push(e)
      }
      e.checked = false;
    })
    if (selected.length <= 0) {
      alert('请至少选择一个服务项目');
      return;
    }
    this.viewCtrl.dismiss(selected);
  }

  onInput(ev) {
    this.products = this.holdProducts;
    let val = ev.target.value;
    this.keyword = val;
    this.getFollowProduct(0);

  }

  onCancel(ev) {
    this.keyword = '';
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.kpiData.getFollowProduct(this.currentDate, this.products.length, this.keyword).then((newData) => {
      let data: any = newData;
      if (data.errcode === 0) {
        let newData = data.data;
        for (var i = 0; i < newData.length; i++) {
          this.products.push(newData[i]);
        }
      }
      infiniteScroll.complete();
    });
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
