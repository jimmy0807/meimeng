import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalOperate } from './medical-operate';

@NgModule({
  declarations: [
    MedicalOperate,
  ],
  imports: [
    IonicPageModule.forChild(MedicalOperate),
  ],
  exports: [
    MedicalOperate
  ]
})
export class MedicalOperateModule {}
