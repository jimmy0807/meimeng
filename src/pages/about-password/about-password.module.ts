import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { AboutPasswordPage } from './about-password';

@NgModule({
  declarations: [
    AboutPasswordPage,
  ],
  imports: [
    IonicPageModule.forChild(AboutPasswordPage),
  ],
  exports: [
    AboutPasswordPage
  ]
})
export class AboutPasswordPageModule {}
