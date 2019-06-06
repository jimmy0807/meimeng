import { Injectable } from '@angular/core';
import { ApiHttp, ApiResult } from './api-http';
@Injectable()
export class UserData {

  data: ApiResult;
  constructor(public http: ApiHttp) { }

  async login(data) {
    let body = new FormData();
    body.append('login', data.login);
    body.append('password', data.password);
    body.append('device', data.device);
    body.append('sign', data.sign);
    return this.http.PostAsync('common_login', body);
  }

  async logout() {
    return this.http.GetAsync('common_logout');
  }

  async saveToken(ds_jpush_registration_id, ds_jpush_alias) {
    let body = new FormData();
    body.append('ds_jpush_registration_id', ds_jpush_registration_id);
    body.append('ds_jpush_alias', ds_jpush_alias);
    return this.http.PostAsync('common_token', body);
  }

  async changePwd(oldpwd: string, newpwd: string) {
    let body = new FormData();
    body.append('old', oldpwd);
    body.append('new', newpwd);
    return this.http.PostAsync('change_password', body);
  }

  async getResetPwdToken(login: string) {
    var body = new FormData();
    body.append('login', login);
    return this.http.PostAsync('get_reset_pwd_token', body);
  }

  async resetPwd(login: string, token: string, password: string) {
    var body = new FormData();
    body.append('login', login);
    body.append('token', token);
    body.append('password', password);
    return this.http.PostAsync('reset_pwd', body);
  }
}
