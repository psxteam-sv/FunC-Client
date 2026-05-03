#!/bin/bash
# FunC Client - Android Project Generator
# Run this script to generate the Android project structure.

PROJECT_NAME="FunCClient"
PKG_DIR="com/example/funcclient"

echo "Creating FunC Client Android Project Layout..."

# Create Directories
mkdir -p "$PROJECT_NAME/app/src/main/res/layout"
mkdir -p "$PROJECT_NAME/app/src/main/res/values"
mkdir -p "$PROJECT_NAME/app/src/main/res/drawable"
mkdir -p "$PROJECT_NAME/app/src/main/res/anim"
mkdir -p "$PROJECT_NAME/app/src/main/res/color"
mkdir -p "$PROJECT_NAME/app/src/main/java/$PKG_DIR"


# 1. AndroidManifest.xml
cat << 'EOF' > "$PROJECT_NAME/app/src/main/AndroidManifest.xml"
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.funcclient">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="FunC Client"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.FunCClient">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <service
            android:name=".VpnServiceBase"
            android:permission="android.permission.BIND_VPN_SERVICE"
            android:exported="false">
            <intent-filter>
                <action android:name="android.net.VpnService" />
            </intent-filter>
        </service>
    </application>
</manifest>
EOF

# 2. Colors
cat << 'EOF' > "$PROJECT_NAME/app/src/main/res/values/colors.xml"
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="bg_dark">#0b0e1e</color>
    <color name="neon_blue">#00E5FF</color>
    <color name="neon_blue_dark">#009bda</color>
    <color name="gold_main">#f5a623</color>
    <color name="card_bg">#151a2e</color>
    <color name="text_muted">#8A91A8</color>
</resources>
EOF

# 3. Main Layout
cat << 'EOF' > "$PROJECT_NAME/app/src/main/res/layout/activity_main.xml"
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/bg_dark">

    <TextView
        android:id="@+id/tv_title"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="FunC Client"
        android:textColor="@android:color/white"
        android:textSize="26sp"
        android:textStyle="bold"
        android:layout_centerHorizontal="true"
        android:layout_marginTop="30dp" />

    <TextView
        android:id="@+id/tv_status"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_below="@id/tv_title"
        android:layout_centerHorizontal="true"
        android:layout_marginTop="60dp"
        android:text="DISCONNECTED"
        android:textColor="@color/text_muted"
        android:textStyle="bold"
        android:textSize="18sp" />

    <!-- Big Connect Button -->
    <FrameLayout
        android:id="@+id/btn_connect"
        android:layout_width="200dp"
        android:layout_height="200dp"
        android:layout_centerInParent="true"
        android:background="#1a2139">
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="CONNECT"
            android:textColor="@android:color/white"
            android:layout_gravity="center"
            android:textSize="20sp"
            android:textStyle="bold"/>
    </FrameLayout>

    <!-- Controls Container -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_below="@id/btn_connect"
        android:layout_marginTop="40dp"
        android:layout_marginHorizontal="20dp"
        android:orientation="horizontal"
        android:weightSum="2">

        <Button
            android:id="@+id/btn_clipboard"
            android:layout_width="0dp"
            android:layout_height="60dp"
            android:layout_weight="1"
            android:layout_marginEnd="10dp"
            android:text="Import Config"
            android:backgroundTint="@color/card_bg"
            android:textColor="@color/gold_main"/>

        <Button
            android:id="@+id/btn_select_server"
            android:layout_width="0dp"
            android:layout_height="60dp"
            android:layout_weight="1"
            android:layout_marginStart="10dp"
            android:text="SS / Vless / Vmess"
            android:backgroundTint="@color/card_bg"
            android:textColor="@android:color/white"/>

    </LinearLayout>
</RelativeLayout>
EOF

# 4. MainActivity.java
cat << 'EOF' > "$PROJECT_NAME/app/src/main/java/$PKG_DIR/MainActivity.java"
package com.example.funcclient;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.net.VpnService;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private boolean isConnected = false;
    private TextView tvStatus;
    private FrameLayout btnConnect;
    private Button btnClipboard;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvStatus = findViewById(R.id.tv_status);
        btnConnect = findViewById(R.id.btn_connect);
        btnClipboard = findViewById(R.id.btn_clipboard);

        btnConnect.setOnClickListener(v -> toggleVpn());

        btnClipboard.setOnClickListener(v -> importFromClipboard());
    }

    private void toggleVpn() {
        isConnected = !isConnected;
        if(isConnected) {
            tvStatus.setText("PROTECTED");
            tvStatus.setTextColor(android.graphics.Color.parseColor("#00E5FF"));
            btnConnect.setBackgroundColor(android.graphics.Color.parseColor("#00E5FF"));
            // Insert VpnService Start Intent Here
            
        } else {
            tvStatus.setText("DISCONNECTED");
            tvStatus.setTextColor(android.graphics.Color.parseColor("#8A91A8"));
            btnConnect.setBackgroundColor(android.graphics.Color.parseColor("#1a2139"));
        }
    }

    private void importFromClipboard() {
        ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
        if (clipboard != null && clipboard.hasPrimaryClip()) {
            ClipData.Item item = clipboard.getPrimaryClip().getItemAt(0);
            if(item.getText() != null) {
                String text = item.getText().toString();
                if (text.startsWith("vmess://") || text.startsWith("vless://") || text.startsWith("ss://") || text.startsWith("trojan://")) {
                    Toast.makeText(this, "Config Imported Successfully", Toast.LENGTH_SHORT).show();
                    // Process configs payload
                } else {
                    Toast.makeText(this, "No valid config in clipboard", Toast.LENGTH_SHORT).show();
                }
            }
        } else {
            Toast.makeText(this, "Clipboard is empty", Toast.LENGTH_SHORT).show();
        }
    }
}
EOF

echo "Done! Launch Android Studio and open the generated 'FunCClient' directory to build the app."