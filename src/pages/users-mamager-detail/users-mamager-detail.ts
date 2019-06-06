import { Component } from '@angular/core';
import { NavController, NavParams, ViewController, ToastController, ModalController } from 'ionic-angular';
import { ConsumerData, ConsumerLists } from '../../providers/consumer-data';
import { UserPermitshopPage } from '../user-permitshop/user-permitshop';
import { CompanyPage } from '../company/company';

@Component({
  selector: 'page-users-mamager-detail',
  templateUrl: 'users-mamager-detail.html'
})
export class UsersMamagerDetailPage {
  userInfo: any;
  consumer: ConsumerLists = {};
  consumer_old = {};
  arr_role = new Array();
  companylist = [];
  shoplist = [];
  mode = 'view';
  is_changepwd = false;
  is_saved = false;
  constructor(public viewCtrl: ViewController,
    public navCtrl: NavController,
    public toastCtrl: ToastController,
    public modalCtrl: ModalController,
    public navParams: NavParams,
    public consumerData: ConsumerData) {
    if (navParams.data.id > 0) {
      // console.log(navParams);
      // console.log('编辑');
      this.consumer = navParams.data;
      this.mode = 'view';
      this.info_backup(this.consumer_old, this.consumer);
    }
    else {
      //console.log('新增');
      this.mode = 'new';
    }

  }

  ionViewDidLoad() {
    this.get_companylist();
    this.get_shopLists();
  }
  ionViewWillLeave() {
    if (!this.is_saved) {
      this.info_recover(this.consumer_old, this.consumer);
      this.is_saved = false;
    }

  }
  // updateUserInfo
  editConsumerData() {
    if (this.mode == 'view')
      this.mode = 'edit';
    else if (this.mode == 'edit')
      this.mode = 'view';
  }

  // updateUserInfo
  updateConsumerData() {
    if (this.consumer.name === undefined || this.consumer.name === "") {
      this.showToastWithCloseButton("用户名不能为空");
      return;
    }
    if (this.consumer.login === undefined || this.consumer.login === "") {
      this.showToastWithCloseButton("登陆账号不能为空");
      return;
    }
    if (this.consumer.login.length != 11 && this.consumer.login) {
      this.showToastWithCloseButton("登陆账号格式错误");
      return;
    }
    if (this.consumer.role_option === undefined || this.consumer.role_option === "") {
      this.showToastWithCloseButton("用户角色不能为空");
      return;
    }
    if (this.consumer.company_id === undefined || this.consumer.company_id === 0) {
      this.showToastWithCloseButton("公司不能为空");
      return;
    }
    if (this.is_changepwd || this.mode == 'new') {
      if (this.consumer.password === undefined || this.consumer.password === "") {
        this.showToastWithCloseButton("密码不能为空");
        return;
      }
    }
    else {
      this.consumer.password = "";
    }
    if (this.mode == 'view')
      this.mode = 'edit';
    else if (this.mode == 'edit') {
      this.mode = 'view';
      if (this.info_equal(this.consumer_old, this.consumer)) {
        this.showToastWithCloseButton("没有任何改动");

        return;
      }
    }
    // else if (this.mode == 'new') {
    //   //this.showToastWithCloseButton("新建还没做完");
    //   // console.log(this.consumer);
    //   //return;
    // }

    this.consumerData.updateConsumerData(this.consumer).then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          console.log(data.data.id);
          this.consumer.id = data.data.id;
          this.info_backup(this.consumer_old, this.consumer);
          this.showToastWithCloseButton("保存成功");
          this.mode = 'view';
          this.is_saved = true;
        } else {
          //show error message
          this.showToastWithCloseButton(data.errmsg);
        }
      },
      err => {
        //show error message
        this.showToastWithCloseButton("系统繁忙");
      }
    )
  }
  get_companylist() {
    // console.log("get_companylist");
    this.consumerData.get_companylist().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.companylist = data.data;
          // console.log(this.companylist);
        } else {
          this.showToastWithCloseButton(data.errmsg);
        }
      },
      err => {
        this.showToastWithCloseButton("系统繁忙");
      }
    )
  }
  get_shopLists() {
    this.consumerData.get_shopLists().then(
      info => {
        let data: any = info;
        if (data.errcode == 0) {
          this.shoplist = data.data;

        } else {
          this.showToastWithCloseButton(data.errmsg)
        }
      },
      err => {
        this.showToastWithCloseButton("系统繁忙");
      }
    )

  }
  change_password() {
    this.is_changepwd = !this.is_changepwd;
  }
  //delete this function
  showCompany() {

    this.navCtrl.push(CompanyPage);

  }

  showShop() {
    let modal = this.modalCtrl.create(UserPermitshopPage, [this.consumer.shop_ids, this.shoplist, this.consumer.shop_id, this.mode]);
    modal.onDidDismiss(data => {
      if (data != undefined) {
        let ids = [];
        // let names = [];
        data.forEach(function (e) {
          ids.push({ id: e.id });
        })
        this.consumer.shop_ids = ids;
        // console.log("consumer_shop_ids", this.consumer.shop_ids);
        // this.reservation.product_ids = ids;
        // this.reservation.product_names = names.join();
      }
    });
    modal.present();
    // add param
    // console.log(this.consumer.shop_ids);
    // let shops = [];
    // let arr_shop_ids = this.consumer.shop_ids;
    // console.log("arr_shop_ids", arr_shop_ids);
    // this.shoplist.forEach(function (e) {
    //   e.active = false;
    // });
    // for (var i = 0; i < Object(arr_shop_ids).length; i++)
    //   shops.push(arr_shop_ids[i]);
    // shops.forEach(id_a => {
    //   this.shoplist.forEach(id_b => {
    //     if (id_a.id == id_b.id)
    //       id_b.active = true;
    //   });
    // });
    // console.log("shoplist", this.shoplist);
    // this.navCtrl.push(UserPermitshopPage, [this.consumer.shop_ids, this.shoplist, this.mode]);
  }

  info_backup(data1, data2) {

    for (var name in data2) {
      data1[name] = data2[name];
    }
    //console.log(data1);
  }

  info_recover(data1, data2) {
    for (var name in data1) {
      data2[name] = data1[name];
    }
    //console.log(data2);
  }

  info_equal(data1, data2) {
    // console.log("data_old", data1);
    // console.log("data_new", data2);
    for (var name in data1) {
      // console.log(name + ":" + data2[name] + "," + data1[name].id);
      if (data2[name] != data1[name])
        return false;
    }
    return true;
  }
  shopid_selected(event, data) {
    // console.log("ionChange", data);
    //更换允许门店shop_ids的必选项
    let flag = false;
    if (this.mode == 'new') {
      this.consumer.shop_ids = [{ id: data }];
      // console.log("新建", this.consumer);
    }
    else {
      this.consumer_old["shop_ids"].forEach(function (e) {
        // console.log(e["id"]);
        if (e["id"] == data) {
          flag = true;
        }

      });
      if (!flag)
        this.consumer_old["shop_ids"].push({ id: data });//不知为何this.consumer的shop_ids也跟着变化
    }


  }
  showToastWithCloseButton(errcmsg) {
    const toast = this.toastCtrl.create({
      message: errcmsg,
      duration: 3000
    });
    toast.present();
  }

}
