package com.sa.skybeat;

import android.app.Activity;
import android.os.Bundle;

import io.flutter.Log;

public class NotificationReturnSlot extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String action = (String) getIntent().getExtras().get("DO");
        if (action.equals("volume")) {
            Log.i("NotificationReturnSlot", "volume");
            //Your code
        } else if (action.equals("stopNotification")) {
            //Your code
            Log.i("NotificationReturnSlot", "stopNotification");
        }
        finish();
    }
}