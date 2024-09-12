package com.abarobotics.bt_handheld;

import static android.content.ContentValues.TAG;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.IntentSender;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.UserHandle;
import android.util.Log;
import android.view.Display;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import com.rscja.deviceapi.RFIDWithUHFBLE;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.interfaces.ConnectionStatus;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private SearchHandler searchHandler;
    private ConnectHandler connectHandler;
    private ScanHandler scanHandler;
    private KeyHandler keyHandler;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        RFIDWithUHFBLE uhfReader = RFIDWithUHFBLE.getInstance();
        uhfReader.init(this);

        searchHandler = new SearchHandler(flutterEngine, uhfReader);
        connectHandler = new ConnectHandler(flutterEngine, uhfReader);
        scanHandler = new ScanHandler(this, flutterEngine, uhfReader);
        keyHandler = new KeyHandler(flutterEngine, uhfReader);

        searchHandler.init();
        connectHandler.init();
        scanHandler.init();
        keyHandler.init();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_CONNECT}, 1);
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        searchHandler.destroy();
        connectHandler.destroy();
        scanHandler.destroy();
        keyHandler.destroy();
    }
}

class SearchHandler extends Context implements EventChannel.StreamHandler {
    private static final String SEARCH_EVENT_CHANNEL = "handheld.event.search";
    private EventChannel searchEventChannel;
    private final FlutterEngine flutterEngine;
    private final RFIDWithUHFBLE uhfReader;
    private EventChannel.EventSink eventSink;
    private boolean stopFlag = false;

    SearchHandler(FlutterEngine flutterEngine, RFIDWithUHFBLE uhfReader) {
        this.flutterEngine = flutterEngine;
        this.uhfReader = uhfReader;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
        uhfReader.startScanBTDevices((bluetoothDevice, i, bytes) -> {
            final HashMap<String, String> device = new HashMap<>();
            device.put("address", bluetoothDevice.getAddress());
            Log.d("address","address bluetooth:"+bluetoothDevice.getAddress());
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.
                return;
            }
            device.put("name", bluetoothDevice.getName());
            Log.d("name","name bluetooth:"+bluetoothDevice.getName());
            if (!stopFlag) {
                eventSink.success(device);
                stopFlag = false;
            }
        });
    }

    @Override
    public void onCancel(Object arguments) {
        uhfReader.stopScanBTDevices();
        stopFlag = true;
        eventSink = null;
    }

    public void init() {
        searchEventChannel = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), SEARCH_EVENT_CHANNEL);
        searchEventChannel.setStreamHandler(this);
    }

    public void destroy() {
        searchEventChannel.setStreamHandler(null);
    }

    /**
     * @return
     */
    @Override
    public AssetManager getAssets() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public Resources getResources() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public PackageManager getPackageManager() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public ContentResolver getContentResolver() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public Looper getMainLooper() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public Context getApplicationContext() {
        return null;
    }

    /**
     * @param resid The style resource describing the theme.
     */
    @Override
    public void setTheme(int resid) {

    }

    /**
     * @return
     */
    @Override
    public Resources.Theme getTheme() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public ClassLoader getClassLoader() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public String getPackageName() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public ApplicationInfo getApplicationInfo() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public String getPackageResourcePath() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public String getPackageCodePath() {
        return null;
    }

    /**
     * @param name Desired preferences file.
     * @param mode Operating mode.
     * @return
     */
    @Override
    public SharedPreferences getSharedPreferences(String name, int mode) {
        return null;
    }

    /**
     * @param sourceContext The source context which contains the existing
     *                      shared preferences to move.
     * @param name          The name of the shared preferences file.
     * @return
     */
    @Override
    public boolean moveSharedPreferencesFrom(Context sourceContext, String name) {
        return false;
    }

    /**
     * @param name The name (unique in the application package) of the shared
     *             preferences file.
     * @return
     */
    @Override
    public boolean deleteSharedPreferences(String name) {
        return false;
    }

    /**
     * @param name The name of the file to open; can not contain path
     *             separators.
     * @return
     * @throws FileNotFoundException
     */
    @Override
    public FileInputStream openFileInput(String name) throws FileNotFoundException {
        return null;
    }

    /**
     * @param name The name of the file to open; can not contain path
     *             separators.
     * @param mode Operating mode.
     * @return
     * @throws FileNotFoundException
     */
    @Override
    public FileOutputStream openFileOutput(String name, int mode) throws FileNotFoundException {
        return null;
    }

    /**
     * @param name The name of the file to delete; can not contain path
     *             separators.
     * @return
     */
    @Override
    public boolean deleteFile(String name) {
        return false;
    }

    /**
     * @param name The name of the file for which you would like to get
     *             its path.
     * @return
     */
    @Override
    public File getFileStreamPath(String name) {
        return null;
    }

    /**
     * @return
     */
    @Override
    public File getDataDir() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public File getFilesDir() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public File getNoBackupFilesDir() {
        return null;
    }

    /**
     * @param type The type of files directory to return. May be {@code null}
     *             for the root of the files directory or one of the following
     *             constants for a subdirectory:
     *             {@link android.os.Environment#DIRECTORY_MUSIC},
     *             {@link android.os.Environment#DIRECTORY_PODCASTS},
     *             {@link android.os.Environment#DIRECTORY_RINGTONES},
     *             {@link android.os.Environment#DIRECTORY_ALARMS},
     *             {@link android.os.Environment#DIRECTORY_NOTIFICATIONS},
     *             {@link android.os.Environment#DIRECTORY_PICTURES}, or
     *             {@link android.os.Environment#DIRECTORY_MOVIES}.
     * @return
     */
    @Nullable
    @Override
    public File getExternalFilesDir(@Nullable String type) {
        return null;
    }

    /**
     * @param type The type of files directory to return. May be {@code null}
     *             for the root of the files directory or one of the following
     *             constants for a subdirectory:
     *             {@link android.os.Environment#DIRECTORY_MUSIC},
     *             {@link android.os.Environment#DIRECTORY_PODCASTS},
     *             {@link android.os.Environment#DIRECTORY_RINGTONES},
     *             {@link android.os.Environment#DIRECTORY_ALARMS},
     *             {@link android.os.Environment#DIRECTORY_NOTIFICATIONS},
     *             {@link android.os.Environment#DIRECTORY_PICTURES}, or
     *             {@link android.os.Environment#DIRECTORY_MOVIES}.
     * @return
     */
    @Override
    public File[] getExternalFilesDirs(String type) {
        return new File[0];
    }

    /**
     * @return
     */
    @Override
    public File getObbDir() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public File[] getObbDirs() {
        return new File[0];
    }

    /**
     * @return
     */
    @Override
    public File getCacheDir() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public File getCodeCacheDir() {
        return null;
    }

    /**
     * @return
     */
    @Nullable
    @Override
    public File getExternalCacheDir() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public File[] getExternalCacheDirs() {
        return new File[0];
    }

    /**
     * @return
     */
    @Override
    public File[] getExternalMediaDirs() {
        return new File[0];
    }

    /**
     * @return
     */
    @Override
    public String[] fileList() {
        return new String[0];
    }

    /**
     * @param name Name of the directory to retrieve.  This is a directory
     *             that is created as part of your application data.
     * @param mode Operating mode.
     * @return
     */
    @Override
    public File getDir(String name, int mode) {
        return null;
    }

    /**
     * @param name    The name (unique in the application package) of the database.
     * @param mode    Operating mode.
     * @param factory An optional factory class that is called to instantiate a
     *                cursor when query is called.
     * @return
     */
    @Override
    public SQLiteDatabase openOrCreateDatabase(String name, int mode, SQLiteDatabase.CursorFactory factory) {
        return null;
    }

    /**
     * @param name         The name (unique in the application package) of the database.
     * @param mode         Operating mode.
     * @param factory      An optional factory class that is called to instantiate a
     *                     cursor when query is called.
     * @param errorHandler the {@link DatabaseErrorHandler} to be used when
     *                     sqlite reports database corruption. if null,
     *                     {@link android.database.DefaultDatabaseErrorHandler} is
     *                     assumed.
     * @return
     */
    @Override
    public SQLiteDatabase openOrCreateDatabase(String name, int mode, SQLiteDatabase.CursorFactory factory, @Nullable DatabaseErrorHandler errorHandler) {
        return null;
    }

    /**
     * @param sourceContext The source context which contains the existing
     *                      database to move.
     * @param name          The name of the database file.
     * @return
     */
    @Override
    public boolean moveDatabaseFrom(Context sourceContext, String name) {
        return false;
    }

    /**
     * @param name The name (unique in the application package) of the
     *             database.
     * @return
     */
    @Override
    public boolean deleteDatabase(String name) {
        return false;
    }

    /**
     * @param name The name of the database for which you would like to get
     *             its path.
     * @return
     */
    @Override
    public File getDatabasePath(String name) {
        return null;
    }

    /**
     * @return
     */
    @Override
    public String[] databaseList() {
        return new String[0];
    }

    /**
     * @return
     */
    @Override
    public Drawable getWallpaper() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public Drawable peekWallpaper() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public int getWallpaperDesiredMinimumWidth() {
        return 0;
    }

    /**
     * @return
     */
    @Override
    public int getWallpaperDesiredMinimumHeight() {
        return 0;
    }

    /**
     * @param bitmap
     * @throws IOException
     */
    @Override
    public void setWallpaper(Bitmap bitmap) throws IOException {

    }

    /**
     * @param data
     * @throws IOException
     */
    @Override
    public void setWallpaper(InputStream data) throws IOException {

    }

    /**
     * @throws IOException
     */
    @Override
    public void clearWallpaper() throws IOException {

    }

    /**
     * @param intent The description of the activity to start.
     */
    @Override
    public void startActivity(Intent intent) {

    }

    /**
     * @param intent  The description of the activity to start.
     * @param options Additional options for how the Activity should be started.
     *                May be null if there are no options.  See {@link android.app.ActivityOptions}
     *                for how to build the Bundle supplied here; there are no supported definitions
     *                for building it manually.
     */
    @Override
    public void startActivity(Intent intent, @Nullable Bundle options) {

    }

    /**
     * @param intents An array of Intents to be started.
     */
    @Override
    public void startActivities(Intent[] intents) {

    }

    /**
     * @param intents An array of Intents to be started.
     * @param options Additional options for how the Activity should be started.
     *                See {@link android.content.Context#startActivity(Intent, Bundle)}
     *                Context.startActivity(Intent, Bundle)} for more details.
     */
    @Override
    public void startActivities(Intent[] intents, Bundle options) {

    }

    /**
     * @param intent       The IntentSender to launch.
     * @param fillInIntent If non-null, this will be provided as the
     *                     intent parameter to {@link IntentSender#sendIntent}.
     * @param flagsMask    Intent flags in the original IntentSender that you
     *                     would like to change.
     * @param flagsValues  Desired values for any bits set in
     *                     <var>flagsMask</var>
     * @param extraFlags   Always set to 0.
     * @throws IntentSender.SendIntentException
     */
    @Override
    public void startIntentSender(IntentSender intent, @Nullable Intent fillInIntent, int flagsMask, int flagsValues, int extraFlags) throws IntentSender.SendIntentException {

    }

    /**
     * @param intent       The IntentSender to launch.
     * @param fillInIntent If non-null, this will be provided as the
     *                     intent parameter to {@link IntentSender#sendIntent}.
     * @param flagsMask    Intent flags in the original IntentSender that you
     *                     would like to change.
     * @param flagsValues  Desired values for any bits set in
     *                     <var>flagsMask</var>
     * @param extraFlags   Always set to 0.
     * @param options      Additional options for how the Activity should be started.
     *                     See {@link android.content.Context#startActivity(Intent, Bundle)}
     *                     Context.startActivity(Intent, Bundle)} for more details.  If options
     *                     have also been supplied by the IntentSender, options given here will
     *                     override any that conflict with those given by the IntentSender.
     * @throws IntentSender.SendIntentException
     */
    @Override
    public void startIntentSender(IntentSender intent, @Nullable Intent fillInIntent, int flagsMask, int flagsValues, int extraFlags, @Nullable Bundle options) throws IntentSender.SendIntentException {

    }

    /**
     * @param intent The Intent to broadcast; all receivers matching this
     *               Intent will receive the broadcast.
     */
    @Override
    public void sendBroadcast(Intent intent) {

    }

    /**
     * @param intent             The Intent to broadcast; all receivers matching this
     *                           Intent will receive the broadcast.
     * @param receiverPermission (optional) String naming a permission that
     *                           a receiver must hold in order to receive your broadcast.
     *                           If null, no permission is required.
     */
    @Override
    public void sendBroadcast(Intent intent, @Nullable String receiverPermission) {

    }

    /**
     * @param intent             The Intent to broadcast; all receivers matching this
     *                           Intent will receive the broadcast.
     * @param receiverPermission (optional) String naming a permissions that
     *                           a receiver must hold in order to receive your broadcast.
     *                           If null, no permission is required.
     */
    @Override
    public void sendOrderedBroadcast(Intent intent, @Nullable String receiverPermission) {

    }

    /**
     * @param intent             The Intent to broadcast; all receivers matching this
     *                           Intent will receive the broadcast.
     * @param receiverPermission String naming a permissions that
     *                           a receiver must hold in order to receive your broadcast.
     *                           If null, no permission is required.
     * @param resultReceiver     Your own BroadcastReceiver to treat as the final
     *                           receiver of the broadcast.
     * @param scheduler          A custom Handler with which to schedule the
     *                           resultReceiver callback; if null it will be
     *                           scheduled in the Context's main thread.
     * @param initialCode        An initial value for the result code.  Often
     *                           Activity.RESULT_OK.
     * @param initialData        An initial value for the result data.  Often
     *                           null.
     * @param initialExtras      An initial value for the result extras.  Often
     *                           null.
     */
    @Override
    public void sendOrderedBroadcast(@NonNull Intent intent, @Nullable String receiverPermission, @Nullable BroadcastReceiver resultReceiver, @Nullable Handler scheduler, int initialCode, @Nullable String initialData, @Nullable Bundle initialExtras) {

    }

    /**
     * @param intent The intent to broadcast
     * @param user   UserHandle to send the intent to.
     */
    @Override
    public void sendBroadcastAsUser(Intent intent, UserHandle user) {

    }

    /**
     * @param intent             The Intent to broadcast; all receivers matching this
     *                           Intent will receive the broadcast.
     * @param user               UserHandle to send the intent to.
     * @param receiverPermission (optional) String naming a permission that
     *                           a receiver must hold in order to receive your broadcast.
     *                           If null, no permission is required.
     */
    @Override
    public void sendBroadcastAsUser(Intent intent, UserHandle user, @Nullable String receiverPermission) {

    }

    /**
     * @param intent             The Intent to broadcast; all receivers matching this
     *                           Intent will receive the broadcast.
     * @param user               UserHandle to send the intent to.
     * @param receiverPermission String naming a permissions that
     *                           a receiver must hold in order to receive your broadcast.
     *                           If null, no permission is required.
     * @param resultReceiver     Your own BroadcastReceiver to treat as the final
     *                           receiver of the broadcast.
     * @param scheduler          A custom Handler with which to schedule the
     *                           resultReceiver callback; if null it will be
     *                           scheduled in the Context's main thread.
     * @param initialCode        An initial value for the result code.  Often
     *                           Activity.RESULT_OK.
     * @param initialData        An initial value for the result data.  Often
     *                           null.
     * @param initialExtras      An initial value for the result extras.  Often
     *                           null.
     */
    @Override
    public void sendOrderedBroadcastAsUser(Intent intent, UserHandle user, @Nullable String receiverPermission, BroadcastReceiver resultReceiver, @Nullable Handler scheduler, int initialCode, @Nullable String initialData, @Nullable Bundle initialExtras) {

    }

    /**
     * @param intent The Intent to broadcast; all receivers matching this
     *               Intent will receive the broadcast, and the Intent will be held to
     *               be re-broadcast to future receivers.
     */
    @Override
    public void sendStickyBroadcast(Intent intent) {

    }

    /**
     * @param intent         The Intent to broadcast; all receivers matching this
     *                       Intent will receive the broadcast.
     * @param resultReceiver Your own BroadcastReceiver to treat as the final
     *                       receiver of the broadcast.
     * @param scheduler      A custom Handler with which to schedule the
     *                       resultReceiver callback; if null it will be
     *                       scheduled in the Context's main thread.
     * @param initialCode    An initial value for the result code.  Often
     *                       Activity.RESULT_OK.
     * @param initialData    An initial value for the result data.  Often
     *                       null.
     * @param initialExtras  An initial value for the result extras.  Often
     *                       null.
     */
    @Override
    public void sendStickyOrderedBroadcast(Intent intent, BroadcastReceiver resultReceiver, @Nullable Handler scheduler, int initialCode, @Nullable String initialData, @Nullable Bundle initialExtras) {

    }

    /**
     * @param intent The Intent that was previously broadcast.
     */
    @Override
    public void removeStickyBroadcast(Intent intent) {

    }

    /**
     * @param intent The Intent to broadcast; all receivers matching this
     *               Intent will receive the broadcast, and the Intent will be held to
     *               be re-broadcast to future receivers.
     * @param user   UserHandle to send the intent to.
     */
    @Override
    public void sendStickyBroadcastAsUser(Intent intent, UserHandle user) {

    }

    /**
     * @param intent         The Intent to broadcast; all receivers matching this
     *                       Intent will receive the broadcast.
     * @param user           UserHandle to send the intent to.
     * @param resultReceiver Your own BroadcastReceiver to treat as the final
     *                       receiver of the broadcast.
     * @param scheduler      A custom Handler with which to schedule the
     *                       resultReceiver callback; if null it will be
     *                       scheduled in the Context's main thread.
     * @param initialCode    An initial value for the result code.  Often
     *                       Activity.RESULT_OK.
     * @param initialData    An initial value for the result data.  Often
     *                       null.
     * @param initialExtras  An initial value for the result extras.  Often
     *                       null.
     */
    @Override
    public void sendStickyOrderedBroadcastAsUser(Intent intent, UserHandle user, BroadcastReceiver resultReceiver, @Nullable Handler scheduler, int initialCode, @Nullable String initialData, @Nullable Bundle initialExtras) {

    }

    /**
     * @param intent The Intent that was previously broadcast.
     * @param user   UserHandle to remove the sticky broadcast from.
     */
    @Override
    public void removeStickyBroadcastAsUser(Intent intent, UserHandle user) {

    }

    /**
     * @param receiver The BroadcastReceiver to handle the broadcast.
     * @param filter   Selects the Intent broadcasts to be received.
     * @return
     */
    @Nullable
    @Override
    public Intent registerReceiver(@Nullable BroadcastReceiver receiver, IntentFilter filter) {
        return null;
    }

    /**
     * @param receiver The BroadcastReceiver to handle the broadcast.
     * @param filter   Selects the Intent broadcasts to be received.
     * @param flags    Additional options for the receiver. For apps targeting {@link
     *                 android.os.Build.VERSION_CODES#UPSIDE_DOWN_CAKE} either {@link #RECEIVER_EXPORTED} or
     *                 {@link #RECEIVER_NOT_EXPORTED} must be specified if the receiver isn't being registered
     *                 for <a href="{@docRoot}guide/components/broadcasts#system-broadcasts">system
     *                 broadcasts</a> or a {@link SecurityException} will be thrown. If {@link
     *                 #RECEIVER_EXPORTED} is specified, a receiver may additionally specify {@link
     *                 #RECEIVER_VISIBLE_TO_INSTANT_APPS}. For a complete list of system broadcast actions,
     *                 see the BROADCAST_ACTIONS.TXT file in the Android SDK. If both {@link
     *                 #RECEIVER_EXPORTED} and {@link #RECEIVER_NOT_EXPORTED} are specified, an {@link
     *                 IllegalArgumentException} will be thrown.
     * @return
     */
    @Nullable
    @Override
    public Intent registerReceiver(@Nullable BroadcastReceiver receiver, IntentFilter filter, int flags) {
        return null;
    }

    /**
     * @param receiver            The BroadcastReceiver to handle the broadcast.
     * @param filter              Selects the Intent broadcasts to be received.
     * @param broadcastPermission String naming a permissions that a
     *                            broadcaster must hold in order to send an Intent to you.  If null,
     *                            no permission is required.
     * @param scheduler           Handler identifying the thread that will receive
     *                            the Intent.  If null, the main thread of the process will be used.
     * @return
     */
    @Nullable
    @Override
    public Intent registerReceiver(BroadcastReceiver receiver, IntentFilter filter, @Nullable String broadcastPermission, @Nullable Handler scheduler) {
        return null;
    }

    /**
     * @param receiver            The BroadcastReceiver to handle the broadcast.
     * @param filter              Selects the Intent broadcasts to be received.
     * @param broadcastPermission String naming a permissions that a
     *                            broadcaster must hold in order to send an Intent to you.  If null,
     *                            no permission is required.
     * @param scheduler           Handler identifying the thread that will receive
     *                            the Intent.  If null, the main thread of the process will be used.
     * @param flags               Additional options for the receiver. For apps targeting {@link
     *                            android.os.Build.VERSION_CODES#UPSIDE_DOWN_CAKE} either {@link #RECEIVER_EXPORTED} or
     *                            {@link #RECEIVER_NOT_EXPORTED} must be specified if the receiver isn't being registered
     *                            for <a href="{@docRoot}guide/components/broadcasts#system-broadcasts">system
     *                            broadcasts</a> or a {@link SecurityException} will be thrown. If {@link
     *                            #RECEIVER_EXPORTED} is specified, a receiver may additionally specify {@link
     *                            #RECEIVER_VISIBLE_TO_INSTANT_APPS}. For a complete list of system broadcast actions,
     *                            see the BROADCAST_ACTIONS.TXT file in the Android SDK. If both {@link
     *                            #RECEIVER_EXPORTED} and {@link #RECEIVER_NOT_EXPORTED} are specified, an {@link
     *                            IllegalArgumentException} will be thrown.
     * @return
     */
    @Nullable
    @Override
    public Intent registerReceiver(BroadcastReceiver receiver, IntentFilter filter, @Nullable String broadcastPermission, @Nullable Handler scheduler, int flags) {
        return null;
    }

    /**
     * @param receiver The BroadcastReceiver to unregister.
     */
    @Override
    public void unregisterReceiver(BroadcastReceiver receiver) {

    }

    /**
     * @param service Identifies the service to be started.  The Intent must be
     *                fully explicit (supplying a component name).  Additional values
     *                may be included in the Intent extras to supply arguments along with
     *                this specific start call.
     * @return
     */
    @Nullable
    @Override
    public ComponentName startService(Intent service) {
        return null;
    }

    /**
     * @param service Identifies the service to be started.  The Intent must be
     *                fully explicit (supplying a component name).  Additional values
     *                may be included in the Intent extras to supply arguments along with
     *                this specific start call.
     * @return
     */
    @Nullable
    @Override
    public ComponentName startForegroundService(Intent service) {
        return null;
    }

    /**
     * @param service Description of the service to be stopped.  The Intent must be either
     *                fully explicit (supplying a component name) or specify a specific package
     *                name it is targeted to.
     * @return
     */
    @Override
    public boolean stopService(Intent service) {
        return false;
    }

    /**
     * @param service Identifies the service to connect to.  The Intent must
     *                specify an explicit component name.
     * @param conn    Receives information as the service is started and stopped.
     *                This must be a valid ServiceConnection object; it must not be null.
     * @param flags   Operation options for the binding. Can be:
     *                <ul>
     *                    <li>0
     *                    <li>{@link #BIND_AUTO_CREATE}
     *                    <li>{@link #BIND_DEBUG_UNBIND}
     *                    <li>{@link #BIND_NOT_FOREGROUND}
     *                    <li>{@link #BIND_ABOVE_CLIENT}
     *                    <li>{@link #BIND_ALLOW_OOM_MANAGEMENT}
     *                    <li>{@link #BIND_WAIVE_PRIORITY}
     *                    <li>{@link #BIND_IMPORTANT}
     *                    <li>{@link #BIND_ADJUST_WITH_ACTIVITY}
     *                    <li>{@link #BIND_NOT_PERCEPTIBLE}
     *                    <li>{@link #BIND_INCLUDE_CAPABILITIES}
     *                </ul>
     * @return
     */
    @Override
    public boolean bindService(@NonNull Intent service, @NonNull ServiceConnection conn, int flags) {
        return false;
    }

    /**
     * @param conn The connection interface previously supplied to
     *             bindService().  This parameter must not be null.
     */
    @Override
    public void unbindService(@NonNull ServiceConnection conn) {

    }

    /**
     * @param className   Name of the Instrumentation component to be run.
     * @param profileFile Optional path to write profiling data as the
     *                    instrumentation runs, or null for no profiling.
     * @param arguments   Additional optional arguments to pass to the
     *                    instrumentation, or null.
     * @return
     */
    @Override
    public boolean startInstrumentation(@NonNull ComponentName className, @Nullable String profileFile, @Nullable Bundle arguments) {
        return false;
    }

    /**
     * @param name The name of the desired service.
     * @return
     */
    @Override
    public Object getSystemService(@NonNull String name) {
        return null;
    }

    /**
     * @param serviceClass The class of the desired service.
     * @return
     */
    @Nullable
    @Override
    public String getSystemServiceName(@NonNull Class<?> serviceClass) {
        return null;
    }

    /**
     * @param permission The name of the permission being checked.
     * @param pid        The process ID being checked against.  Must be > 0.
     * @param uid        The UID being checked against.  A uid of 0 is the root
     *                   user, which will pass every permission check.
     * @return
     */
    @Override
    public int checkPermission(@NonNull String permission, int pid, int uid) {
        return PackageManager.PERMISSION_GRANTED;
    }

    /**
     * @param permission The name of the permission being checked.
     * @return
     */
    @Override
    public int checkCallingPermission(@NonNull String permission) {
        return PackageManager.PERMISSION_GRANTED;
    }

    /**
     * @param permission The name of the permission being checked.
     * @return
     */
    @Override
    public int checkCallingOrSelfPermission(@NonNull String permission) {
        return PackageManager.PERMISSION_GRANTED;
    }

    /**
     * @param permission The name of the permission being checked.
     * @return
     */
    @Override
    public int checkSelfPermission(@NonNull String permission) {
        return PackageManager.PERMISSION_GRANTED;
    }

    /**
     * @param permission The name of the permission being checked.
     * @param pid        The process ID being checked against.  Must be &gt; 0.
     * @param uid        The UID being checked against.  A uid of 0 is the root
     *                   user, which will pass every permission check.
     * @param message    A message to include in the exception if it is thrown.
     */
    @Override
    public void enforcePermission(@NonNull String permission, int pid, int uid, @Nullable String message) {

    }

    /**
     * @param permission The name of the permission being checked.
     * @param message    A message to include in the exception if it is thrown.
     */
    @Override
    public void enforceCallingPermission(@NonNull String permission, @Nullable String message) {

    }

    /**
     * @param permission The name of the permission being checked.
     * @param message    A message to include in the exception if it is thrown.
     */
    @Override
    public void enforceCallingOrSelfPermission(@NonNull String permission, @Nullable String message) {

    }

    /**
     * @param toPackage The package you would like to allow to access the Uri.
     * @param uri       The Uri you would like to grant access to.
     * @param modeFlags The desired access modes.
     */
    @Override
    public void grantUriPermission(String toPackage, Uri uri, int modeFlags) {

    }

    /**
     * @param uri       The Uri you would like to revoke access to.
     * @param modeFlags The access modes to revoke.
     */
    @Override
    public void revokeUriPermission(Uri uri, int modeFlags) {

    }

    /**
     * @param toPackage The package you had previously granted access to.
     * @param uri       The Uri you would like to revoke access to.
     * @param modeFlags The access modes to revoke.
     */
    @Override
    public void revokeUriPermission(String toPackage, Uri uri, int modeFlags) {

    }

    /**
     * @param uri       The uri that is being checked.
     * @param pid       The process ID being checked against.  Must be &gt; 0.
     * @param uid       The UID being checked against.  A uid of 0 is the root
     *                  user, which will pass every permission check.
     * @param modeFlags The access modes to check.
     * @return
     */
    @Override
    public int checkUriPermission(Uri uri, int pid, int uid, int modeFlags) {
        return PackageManager.PERMISSION_GRANTED;
    }

    /**
     * @param uri       The uri that is being checked.
     * @param modeFlags The access modes to check.
     * @return
     */
    @Override
    public int checkCallingUriPermission(Uri uri, int modeFlags) {
        return PackageManager.PERMISSION_GRANTED;
    }

    /**
     * @param uri       The uri that is being checked.
     * @param modeFlags The access modes to check.
     * @return
     */
    @Override
    public int checkCallingOrSelfUriPermission(Uri uri, int modeFlags) {
        return PackageManager.PERMISSION_GRANTED;
    }

    /**
     * @param uri             The Uri whose permission is to be checked, or null to not
     *                        do this check.
     * @param readPermission  The permission that provides overall read access,
     *                        or null to not do this check.
     * @param writePermission The permission that provides overall write
     *                        access, or null to not do this check.
     * @param pid             The process ID being checked against.  Must be &gt; 0.
     * @param uid             The UID being checked against.  A uid of 0 is the root
     *                        user, which will pass every permission check.
     * @param modeFlags       The access modes to check.
     * @return
     */
    @Override
    public int checkUriPermission(@Nullable Uri uri, @Nullable String readPermission, @Nullable String writePermission, int pid, int uid, int modeFlags) {
        return PackageManager.PERMISSION_GRANTED;
    }

    /**
     * @param uri       The uri that is being checked.
     * @param pid       The process ID being checked against.  Must be &gt; 0.
     * @param uid       The UID being checked against.  A uid of 0 is the root
     *                  user, which will pass every permission check.
     * @param modeFlags The access modes to enforce.
     * @param message   A message to include in the exception if it is thrown.
     */
    @Override
    public void enforceUriPermission(Uri uri, int pid, int uid, int modeFlags, String message) {

    }

    /**
     * @param uri       The uri that is being checked.
     * @param modeFlags The access modes to enforce.
     * @param message   A message to include in the exception if it is thrown.
     */
    @Override
    public void enforceCallingUriPermission(Uri uri, int modeFlags, String message) {

    }

    /**
     * @param uri       The uri that is being checked.
     * @param modeFlags The access modes to enforce.
     * @param message   A message to include in the exception if it is thrown.
     */
    @Override
    public void enforceCallingOrSelfUriPermission(Uri uri, int modeFlags, String message) {

    }

    /**
     * @param uri             The Uri whose permission is to be checked, or null to not
     *                        do this check.
     * @param readPermission  The permission that provides overall read access,
     *                        or null to not do this check.
     * @param writePermission The permission that provides overall write
     *                        access, or null to not do this check.
     * @param pid             The process ID being checked against.  Must be &gt; 0.
     * @param uid             The UID being checked against.  A uid of 0 is the root
     *                        user, which will pass every permission check.
     * @param modeFlags       The access modes to enforce.
     * @param message         A message to include in the exception if it is thrown.
     */
    @Override
    public void enforceUriPermission(@Nullable Uri uri, @Nullable String readPermission, @Nullable String writePermission, int pid, int uid, int modeFlags, @Nullable String message) {

    }

    /**
     * @param packageName Name of the application's package.
     * @param flags       Option flags.
     * @return
     * @throws PackageManager.NameNotFoundException
     */
    @Override
    public Context createPackageContext(String packageName, int flags) throws PackageManager.NameNotFoundException {
        return null;
    }

    /**
     * @param splitName The name of the split to include, as declared in the split's
     *                  <code>AndroidManifest.xml</code>.
     * @return
     * @throws PackageManager.NameNotFoundException
     */
    @Override
    public Context createContextForSplit(String splitName) throws PackageManager.NameNotFoundException {
        return null;
    }

    /**
     * @param overrideConfiguration A {@link Configuration} specifying what
     *                              values to modify in the base Configuration of the original Context's
     *                              resources.  If the base configuration changes (such as due to an
     *                              orientation change), the resources of this context will also change except
     *                              for those that have been explicitly overridden with a value here.
     * @return
     */
    @Override
    public Context createConfigurationContext(@NonNull Configuration overrideConfiguration) {
        return null;
    }

    /**
     * @param display The display to which the current context's resources are adjusted.
     * @return
     */
    @Override
    public Context createDisplayContext(@NonNull Display display) {
        return null;
    }

    /**
     * @return
     */
    @Override
    public Context createDeviceProtectedStorageContext() {
        return null;
    }

    /**
     * @return
     */
    @Override
    public boolean isDeviceProtectedStorage() {
        return false;
    }
}

class ConnectHandler implements MethodChannel.MethodCallHandler {
    private static final String CONNECT_METHOD_CHANNEL = "handheld.method.connect";
    private MethodChannel connectMethodChannel;
    private final FlutterEngine flutterEngine;
    private final RFIDWithUHFBLE uhfReader;
    private ConnectionStatus connectionStatus = ConnectionStatus.DISCONNECTED;

    ConnectHandler(FlutterEngine flutterEngine, RFIDWithUHFBLE uhfReader) {
        this.flutterEngine = flutterEngine;
        this.uhfReader = uhfReader;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("Connect")) {
            String address = call.argument("address");
            uhfReader.connect(address, (connectionStatus, o) -> this.connectionStatus = connectionStatus);

            long startTime = System.currentTimeMillis();
            long timeout = 5000;
            while ((System.currentTimeMillis() - startTime) < timeout) {
                if (connectionStatus == ConnectionStatus.CONNECTED) {
                    result.success(true);
                    return;
                }
            }

            if (connectionStatus != ConnectionStatus.DISCONNECTED) {
                result.success(false);
                uhfReader.disconnect();
            } else {
                result.success(false);
            }
        }
        else if (call.method.equals("Disconnect")) {
            uhfReader.disconnect();
        }
    }

    public void init() {
        connectMethodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CONNECT_METHOD_CHANNEL);
        connectMethodChannel.setMethodCallHandler(this);
    }

    public void destroy() {
        connectMethodChannel.setMethodCallHandler(null);
    }
}

class ScanHandler implements EventChannel.StreamHandler {
    private static final String SCAN_EVENT_CHANNEL = "handheld.event.scan";
    private EventChannel scanEventChannel;
    private final Context context;
    private final FlutterEngine flutterEngine;
    private final RFIDWithUHFBLE uhfReader;
    private EventChannel.EventSink eventSink;
    private boolean scanFlag = false;

    ScanHandler(Context context, FlutterEngine flutterEngine, RFIDWithUHFBLE uhfReader) {
        this.context = context;
        this.flutterEngine = flutterEngine;
        this.uhfReader = uhfReader;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        if (!scanFlag) {
            scanFlag = true;
            eventSink = events;
            uhfReader.startInventoryTag();

            Log.d("inventory","uhf inventory:"+uhfReader.startInventoryTag());

            new Thread(() -> {
                Handler handler = new Handler(context.getMainLooper());
                while (scanFlag) {
                    Log.d(TAG, "scan flag: " +scanFlag);
                    List<UHFTAGInfo> uhfTagList = this.uhfReader.readTagFromBufferList();
                    Log.d("uhf","uhf tag list:"+uhfTagList);
                    if (uhfTagList!=null) {
//                        ArrayList<String> epcList = new ArrayList<String>();
                        Log.d(TAG, "start looping for" );
//
                        for (UHFTAGInfo uhfTag : uhfTagList) {
                            Log.d(TAG, "uhf tag: " +uhfTag);
                            String epc = uhfTag.getEPC();
//                            String rssi = uhfTag.getRssi();

//                            Map<String,Object> data = new HashMap<>();



                            if(epc.length()==32){
                                String epcSliced = epc.substring(4,28);
//                                 epcList.add(epcSliced);
                                Log.d(TAG, "epc 32: " +epcSliced);
//                                data.put("epc",epcSliced);
                                handler.post(()->{
                                    if(scanFlag) eventSink.success(epcSliced);
                                });
                            }else{
//                                 epcList.add(epc);
                                Log.d(TAG, "epc 24: " +epc);
//                                data.put("epc",epc);
                                handler.post(()->{
                                    if(scanFlag) eventSink.success(epc);
                                });
                            }
//                            data.put("rssi",rssi);
//                            Log.d(TAG,"rssi: " +rssi);
//                            handler.post(()->{
//                               if(scanFlag) eventSink.success(data);
//                            });
                        }
//                        Log.d(TAG, "end looping  list: " +epcList);
//
//                        handler.post(()->{
//                                  if(scanFlag) eventSink.success(epcList);
//                               });


                        // handler.post(()->{
                        //     if(scanFlag)eventSink.success(epcList);
                        // });



                    }
                }
                eventSink = null;
            }).start();
        }
    }

    @Override
    public void onCancel(Object arguments) {
        if (scanFlag) {
            scanFlag = false;
            uhfReader.stopInventory();
        }
    }

    public void init() {
        scanEventChannel = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), SCAN_EVENT_CHANNEL);
        scanEventChannel.setStreamHandler(this);
    }

    public void destroy() {
        scanEventChannel.setStreamHandler(null);
    }
}

class KeyHandler implements EventChannel.StreamHandler {
    private static final String KEY_EVENT_CHANNEL = "handheld.event.key";
    private EventChannel keyEventChannel;
    private final FlutterEngine flutterEngine;
    private final RFIDWithUHFBLE uhfReader;
    private EventChannel.EventSink eventSink;

    KeyHandler(FlutterEngine flutterEngine, RFIDWithUHFBLE uhfReader) {
        this.flutterEngine = flutterEngine;
        this.uhfReader = uhfReader;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
        uhfReader.setKeyEventCallback(keycode -> eventSink.success(keycode));
    }

    @Override
    public void onCancel(Object arguments) {
        uhfReader.setKeyEventCallback(null);
        eventSink = null;
    }

    public void init() {
        keyEventChannel = new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), KEY_EVENT_CHANNEL);
        keyEventChannel.setStreamHandler(this);
    }

    public void destroy() {
        keyEventChannel.setStreamHandler(null);
    }
}