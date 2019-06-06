import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalBedDetail } from './medical-bed-detail';

@NgModule({
  declarations: [
    MedicalBedDetail,
  ],
  imports: [
    IonicPageModule.forChild(MedicalBedDetail),
  ],
  exports: [
    MedicalBedDetail
  ]
})
export class MedicalBedDetailModule {}
