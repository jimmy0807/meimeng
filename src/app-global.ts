import * as CryptoJS from 'crypto-js'

export class AppGlobal {

  private static instance: AppGlobal = new AppGlobal();
  version: string = "2.0"
  isDebug: boolean = true;
  server: string = "";
  db: string = "";
  api: string = "http://dev.we-erp.com:8066/V9N00000034";
  zimgServerUrl: string = "http://devimg.we-erp.com/";
  // api: string = "/V9N00000025";
  networkType: string = "";
  pageSize: number = 10;
  isNetworkConnect: boolean = true;
  longitude: number = 0;
  latitude: number = 0;
  banners: any[];
  user: User;
  shops: any;
  sid: number;
  groupMedical: boolean;
  userGroup: UserInfo;
  appGroup: AppGroup;
  isCordova = true;
  duuid: string = "";
  cuuid: string = "";
  top_api: string = "";
  AES_KEY: string = "";

  constructor() {
    if (AppGlobal.instance) {
      throw new Error("错误: 请使用AppGlobal.getInstance() 代替使用new.");
    }
    AppGlobal.instance = this;
  }

  public static getInstance(): AppGlobal {
    return AppGlobal.instance;
  }
}

export interface User {
  uid?: number;
  name?: string;
  login?: string;
  sid?: number;
  eid?: number;
  ename?: string;
  ecat?: string;
  book_time?: number;
  role?: string;
  role_name?: string;
  head?: string;
  shop_name?: string;
  security_id?: any;
  company_id?: number;
  is_accept_see_partner?: boolean;
  is_audit_authority?: boolean;
  user_group?: UserInfo;
}

export class AppGroup {
  app_member = false;
  app_reservation = false;
  app_commission = false;
  app_visit = false;
  app_partner = false;
  app_authorization = false;
  app_device_access = false;
  app_report = false;
  app_partner_commission = false;
  app_event = false;
  app_charge = false;
  app_achievement = false;
  app_photo = false;

  constructor(keys: string[] = null) {
    if (keys) {
      for (var i = 0; i < keys.length; i++) {
        this[keys[i]] = true;
      }
    }
    else {
      let k: string;
      for (k in this)
        this[k] = true;
    }
  }
}

export interface UserInfo {
  id?: number;
  login?: string;
  is_accept_notice?: boolean;
  sel_groups_23_24?: string;
  sel_groups_1_2_3?: string;
  sel_groups_9_34_10?: string;
  is_accept_push?: boolean;
  in_group_55?: boolean;
  in_group_6?: boolean;
  is_allow_login?: boolean;
  role_option?: string;
  sel_groups_110?: string;
  sel_groups_47_48?: string;
  sel_groups_52_53_54?: string;
  in_group_84?: boolean;
  sel_groups_4_104_44_45?: string;
  sel_groups_95_101_96?: string;
  sel_groups_94?: string;
  sel_groups_103_104?: string;
  sel_groups_99_100?: string;
}

export class Utils {

  private static util: Utils = new Utils();

  public static utf8_strlen(str) {
    var cnt = 0;

    for (var i = 0; i < str.length; i++) {

      var value = str.charCodeAt(i);

      if (value < 0x080) {
        cnt += 1;

      } else if (value < 0x0800) {
        cnt += 2;
      } else {
        cnt += 3;
      }
    }
    return cnt;

  }

  public static randomString(len) {

    len = len || 32;
    var $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
    var maxPos = $chars.length;
    var pwd = '';
    for (var i = 0; i < len; i++) {
      pwd += $chars.charAt(Math.floor(Math.random() * maxPos));
    }
    return pwd;
  }

  public static getTimestamp() {
    return Math.round(new Date().getTime() / 1000);
  }

  //解码
  public static Encrypt(word, skey) {

    if (!word) {
      word = '';
    }
    var length = Utils.utf8_strlen(word), padLength = (16 - length % 16) % 16;

    for (var i = 0; i < padLength; i++) {

      word += ' ';
    }

    var key = CryptoJS.enc.Utf8.parse(skey);

    var srcs = CryptoJS.enc.Utf8.parse(word);
    var encrypted = CryptoJS.AES.encrypt(srcs, key, {mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.ZeroPadding});
    return encrypted.toString();
  }

  //编码
  public static Decrypt(word, skey) {

    var key = CryptoJS.enc.Utf8.parse(skey);

    var decrypt = CryptoJS.AES.decrypt(word, key, {mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.ZeroPadding});
    return CryptoJS.enc.Utf8.stringify(decrypt).toString();
  }
}
