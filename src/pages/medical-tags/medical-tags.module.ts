import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { MedicalTags } from './medical-tags';

@NgModule({
  declarations: [
    MedicalTags,
  ],
  imports: [
    IonicPageModule.forChild(MedicalTags),
  ],
  exports: [
    MedicalTags
  ]
})
export class MedicalTagsModule {}
