import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { VisitList } from './visit-list';

@NgModule({
  declarations: [
    VisitList,
  ],
  imports: [
    IonicPageModule.forChild(VisitList),
  ],
  exports: [
    VisitList
  ]
})
export class VisitListModule {}
