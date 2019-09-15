package com.wampinfotech.be_marvellous;

import android.graphics.PixelFormat;
import android.view.Window;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  /** Called when the activity is first created. */
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    // setContentView(R.layout.main);
    // StartAnimations();
    GeneratedPluginRegistrant.registerWith(this);
  }

  public void onAttachedToWindow() {
    super.onAttachedToWindow();
    Window window = getWindow();
    window.setFormat(PixelFormat.RGBA_8888);
  }

  private void StartAnimations() {
      Animation anim = AnimationUtils.loadAnimation(this, R.anim.alpha);
      anim.reset();
      LinearLayout l=(LinearLayout) findViewById(R.id.lin_lay);
      l.clearAnimation();
      l.startAnimation(anim);

      anim = AnimationUtils.loadAnimation(this, R.anim.translate);
      anim.reset();
      ImageView iv = (ImageView) findViewById(R.id.logo);
      iv.clearAnimation();
      iv.startAnimation(anim);

  }
}
