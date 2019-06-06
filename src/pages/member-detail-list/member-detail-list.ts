import { Component } from '@angular/core';
import { NavController, NavParams, Refresher, ToastController, InfiniteScroll, LoadingController, ActionSheetController } from 'ionic-angular';
import { MemberData } from '../../providers/member-data';
import { ApiResult } from '../../providers/api-http';
import { VisitPage } from '../visit/visit';
import { VisitData, Visit } from '../../providers/visit-data';
import { Camera } from '@ionic-native/camera';

@Component({
  selector: 'page-member-detail-list',
  templateUrl: 'member-detail-list.html'
})
export class MemberDetailListPage {
  r: ApiResult;
  infiniteEnabled = true;
  mode;
  mid;
  title;
  items: any[] = [];

  currentItem: {
    images?: any[]
  };
  currentImg: {
    operate_id: number,
    member_id: number,
    take_time: string,
    image?: string
  }

  constructor(public navCtrl: NavController,
    public memberData: MemberData,
    public camera: Camera,
    public asCtrl: ActionSheetController,
    public toastCtrl: ToastController,
    public loadingCtrl: LoadingController,
    public visitData: VisitData,
    public navParams: NavParams) {
    this.mode = navParams.data.mode;
    this.mid = navParams.data.mid;

    switch (this.mode) {
      case 'vis': this.title = '回访记录'; break;
      case 'ext': this.title = '会员特征'; break;
      case 'rel': this.title = '家庭亲友'; break;
      case 'img': this.title = '术前/后照'; break;
      case 'ope': this.title = '操作明细'; break;
      case 'sta': this.title = '金额变动明细'; break;
      case 'poi': this.title = '积分明细'; break;
      case 'com': this.title = '会员佣金明细'; break;
      case 'pro': this.title = '销售明细'; break;
      case 'rec': this.title = '病历卡'; break;
      case 'car': this.title = '卡内项目'; break;
    }
  }

  async ngAfterViewInit() {
    let loader = this.loadingCtrl.create({ spinner: 'bubbles', });
    loader.present();
    try {
      let r = await this.switchAction(0);
      if (r.errcode == 0) {
        this.items = r.data;
        this.infiniteEnabled = this.items.length === 10;
      }
      else {
        this.showToast(r.errmsg);
      }
    }
    catch (e) {
      this.showToast();
    }
    finally {
      loader.dismiss();
    }
  }

  async switchAction(offset) {
    switch (this.mode) {
      case 'vis': return this.memberData.getMemberVisits(this.mid, offset);
      case 'ext': return this.memberData.getMemberExtendedss(this.mid, offset);
      case 'rel': return this.memberData.getMemberRelatives(this.mid, offset);
      case 'img': return this.memberData.getMemberImages(this.mid, offset);
      case 'ope': return this.memberData.getMemberOperates(this.mid, offset);
      case 'sta': return this.memberData.getMemberStatements(this.mid, offset);
      case 'poi': return this.memberData.getMemberPoints(this.mid, offset);
      case 'com': return this.memberData.getMemberCommissions(this.mid, offset);
      case 'pro': return this.memberData.getMemberProductLines(this.mid, offset);
      case 'rec': return this.memberData.getMemberMedicalRecord(this.mid);
      case 'car': return this.memberData.getMemberCardProducts(this.mid);
    }
  }

  showVisit(i: Visit) {
    this.navCtrl.push(VisitPage, { v: i });
  }

  showImage(i, img) {
    let p = {
      imgs: i.images.map(i => i.image_url),
      index: i.images.indexOf(img),
    }
    this.navCtrl.push('ImageSlidesPage', p);
  }

  async doRefresh(refresher: Refresher) {
    try {
      let r = await this.switchAction(0);
      if (r.errcode == 0) {
        this.items = r.data;
        this.infiniteEnabled = this.items.length === 10;
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
    finally {
      refresher.complete();
    }
  }

  async doInfinite(infiniteScroll: InfiniteScroll) {
    try {
      let r = await this.switchAction(this.items.length);
      if (r.errcode == 0) {
        let arr: any[] = r.data;
        for (var i = 0; i < arr.length; i++) {
          this.items.push(arr[i]);
        }
        this.infiniteEnabled = arr.length === 10;
      }
      else {
        this.showToast(r.errmsg);
      }
    } catch (e) {
      this.showToast();
    }
    finally {
      infiniteScroll.complete();
    }
  }

  addImage(item, time) {
    this.currentItem = item;
    this.currentImg = {
      operate_id: item.id,
      member_id: this.mid,
      take_time: time
    };
    this.getImage();
  }

  getImage() {
    let actionSheet = this.asCtrl.create({
      buttons: [{
        text: '拍照',
        handler: () => this.takePhoto()
      },
      {
        text: '选择照片',
        handler: () => this.selectPhoto()
      },
      {
        text: '取消',
        role: 'cancel',
      }]
    });
    actionSheet.present();
  }

  takePhoto() {
    this.camera.getPicture({
      destinationType: this.camera.DestinationType.DATA_URL,
      sourceType: this.camera.PictureSourceType.CAMERA,
      allowEdit: true,
      encodingType: this.camera.EncodingType.JPEG,
    }).then(
      (imageData) => { this.saveImage(imageData) },
      (err) => this.showToast(err));
  }

  selectPhoto() {
    this.camera.getPicture({
      destinationType: this.camera.DestinationType.DATA_URL,
      sourceType: this.camera.PictureSourceType.PHOTOLIBRARY,
      mediaType: this.camera.MediaType.PICTURE,
      allowEdit: false,
      encodingType: this.camera.EncodingType.JPEG,
    }).then(
      (imageData) => { this.saveImage(imageData) },
      (err) => this.showToast(err));
  }

  async saveImage(data) {
    this.currentImg.image = data;
    try {
      var r = await this.memberData.saveMemberImage(this.currentImg);
      this.showToast(r.errmsg);
      if (r.errcode == 0) {
        this.currentItem.images.push(r.data);
      }
    } catch (e) {
      this.showToast();
    }
  }

  showToast(msg = '系统繁忙') {
    const toast = this.toastCtrl.create({
      message: msg,
      duration: 3000
    });
    toast.present();
  }
}
