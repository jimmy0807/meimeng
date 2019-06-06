import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalOperateDetail } from './medical-operate-detail';

@NgModule({
  declarations: [
    MedicalOperateDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalOperateDetail),
  ],
  exports: [
    MedicalOperateDetail
  ]
})
export class MedicalOperateDetailModule {}
