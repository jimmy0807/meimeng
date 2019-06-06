import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalWorkflow } from './medical-workflow';

@NgModule({
  declarations: [
    MedicalWorkflow,
  ],
  imports: [
    IonicPageModule.forChild(MedicalWorkflow),
  ],
  exports: [
    MedicalWorkflow
  ]
})
export class MedicalWorkflowModule {}
