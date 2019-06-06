import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalBed } from './medical-bed';

@NgModule({
  declarations: [
    MedicalBed,
  ],
  imports: [
    IonicPageModule.forChild(MedicalBed),
  ],
  exports: [
    MedicalBed
  ]
})
export class MedicalBedModule {}
