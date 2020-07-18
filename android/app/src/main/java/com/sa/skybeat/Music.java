package com.sa.skybeat;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import io.flutter.Log;

public class Music {
    private int songId;
    private String name;
    private String path;
    private String albumName;
    private String albumArt;
    private int albumId;
    private String artistName;
    private int duration;
    private int year;
    private String track;
    private String date_added;
    private String date_modified;
    private String size;
    private String title;

    public Music(int songId, String name, String path, String albumName, int albumId, String albumArt, String artistName, int duration, int year, String track, String date_added, String date_modified,String size, String tile) {
        this.songId = songId;
        this.name = name;
        this.path = path;
        this.albumName = albumName;
        this.albumArt = albumArt;
        this.albumId = albumId;
        this.artistName = artistName;
        this.duration = duration;
        this.year = year;
        this.track = track;
        this.date_added = date_added;
        this.date_modified = date_modified;
        this.size = size;
        this.title = tile;
    }

    HashMap<String, Object> toMap() {
        HashMap<String,Object> map = new HashMap<>();
        map.put("songId", songId);
        map.put("name", name);
        map.put("title", title);
        map.put("path", path);
        map.put("albumName", albumName);
        map.put("albumArt", albumArt);
        map.put("albumId", albumId);
        map.put("artistName", artistName);
        map.put("duration", duration);
        map.put("year", year);
        map.put("track", track);
        map.put("size", size);
        map.put("date_added", date_added);
        map.put("date_modified", date_modified);
        return map;
    }

    public String getPath() {
        return path;
    }

    Music(){}
    Music fromJSON(String json){
        try {
            JSONObject map = new JSONObject(json);
            this.songId = map.getInt("songId");
            this.name = map.getString("name");
            this.path = map.getString("path");
            this.title = map.getString("title");
            this.albumName = map.getString("albumName");
            this.albumArt = map.getString("albumArt");
            this.albumId = map.getInt("albumId");
            this.artistName = map.getString("artistName");
            this.duration = map.getInt("duration");
            this.year = map.getInt("year");
            this.track = map.getString("track");
            this.date_added = map.getString("dateAdded");
            this.date_modified = map.getString("dateModified");
            this.size = map.getString("size");
        } catch (JSONException e) {
            Log.d("error",e.getMessage());
        }
        return this;
    }
}
