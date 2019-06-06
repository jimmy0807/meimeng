import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, Refresher, InfiniteScroll, LoadingController, ToastController, PopoverController } from 'ionic-angular';
import { VisitData, VisitNote, VisitFilter } from '../../providers/visit-data';
import { ApiResult } from '../../providers/api-http';
import { AppGlobal } from '../../app-global';

@IonicPage()
@Component({
  selector: 'page-visit-list',
  templateUrl: 'visit-list.html',
})
export class VisitList {
  list: VisitNote[] = [];
  groups = new Array();
  keys: string[] = [];
  infiniteEnabled = true;
  mid: number;
  mname: string;
  segment = 'all';
  myList: VisitNote[] = [];
  eid;
  keyword = '';
  myKeys: string[] = [];

  filters: VisitFilter = {};
  today: string;
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public popoverCtrl: PopoverController,
    public visitData: VisitData,
    public navParams: NavParams) {
    this.mid = navParams.data.mid;
    this.mname = navParams.data.mname;
    if (this.mname) {
      this.filters = { m: this.mname };
    }
    this.eid = AppGlobal.getInstance().user.eid;
    let d = new Date();
    this.today = `${d.getFullYear()}-${this.padZero(d.getMonth() + 1)}-${this.padZero(d.getDate())}`;
  }

  padZero(n) {
    return n < 10 ? '0' + String(n) : String(n);
  }

  async ngAfterViewInit() {
    await this.loadItems();
  }

  onInput(ev) {
  }

  onCancel(ev) {
    this.keyword = '';
  }

  groupItems(items: VisitNote[] = null) {
    if (!items) {
      this.groups = new Array();
      this.keys = [];
    }
    let g: VisitNote[] = this.groups;
    let arr = items || this.list;
    let key = '';
    for (var i = 0; i < arr.length; i++) {

      arr[i].isMine = arr[i].employee_id == this.eid;

      key = arr[i].plant_visit_date;
      if (g[key])
        g[key].push(arr[i]);
      else {
        g[key] = [arr[i]];
        this.keys.push(key);
      }
    }

    this.myKeys = this.keys.filter(k => g[k].some(v => v.isMine));
  }

  async loadItems() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles' });
    loader.present();
    try {
      await this.getItems();
    }
    finally {
      loader.dismiss();
    }
  }

  async getItems(offset = 0, append = false) {
    try {
      let r: ApiResult;
      r = await this.visitData.getVisitNotes(offset, this.filters);

      if (r.errcode === 0) {
        let arr = <any[]>r.data;
        this.infiniteEnabled = arr.length === 20;
        if (append) {
          for (var i = 0; i < arr.length; i++) {
            this.list.push(arr[i]);
          }
          this.groupItems(arr);
        }
        else {
          this.list = r.data;
          this.groupItems();
        }
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
  }

  async doRefresh(refresher: Refresher) {
    try {
      await this.getItems(0);
    }
    finally {
      refresher.complete();
    }
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      await this.getItems(this.list.length, true);
    }
    finally {
      infiniteScroll.complete();
    }
  }

  edit(i: VisitNote) {
    this.navCtrl.push('VisitAddPage', { vid: i.visit_id, note: i, list: this.list });
  }

  showPop(ev) {
    let popover = this.popoverCtrl.create('VisitPopoverPage', this);
    popover.onDidDismiss(async d => {
      if (d) {
        this.filters = d;
        await this.loadItems();
      }
    })
    popover.present({ ev: ev });
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
