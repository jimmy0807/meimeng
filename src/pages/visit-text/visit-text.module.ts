import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { VisitTextPage } from './visit-text';

@NgModule({
  declarations: [
    VisitTextPage,
  ],
  imports: [
    IonicPageModule.forChild(VisitTextPage),
  ],
  exports: [
    VisitTextPage
  ]
})
export class VisitTextPageModule {}
