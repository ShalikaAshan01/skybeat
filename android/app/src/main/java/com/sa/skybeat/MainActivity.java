package com.sa.skybeat;

import android.content.ContentResolver;
import android.os.Bundle;
import android.widget.Toast;

import java.util.HashMap;
import java.util.Observable;
import java.util.concurrent.TimeUnit;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "sa.flutter.dev/music";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        if(call.method.equals("getAllMusicAsList")){
                            ContentResolver cr = getApplicationContext().getContentResolver();
                            MusicFinder musicFinder = new MusicFinder(cr);
                            result.success(musicFinder.getMusicList());
                        }else{
                            final MethodChannel channel = new MethodChannel(getFlutterView(), CHANNEL);
                            AudioPlayer audioPlayer = AudioPlayer.getInstance(channel);
                            switch (call.method){
                                case "play":
                                    String url = ((HashMap) call.arguments()).get("url").toString();
                                    audioPlayer.play(getApplicationContext(), url);
                                    result.success(1);
                                    break;
                                case "pause":
                                    result.success(audioPlayer.pause());
                                    break;
                                case "currentPosition":
                                    result.success(audioPlayer.currentPosition());
                                    break;
                                case "seek":
                                    int milliseconds = Integer.parseInt(((HashMap) call.arguments()).get("milliseconds").toString());
                                    audioPlayer.seek(milliseconds);
                                    result.success(1);
                                    break;
                                    default:
                                        result.notImplemented();
                            }

                        }
                    }
                });
    }
}
