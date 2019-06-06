import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, Refresher, InfiniteScroll, LoadingController, ToastController } from 'ionic-angular';
import { MemberPrepare, MemberData } from '../../providers/member-data';

@IonicPage()
@Component({
  selector: 'page-member-prepare',
  templateUrl: 'member-prepare.html',
})
export class MemberPreparePage {
  list: MemberPrepare[] = [];
  infiniteEnabled = true;
  mid: number;
  name: string;
  constructor(public navCtrl: NavController,
    public loadingCtrl: LoadingController,
    public toastCtrl: ToastController,
    public memberData: MemberData,
    public navParams: NavParams) {
    this.mid = navParams.data.id;
    this.name = navParams.data.name;
  }

  async ngAfterViewInit() {
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
      let r = await this.memberData.getMemberPrepares(this.mid, offset);
      if (r.errcode === 0) {
        let arr = <any[]>r.data;
        this.infiniteEnabled = arr.length === 20;
        if (append) {
          for (var i = 0; i < arr.length; i++) {
            this.list.push(arr[i]);
          }
        }
        else {
          this.list = r.data;
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

  edit(i: MemberPrepare) {
    this.navCtrl.push('MemberPrepareAddPage', { p: i, list: this.list });
  }

  add() {
    this.navCtrl.push("MemberPrepareAddPage", { p: <MemberPrepare>{ member_id: this.mid, member_name: this.name }, list: this.list });
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
