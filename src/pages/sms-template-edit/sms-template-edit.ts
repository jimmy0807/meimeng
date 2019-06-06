import { Component } from '@angular/core';
import { NavController, NavParams, ViewController } from 'ionic-angular';
import { SmsEntity } from '../../providers/sms-data';

@Component({
  selector: 'page-sms-template-edit',
  templateUrl: 'sms-template-edit.html'
})
export class SmsTemplateEditPage {
  smsEntity: SmsEntity = {};
  lines: SmsLine[] = [];
  constructor(public navCtrl: NavController,
    public viewCtrl: ViewController,
    public navParams: NavParams) {
    this.smsEntity = navParams.data;
  }

  ngAfterViewInit() {
    if (!this.smsEntity.template)
      return;

    let contents = this.smsEntity.template.template_content.split(/\$?{.*?}/);
    let params = this.smsEntity.template.param_desc_ids;
    params.forEach(p => p.index = this.smsEntity.template.template_content.indexOf("{" + p.params_name + "}"));
    params.sort((a, b) => a.index - b.index);
    for (var i = 0; i < contents.length; i++) {
      this.lines.push(<SmsLine>{
        input: false,
        value: contents[i]
      })

      if (i < params.length) {
        let line: SmsLine = {
          input: true,
          desc: params[i].params_desc,
          param: params[i].params_name,
          value: ''
        };
        if (this.smsEntity.params && i < this.smsEntity.params.length)
          line.value = this.smsEntity.params[i]
        this.lines.push(line);
      }
    }
  }

  confirm() {
    this.smsEntity.content = this.lines.map(l => l.value).join('');
    this.smsEntity.params = this.lines.filter(l => l.input).map(l => l.value);
    this.viewCtrl.dismiss(true)
  }

  dismiss() {
    this.viewCtrl.dismiss(false);
  }
}

export interface SmsLine {
  input: boolean;
  desc?: string;
  param?: string;
  value?: string;
}
