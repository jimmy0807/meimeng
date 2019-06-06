import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController, ModalController } from 'ionic-angular';
import { MemberMedicalInfo, MemberData } from '../../providers/member-data';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@IonicPage()
@Component({
  selector: 'page-member-analysis',
  templateUrl: 'member-analysis.html',
})
export class MemberAnalysisPage {
  info: MemberMedicalInfo = {};
  mid: number;
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public modalCtrl: ModalController,
    public memberData: MemberData,
    public navParams: NavParams) {
    this.mid = navParams.data;
  }

  async ngAfterViewInit() {
    try {
      let r = await this.memberData.getMemberMedicalInfo(this.mid);
      if (r.errcode === 0) {
        this.info = r.data;
        this.info.beauty_names = this.info.be_beauty_ids.map(l => l.name).join(', ');
        this.info.character_names = this.info.be_character_ids.map(l => l.name).join(', ');
        this.info.consumption_names = this.info.be_consumption_ids.map(l => l.name).join(', ');
        this.info.interest_names = this.info.be_interest_ids.map(l => l.name).join(', ');
        this.info.attention_names = this.info.be_attention_ids.map(l => l.name).join(', ');
      }
    }
    catch (e) {
      this.showToast();
    }
  }

  async save() {
    try {
      let r = await this.memberData.saveMemberMedicalInfo(this.info);
      this.showToast(r.errmsg);
    }
    catch (e) {
      this.showToast();
    }
  }


  select(type: string) {
    switch (type) {
      case 'bea':
        this.modalSelector(SelectorType.MemberBeauty, false, d => {
          this.info.be_beauty_ids = d
          this.info.beauty_names = this.info.be_beauty_ids.map(l => l.name).join(', ');
        });
        break;
      case 'cha':
        this.modalSelector(SelectorType.MemberCharacter, false, d => {
          this.info.be_character_ids = d
          this.info.character_names = this.info.be_character_ids.map(l => l.name).join(', ');
        });
        break;
      case 'con':
        this.modalSelector(SelectorType.MemberConsumption, false, d => {
          this.info.be_consumption_ids = d
          this.info.consumption_names = this.info.be_consumption_ids.map(l => l.name).join(', ');
        });
        break;
      case 'int':
        this.modalSelector(SelectorType.MemberInterest, false, d => {
          this.info.be_interest_ids = d
          this.info.interest_names = this.info.be_interest_ids.map(l => l.name).join(', ');
        });
        break;
      case 'att':
        this.modalSelector(SelectorType.MemberAttention, false, d => {
          this.info.be_attention_ids = d
          this.info.attention_names = this.info.be_attention_ids.map(l => l.name).join(', ');
        });
        break;
    }
  }

  modalSelector(type: SelectorType, single: boolean, callback: Function) {
    let m = this.modalCtrl.create(MedicalSelectorPage, { type: type, single: single });
    m.onDidDismiss(data => {
      if (data)
        callback(data);
    });
    m.present();
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
