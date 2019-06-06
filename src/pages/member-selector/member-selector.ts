import { Component } from '@angular/core';
import { NavController, NavParams, InfiniteScroll, ToastController, ViewController } from 'ionic-angular';
import { MemberData, Member } from '../../providers/member-data';

@Component({
  selector: 'page-member-selector',
  templateUrl: 'member-selector.html'
})
export class MemberSelectorPage {
  keyword = '';
  //single,multiple
  mode = '';
  filter = '';
  items: Member[] = [];
  infiniteEnabled = true;

  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public memberData: MemberData,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController) {
    this.mode = navParams.data.mode;
    this.filter = navParams.data.filter;
  }

  ngAfterViewInit() {
    this.getMemberList(0, '');
  }

  getMemberList(offset: number, key) {
    this.memberData.getMemberList(offset, key, null, true).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.items = data.data;
          this.infiniteEnabled = data.data.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
      },
      err => {
        this.showToast();
      }
    )
  }

  onInput(ev) {
    this.getMemberList(0, this.keyword);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.memberData.getMemberList(this.items.length, this.keyword, null, true).then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.items.push(newItems[i]);
          }
          this.infiniteEnabled = data.data.length == 20;
        }
        else {
          this.showToast(data.errmsg);
        }
        infiniteScroll.complete();
      },
      err => this.showToast());
  }

  onSelected(item) {
    this.viewCtrl.dismiss(item);
  }

  save() {
    let members = this.items.filter(m => m.checked);
    this.viewCtrl.dismiss(members)
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }
}
