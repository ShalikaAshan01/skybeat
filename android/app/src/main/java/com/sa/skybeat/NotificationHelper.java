package com.sa.skybeat;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.graphics.Bitmap;

public class NotificationHelper {
    private static String title;
    private static String artist;
    private static Bitmap bitmap;
    private NotificationPanel notificationPanel;
    private static NotificationHelper notificationHelper;

    private NotificationHelper(){}

    public static NotificationHelper getInstance() {
        if(notificationHelper == null){
            notificationHelper = new NotificationHelper();
        }
        return notificationHelper;
    }

    public void setTitle(String title) {
        NotificationHelper.title = title;
    }

    public static void setArtist(String artist) {
        NotificationHelper.artist = artist;
    }

    public static void setBitmap(Bitmap bitmap) {
        NotificationHelper.bitmap = bitmap;
    }

    public void showNotification(Context context) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel("media_notification", "Media Notification", NotificationManager.IMPORTANCE_DEFAULT);
            channel.enableVibration(false);
            channel.setVibrationPattern(new long[]{0L});
            channel.setSound(null, null);
            NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
        this.notificationPanel = new NotificationPanel(context,title);
    }

    public void cancelNotification() {
        notificationPanel.notificationCancel();
    }
}