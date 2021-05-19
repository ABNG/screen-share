package com.example.flutter_agora_plugin.externalvideosource;


import android.opengl.EGLContext;

import com.example.flutter_agora_plugin.gles.ProgramTextureOES;
import com.example.flutter_agora_plugin.gles.core.EglCore;


public class GLThreadContext {
    public EglCore eglCore;
    public EGLContext context;
    public ProgramTextureOES program;
}
