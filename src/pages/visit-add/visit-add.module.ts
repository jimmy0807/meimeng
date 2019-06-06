import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { VisitAddPage } from './visit-add';

@NgModule({
  declarations: [
    VisitAddPage,
  ],
  imports: [
    IonicPageModule.forChild(VisitAddPage),
  ],
  exports: [
    VisitAddPage
  ]
})
export class VisitAddPageModule {}
