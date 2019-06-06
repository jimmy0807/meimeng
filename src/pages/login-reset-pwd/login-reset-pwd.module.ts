import { NgModule } from '@angular/core';
import { IonicPageModule } from 'ionic-angular';
import { LoginResetPwdPage } from './login-reset-pwd';

@NgModule({
  declarations: [
    LoginResetPwdPage,
  ],
  imports: [
    IonicPageModule.forChild(LoginResetPwdPage),
  ],
  exports: [
    LoginResetPwdPage
  ]
})
export class LoginResetPwdPageModule {}
