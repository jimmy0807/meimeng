import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalType } from './medical-type';

@NgModule({
  declarations: [
    MedicalType,
  ],
  imports: [
    IonicPageModule.forChild(MedicalType),
  ],
  exports: [
    MedicalType
  ]
})
export class MedicalTypeModule {}
