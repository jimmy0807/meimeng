import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalWard } from './medical-ward';

@NgModule({
  declarations: [
    MedicalWard,
  ],
  imports: [
    IonicPageModule.forChild(MedicalWard),
  ],
  exports: [
    MedicalWard
  ]
})
export class MedicalWardModule {}
