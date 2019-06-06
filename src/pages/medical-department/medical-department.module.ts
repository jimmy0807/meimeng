import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalDepartment } from './medical-department';

@NgModule({
  declarations: [
    MedicalDepartment,
  ],
  imports: [
    IonicPageModule.forChild(MedicalDepartment),
  ],
  exports: [
    MedicalDepartment
  ]
})
export class MedicalDepartmentModule {}
