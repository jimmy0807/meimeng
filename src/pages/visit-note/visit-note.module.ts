import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { VisitNotePage } from './visit-note';

@NgModule({
  declarations: [
    VisitNotePage,
  ],
  imports: [
    IonicPageModule.forChild(VisitNotePage),
  ],
  exports: [
    VisitNotePage
  ]
})
export class VisitNotePageModule {}
