import { Component } from '@angular/core';
import { NavController, NavParams, ToastController, ViewController, ModalController } from 'ionic-angular';
import { Partner, PartnerData, PartnerCommission } from '../../providers/partner-data';
import { PartnerDetailImagePage } from '../partner-detail-image/partner-detail-image';
import { MedicalSelectorPage, SelectorType } from '../medical-selector/medical-selector';

@Component({
  selector: 'page-partner-detail',
  templateUrl: 'partner-detail.html'
})
export class PartnerDetailPage {
  p: Partner = {};
  list: Partner[] = [];
  editMode = false;
  title;
  segment = 'normal';
  coms: PartnerCommission[];
  keys = [];
  groups = new Array();
  cat_dict = {
    dl: '代理商',
    dd: '督导',
    dj: '店家',
  }
  constructor(public navCtrl: NavController,
    public toastCtrl: ToastController,
    public modalCtrl: ModalController,
    public viewCtrl: ViewController,
    public partnerData: PartnerData,
    public navParams: NavParams) {
    this.p = navParams.data.partner;
    this.list = navParams.data.list;

    this.editMode = this.p.id > 0;
    this.title = this.editMode ? "编辑" : "添加";
    if (!this.editMode) {
      this.p.partner_category = 'dj';
    }
  }

  async ngAfterViewInit() {
  }


  async tabChange() {
    if (this.p.id > 0 && !this.coms) {
      await this.getCommissions();
    }
  }

  async getCommissions() {
    try {
      let r = await this.partnerData.getPartnerCommission(this.p.id);
      if (r.errcode === 0) {
        this.coms = r.data;
        this.groupItems();
      }
    }
    catch (e) { }
  }

  groupItems(items: PartnerCommission[] = null) {
    if (!items) {
      this.groups = new Array();
      this.keys = [];
    }
    let g: PartnerCommission[] = this.groups;
    let arr = items || this.coms;
    let key = '';
    for (var i = 0; i < arr.length; i++) {
      key = arr[i].create_date;
      if (g[key])
        g[key].push(arr[i]);
      else {
        g[key] = [arr[i]];
        this.keys.push(key);
      }
    }
  }

  async save() {
    if (!this.p.name) {
      this.showToast('请输入名称');
      return;
    }
    if (!this.p.mobile) {
      this.showToast('请输入手机');
      return;
    }
    if (!/^1\d{10}$/.test(this.p.mobile)) {
      this.showToast('请输入正确的手机');
      return;
    }
    //if (this.p.partner_category === 'dj' && !this.p.city_region) {
    //  this.showToast('请选择区域');
    //  return;
    //}
    if (!this.p.sign_date) {
      this.showToast('请选择签约日期 ');
      return;
    }
    let r = await this.partnerData.saveBornPartner(this.p);
    this.showToast(r.errmsg);
    if (r.errcode === 0) {
      this.p.partner_category_name = this.cat_dict[this.p.partner_category];
      if (!this.editMode) {
        this.p.id = r.data.id;
        this.list.unshift(this.p);
      }
      this.viewCtrl.dismiss();
    }
  }

  select(type: string) {
    switch (type) {
      case 'partner':
        this.modalSelector(SelectorType.DL, true, d => {
          this.p.parent_id = d.id;
          this.p.parent_name = d.name;
        });
        break;
      case 'designer':
        this.modalSelector(SelectorType.Designer, true, d => {
          this.p.designer_employee_id = d.id;
          this.p.designer_employee_name = d.name;
        });
        break;
      case 'designers':
        this.modalSelector(SelectorType.Designer, false, d => {
          let arr: any[] = d;
          this.p.designer_employee_ids = arr;
          this.p.designer_employee_names = arr.map(a => a.name).join();
        });
        break;
      case 'business':
        this.modalSelector(SelectorType.Business, true, d => {
          this.p.business_employee_id = d.id;
          this.p.business_employee_name = d.name;
        });
        break;
      case 'dd_partner':
        this.modalSelector(SelectorType.DD, true, d => {
          this.p.dd_partner_id = d.id;
          this.p.dd_partner_name = d.name;
        });
        break;
      case 'dl_partner':
        this.modalSelector(SelectorType.DL, true, d => {
          this.p.dl_partner_id_1 = d.id;
          this.p.dl_partner_name_1 = d.name;
        });
        break;
      case 'dl_partner2':
        this.modalSelector(SelectorType.DL, true, d => {
          this.p.dl_partner_id_2 = d.id;
          this.p.dl_partner_name_2 = d.name;
        }, this.p.dl_partner_id_1);
        break;
      case 'dl_partner3':
        this.modalSelector(SelectorType.DL, true, d => {
          this.p.dl_partner_id_3 = d.id;
          this.p.dl_partner_name_3 = d.name;
        }, this.p.dl_partner_id_2);
        break;
    }
  }

  modalSelector(type: SelectorType, single: boolean, callback: Function, pid: number = undefined, ) {
    let m = this.modalCtrl.create(MedicalSelectorPage, { type: type, single: single, data: pid });
    m.onDidDismiss(data => {
      if (data)
        callback(data);
    });
    m.present();
  }

  addImage() {
    this.navCtrl.push(PartnerDetailImagePage, { p: this.p, img: {} });
  }

  async remove(img) {
    try {
      if (this.editMode) {
        let r = await this.partnerData.deletePartnerImage(img.id);
        this.showToast(r.errmsg);
        if (r.errcode === 0) {
          let index = this.p.image_ids.indexOf(img);
          this.p.image_ids.splice(index, 1);
        }
      }
      else {
        let index = this.p.image_ids.indexOf(img);
        this.p.image_ids.splice(index, 1);
      }
    } catch (e) {
      this.showToast();
    }
  }

  edit(img) {
    this.navCtrl.push(PartnerDetailImagePage, { p: this.p, img: img });
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }

  dismiss() {
    this.viewCtrl.dismiss();
  }
}
