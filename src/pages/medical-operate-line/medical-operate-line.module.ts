import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalOperateLine } from './medical-operate-line';

@NgModule({
  declarations: [
    MedicalOperateLine,
  ],
  imports: [
    IonicPageModule.forChild(MedicalOperateLine),
  ],
  exports: [
    MedicalOperateLine
  ]
})
export class MedicalOperateLineModule {}
