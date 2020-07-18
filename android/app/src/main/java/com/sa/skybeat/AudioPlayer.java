package com.sa.skybeat;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;

import android.os.Build;
import android.os.Handler;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import java.util.HashMap;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

public class AudioPlayer{
    private static MediaPlayer mMediaPlayer;
    private static AudioPlayer audioPlayer;
    private static Handler handler = new Handler();
    private static MethodChannel channel;
    private static String path = "unknown";

    private AudioPlayer(){}

    public static AudioPlayer getInstance(MethodChannel mChannel){
        channel = mChannel;
        if(audioPlayer == null)
            return audioPlayer = new AudioPlayer();
        return audioPlayer;
    }


    public void stop() {
        if (mMediaPlayer != null) {
            mMediaPlayer.stop();
            mMediaPlayer.release();
            mMediaPlayer = null;
            handler.removeCallbacks(sendData);
        }
    }

    public void play(Context context, String name) {
        if(mMediaPlayer == null || !path.equals(name)){
            path = name;
            stop();
            mMediaPlayer = new MediaPlayer();
            mMediaPlayer = MediaPlayer.create(context, Uri.parse(name));
        }

        NotificationHelper notificationHelper = NotificationHelper.getInstance();

        mMediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mediaPlayer) {
                stop();
                channel.invokeMethod("audio.onComplete", true);
//                notificationHelper.cancelNotification();
            }
        });
        mMediaPlayer.start();

        MusicFinder musicFinder = new MusicFinder(context.getContentResolver());
        HashMap map = musicFinder.fetchLocalMusic(name);
        notificationHelper.setTitle((String) map.get("title"));
//        notificationHelper.showNotification(context);

        handler.post(sendData);
    }

    public int pause(){
        if(mMediaPlayer != null){
            mMediaPlayer.pause();
            handler.removeCallbacks(sendData);
            return mMediaPlayer.getCurrentPosition();
        }
        else return 0;
    }

    public void seek(int milliseconds){
        mMediaPlayer.seekTo(milliseconds);
    }

    public int currentPosition(){
        return mMediaPlayer.getCurrentPosition();
    }

    private final Runnable sendData = new Runnable() {
        public void run() {
            try {
                if (!mMediaPlayer.isPlaying()) {
                    handler.removeCallbacks(sendData);
                }
                int time = mMediaPlayer.getCurrentPosition();
                channel.invokeMethod("audio.onCurrentPosition", time);
                handler.postDelayed(this, 200);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };
}
