import { Component } from '@angular/core';
import { NavController, NavParams, InfiniteScroll, ToastController, ViewController } from 'ionic-angular';
import { MemberData } from '../../providers/member-data';

@Component({
  selector: 'page-member',
  templateUrl: 'member.html'
})
export class MemberPage {
  keyword = '';
  members: any = [];
  members_new: any = [];
  members_normal: any = [];
  members_vip: any = [];
  members_mvp: any = [];
  constructor(public navCtrl: NavController,
    public navParams: NavParams,
    public memberData: MemberData,
    public toastCtrl: ToastController,
    public viewCtrl: ViewController) { }

  ionViewDidLoad() {
  }

  ngAfterViewInit() {
    this.getMemberList(0, '');
  }

  getMemberList(offset: number, key) {
    this.memberData.getMemberList(offset, key).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.members = data.data;
          this.filterMembers();
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

  filterMembers() {
    let list = this.members;
    this.members_new = list.filter(m => m.member_level === 'new');
    this.members_normal = list.filter(m => m.member_level === 'normal' || m.member_level === false);
    this.members_vip = list.filter(m => m.member_level === 'vip');
    this.members_mvp = list.filter(m => m.member_level === 'mvp');
  }

  onInput(ev) {
    let val = ev.target.value;
    this.keyword = val;
    this.getMemberList(0, val);
  }

  onCancel(ev) {
    this.keyword = '';
  }

  doInfinite(infiniteScroll: InfiniteScroll) {
    this.memberData.getMemberList(this.members.length, this.keyword).then(
      (newData) => {
        let data: any = newData;
        if (data.errcode === 0) {
          let newItems = data.data;
          for (var i = 0; i < newItems.length; i++) {
            this.members.push(newItems[i]);
          }
          this.filterMembers();
        }
        else {
          this.showToast(data.errmsg);
        }
        infiniteScroll.complete();
      },
      err => this.showToast());
  }

  onSelectMember(item) {
    this.viewCtrl.dismiss(item);
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss(){
    this.viewCtrl.dismiss();
  }
}
