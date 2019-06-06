import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { ApiResult } from './api-http';
import { AppGlobal } from '../app-global';
import 'rxjs/add/operator/toPromise';

@Injectable()
export class ZimgProvider {

  private server = "http://devimg.we-erp.com/";
  private uploadUrl: string;

  constructor(public http: Http) {
    let s = AppGlobal.getInstance().zimgServerUrl;
    if (!s.endsWith('/'))
      s = s + '/';
    this.server = s
    this.uploadUrl = this.server + 'upload';
  }

  async uploadBase64(base: string): Promise<Result> {
    try {
      let b = this.base64toBlob(base);
      let resp = await this.http.post(this.uploadUrl, b).toPromise();
      let data: Result = resp.json();
      if (data.ret)
        data.url = this.server + data.info.md5;
      return data;
    }
    catch (e) {
      let r: Response = e;
      return {
        ret: false,
        error: {
          code: r.status,
          message: r.statusText
        }
      };
    }
  }

  private base64toBlob(base64: string, contentType = 'jpeg', sliceSize = 512) {
    let data = base64.split(',')
    let byteCharacters = atob(data.pop());
    let byteArrays = [];

    for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
      let slice = byteCharacters.slice(offset, offset + sliceSize);
      let byteNumbers = new Array(slice.length);
      for (var i = 0; i < slice.length; i++) {
        byteNumbers[i] = slice.charCodeAt(i);
      }

      let byteArray = new Uint8Array(byteNumbers);

      byteArrays.push(byteArray);
    }
    let blob = new Blob(byteArrays, { type: contentType });
    return blob;
  }

  Error(str = null): ApiResult {
    return {
      errcode: 1,
      errmsg: str || '图片上传失败,请重试'
    };
  }
}

export interface Info {
  md5?: string;
  size?: number;
}

export interface Error {
  code?: number;
  message?: string;
}

export interface Result {
  ret?: boolean;
  info?: Info;
  error?: Error;
  url?: string;
}

