import {Injectable} from '@angular/core';
import {Http, Response} from '@angular/http';
import {AppGlobal} from '../app-global';
import 'rxjs/add/operator/toPromise';


@Injectable()
export class ApiHttp {
  constructor(public http: Http) {
  }

  get sid() {
    return AppGlobal.getInstance().sid;
  }

  get cid() {
    return AppGlobal.getInstance().user.company_id;
  }

  get api() {
    return AppGlobal.getInstance().api;
  }

  get uid() {
    return AppGlobal.getInstance().user.uid;
  }

  get duuid() {
    return AppGlobal.getInstance().duuid;
  }

  get cuuid() {
    return AppGlobal.getInstance().cuuid;
  }

  get top_api() {
    return AppGlobal.getInstance().top_api;
  }


  public async GetAsync(action: string, params: any = null): Promise<ApiResult> {
    let url = this.getUrl(action, params);
    return this.Get(url);
  }

  public async GetTopAsync(action: string, params: any = null): Promise<ApiResult> {

    let url = this.getTopUrl(action, params);
    return this.Get(url);
  }

  public async PostTopAsync(action: string, body: FormData, params: any = null): Promise<ApiResult> {
    let url = this.getTopUrl(action, params);
    return this.Post(url, body);
  }


  public async Get(url: string): Promise<ApiResult> {
    try {
      let res = await this.http.get(url).toPromise();
      return res.json();
    }
    catch (e) {
      return this.handleError(e);
    }
  }

  handleError(e: Response) {
    let msg = '网络异常 ';
    if (e.status)
      msg += `(${e.status})`;
    return <ApiResult>{errcode: 1, errmsg: msg};
  }

  public async PostAsync(action: string, body: FormData, params: any = null): Promise<ApiResult> {
    let url = this.getUrl(action, params);
    return this.Post(url, body);
  }

  public async Post(url, body: FormData): Promise<ApiResult> {
    try {
      let res = await this.http.post(url, body).toPromise();
      return res.json();
    }
    catch (e) {
      return this.handleError(e);
    }
  }

  private getUrl(action: string, params: any) {
    let url = this.api + "/api/" + action + "?";
    if (params) {
      let key: string;
      for (key in params)
        url += key + "=" + params[key] + "&";
    }
    if (url.slice(-1) === '&') {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  private getTopUrl(action: string, params: any) {
    let url = this.top_api + "/api/" + action + "?";
    if (params) {
      let key: string;
      for (key in params)
        url += key + "=" + params[key] + "&";
    }
    if (url.slice(-1) === '&') {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }


  public appendStrings(body: FormData, obj: any, keys: string[],) {
    keys.forEach(k => {
      if (obj[k])
        body.append(k, String(obj[k]));
    })
  }

  public appendBooleans(body: FormData, obj: any, keys: string[],) {
    keys.forEach(k => {
      body.append(k, String(obj[k] ? 1 : 0));
    })
  }

  public async CallDsApi(method: string, args: any): Promise<ApiResult> {
    let url = this.api;
    let index = url.lastIndexOf('/') + 1;
    let rpc = url.substr(0, index) + "jsonrpc";
    let db = url.substr(index);

    let request: Object = {
      jsonrpc: "2.0",
      method: "call",
      params: {
        method: method,
        service: "ds_api",
        args: [db, args]
      }
    }
    return new Promise(resolve => {
      this.http.post(rpc, request).subscribe(
        res => {
          let obj: RpcResponse = res.json()
          resolve(obj.result);
        },
        err => {
          resolve(<ApiResult>{errcode: 1, errmsg: '网络异常'});
        })
    });
  }

  Error(msg: string): ApiResult {
    return {
      errcode: 1,
      errmsg: msg
    };
  }
}

export interface Params {
  method: string;
  service: string;
  args: any[];
}

export interface RpcRequest {
  jsonrpc: string;
  method: string;
  params: Params;
}

export interface RpcResponse {
  jsonrpc: string;
  id?: any;
  result: ApiResult;
}

export interface ApiResult {
  errcode?: number;
  errmsg?: string;
  data?: any;
}
