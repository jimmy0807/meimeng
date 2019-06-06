import { Component,ViewChild } from '@angular/core';
import { NavController, NavParams } from 'ionic-angular';
import { KpiData } from '../../providers/kpi-data';
import { ChartModule } from 'ng2-chartjs2';


@Component({
  selector: 'page-follow-member',
  templateUrl: 'follow-member.html'
})
export class FollowMemberPage {

  @ViewChild('chart') nchart: ChartModule;

  palnt: any;
  segment='shop';
  pos: {
    first_week_come_count?: number,
    second_week_come_count?: number,
    third_week_come_count?: number,
    forth_week_come_count?: number,
    last_month_come_day?: number,
    last_month_come_count?: number,
    month_come_day?: string,
    yye_amount?: number,
    czje_amount?: number,
    cpxs_amount?: number,
    hlxf_amount?: number,
    last_yye_amount?: number,
    last_czje_amount?: number,
    last_month_cpxs_amount?: number,
    last_hlxf_amount?: number,
    course_amount?: number,
    card_amount?: number,
    member_name?: string,
    follow_date?: string,
    period_name?: string,
    product_ids?:any,

  } = {};

  options: any = {
    type: 'bar',
    data: {
      labels: ["营业额", "充值额", "项目消耗", "产品销售"],
      datasets: [{
        label: '上月',
        data: [0,10,0,0],
        backgroundColor: "rgba(239,71,58,1)",
      },
      {
        label: '当月',
        data: [0,10,0,0],
        backgroundColor: "rgba(29,130,210,1)",
      }]
    },
    options: {
      responsive: true,
      legend: {
        position: 'top',
        labels: {
          boxWidth: 20
        }
      }
    }
  };


  constructor(
    public navCtrl: NavController,
    public navParams: NavParams,
    public kpiData: KpiData) {
    if (navParams.data) {
      this.palnt = navParams.data;
    }


  }

  ngAfterViewInit() {
    this.getMemberPos();
  }

  getMemberPos() {
    let param = {
      'pid': this.palnt.line_id
    };
    this.kpiData.getMemberPos(param).then(
      info => {
        let result: any = info;
        if (result.errcode === 0) {
          this.pos = result.data;
          this.options.data.datasets[0].data=[this.pos.last_yye_amount, this.pos.last_czje_amount, this.pos.last_month_cpxs_amount, this.pos.last_hlxf_amount];
          this.options.data.datasets[1].data=[this.pos.yye_amount, this.pos.czje_amount, this.pos.cpxs_amount, this.pos.hlxf_amount];
          let d:any=this.nchart;
          let dx=d.chart;
          dx.update();
      }
      }
    )
  }



}
