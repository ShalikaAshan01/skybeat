package com.sa.skybeat;

import android.content.ContentResolver;
import android.database.Cursor;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.provider.MediaStore;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.Log;

public class MusicFinder {
    private ContentResolver managedQuery;

    private ArrayList<HashMap> musicList;
    public MusicFinder(ContentResolver managedQuery) {
        this.managedQuery = managedQuery;
        this.musicList = new ArrayList<>();
    }
    private void fetchAllMp3s(){
        Uri uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
        String selection = MediaStore.Audio.Media.IS_MUSIC + " != 0";
        Cursor cursor = managedQuery.query(uri, null, selection, null, null);
        Music music;
        if(cursor !=null){
            if(cursor.moveToFirst()){

                do{
                    String name = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DISPLAY_NAME));
                    String title = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.TITLE));
                    String path = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DATA));
                    String albumName = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.ALBUM));
                    String artistName = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.ARTIST));
                    String track = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.TRACK));
                    String date_added = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DATE_ADDED));
                    String date_modified = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.DATE_MODIFIED));
                    String size = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Media.SIZE));

                    int albumId = cursor.getInt(cursor.getColumnIndex(MediaStore.Audio.Media.ALBUM_ID));
                    int songId = cursor.getInt(cursor.getColumnIndex(MediaStore.Audio.Media._ID));
                    int duration = cursor.getInt(cursor.getColumnIndex(MediaStore.Audio.Media.DURATION));
                    int year = cursor.getInt(cursor.getColumnIndex(MediaStore.Audio.Media.YEAR));
                    String albumArt = getAlbumArt(albumId);

                    if(!name.contains(".mp3"))
                        continue;

                    music = new  Music(songId, name, path, albumName, albumId, albumArt, artistName, duration, year, track, date_added, date_modified,size,title);
                    this.musicList.add(music.toMap());


                } while (cursor.moveToNext());
            }
            cursor.close();
        }
    }

    public HashMap<String, Object> fetchLocalMusic(String filePath){

        MediaMetadataRetriever mediaMetadataRetriever = new MediaMetadataRetriever();
        mediaMetadataRetriever.setDataSource(filePath);
        HashMap<String,Object> hashMap = new HashMap<>();
        try {
            String album = mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ALBUM);
            String artist = mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ARTIST);
            String title = mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_TITLE);
//            Bitmap image = mediaMetadataRetriever.getPrimaryImage();

            if(title.isEmpty())
                title = "unknown";
            hashMap.put("title",title);
            hashMap.put("artist",artist);
            hashMap.put("album",album);
        }catch (Exception e){
            Log.d("skybeat-error", e.getMessage());
        }

        return hashMap;
    }


    private String getAlbumArt(int albumId) {
        Cursor cursor = managedQuery.query(MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                new String[]{MediaStore.Audio.Albums._ID, MediaStore.Audio.Albums.ALBUM_ART},
                MediaStore.Audio.Albums._ID + "=?",
                new String[]{String.valueOf(albumId)},
                null);
        if (cursor.moveToFirst()) {
            return cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Albums.ALBUM_ART));
        }else return "";
    }
    public ArrayList<HashMap> getMusicList() {
        fetchAllMp3s();
        return musicList;
    }
}
