package com.mengya.common;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.os.SystemClock;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class Audio {
    private Audio() {}
    private static Audio __instance = null;
    public static synchronized Object getInstance(){
        if (__instance == null) {
            __instance = new Audio();
        }
        return __instance;
    }

    // 缓冲区大小：缓冲区字节大小
    private int __bufferSizeInBytes = 0;
    // 录音对象
    private AudioRecord __audioRecord;
    // 文件名
    private String __recordPath;

    private boolean __isRecording = false;

    private MediaPlayer __mediaPlayer;
    /**
     * 开始录音
     * @param path 音频流的监听
     */
    public boolean recordBegin(String path) {
        __isRecording = false;
        //麦克风输入源
        int AUDIO_INPUT = MediaRecorder.AudioSource.MIC;
        // 采样率
        // 44100是目前的标准，但是某些设备仍然支持22050，16000，11025
        // 采样频率一般共分为22.05KHz、44.1KHz、48KHz三个等级
        int AUDIO_SAMPLE_RATE = 8000;
        // 音频通道 单声道
        int AUDIO_CHANNEL = AudioFormat.CHANNEL_IN_MONO;
        // 音频格式：PCM编码
        int AUDIO_ENCODING = AudioFormat.ENCODING_PCM_16BIT;

        // 根据采样率 声道、音频格式 获取最小缓冲区大小
        __bufferSizeInBytes = AudioRecord.getMinBufferSize(AUDIO_SAMPLE_RATE, AUDIO_CHANNEL, AUDIO_ENCODING);
        __audioRecord = new AudioRecord(AUDIO_INPUT, AUDIO_SAMPLE_RATE, AUDIO_CHANNEL, AUDIO_ENCODING, __bufferSizeInBytes);
        String[] array = path.split("\\.wav");

        __recordPath = array[0];

        new Thread(new Runnable() {
            @Override
            public void run() {
                __isRecording = true;
                File recordingFile = new File(__recordPath+".pcm");
                if(recordingFile.exists()){
                    recordingFile.delete();
                }

                try {
                    recordingFile.createNewFile();
                }
                catch (IOException e) {
                    e.printStackTrace();
                    Log.e("FYD","创建储存音频文件出错");
                }

                try {
                    FileOutputStream fos = new FileOutputStream(recordingFile);
                    byte[] buffer = new byte[__bufferSizeInBytes];
                    __audioRecord.startRecording();//开始录音
                    int r = 0;
                    while (__isRecording) {
                        int readsize = __audioRecord.read(buffer,0,__bufferSizeInBytes);
                        if (AudioRecord.ERROR_INVALID_OPERATION != readsize && fos != null) {
                            try {
                                fos.write(buffer);
                            } catch (IOException e) {
                                Log.e("AudioRecorder", e.getMessage());
                            }
                        }
                    }
                    __audioRecord.stop();//停止录音
                    __audioRecord.release();
                    fos.close();
                    // 转换pcm 到wav
                    startPcmToWav(__recordPath+".pcm", __recordPath+".wav");
                } catch (Throwable t) {
                    Log.e("FYD", "Recording Failed");
                }
            }
        }).start();
        return true;
    }

    /**
     * 停止录音
     */
    public boolean stopRecord() {
        __isRecording = false;
        SystemClock.sleep(50);
        return true;
    }

    /*
    * pcm 转换成wav格式的语音
    * */
    private void startPcmToWav(String src, String target) {

        File file = new File(src);
        if (file != null) {
            try {
                @SuppressWarnings("resource")
                FileInputStream inputStream = new FileInputStream(file);
                // 计算长度
                byte[] buf = new byte[1024 * 100];
                int size = inputStream.read(buf);
                int pcmSize = 0;
                while (size != -1) {
                    pcmSize += size;
                    size = inputStream.read(buf);
                }
                inputStream.close();
                // 填入参数，比特率等。16位单声道，44100HZ
                WaveHeader header = new WaveHeader();
                // 长度字段 = 内容的大小（PCMSize) + 头部字段的大小
                // (不包括前面4字节的标识符RIFF以及fileLength本身的4字节
                header.fileLength = pcmSize + (44 - 8);
                header.FmtHdrLeth = 16;
                header.BitsPerSample = 16;
                header.Channels = 1;
                header.FormatTag = 0x0001;
                header.SamplesPerSec = 44100;
                header.BlockAlign = (short) (header.Channels
                        * header.BitsPerSample / 8);
                header.AvgBytesPerSec = header.BlockAlign
                        * header.SamplesPerSec;
                header.DataHdrLeth = pcmSize;

                byte[] h = header.getHeader();
                assert h.length == 44; // WAV标准，头部应该是44字节

                File targetFile = new File(target);
                if (!targetFile.exists()) {
                    targetFile.createNewFile();
                }
                FileOutputStream outputStream = new FileOutputStream(targetFile);
                inputStream = new FileInputStream(file);
                byte[] buffer = new byte[1024 * 100];
                int tardetSize = inputStream.read(buffer);
                outputStream.write(h, 0, h.length);
                while (tardetSize != -1) {
                    outputStream.write(buffer, 0, tardetSize);
                    tardetSize = inputStream.read(buffer);
                }
                outputStream.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // 停止当前播放的声音
    public boolean stopAllAudio(){
        if(__mediaPlayer!=null && __mediaPlayer.isPlaying()){
            __mediaPlayer.stop();
        }
        return true;
    }

    public boolean playAudioWithPath(String path) {
        try {
            //如果之前有正在播放的声音,则返回false
            if(__mediaPlayer!= null && __mediaPlayer.isPlaying()){
                return false;
            }

            //初始化播放器
            __mediaPlayer = new MediaPlayer();
            //设置播放音频数据文件
            __mediaPlayer.setDataSource(path);
            //设置播放监听事件
            __mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mediaPlayer) {
                    //播放完成
                }
            });
            //播放发生错误监听事件
            __mediaPlayer.setOnErrorListener(new MediaPlayer.OnErrorListener() {
                @Override
                public boolean onError(MediaPlayer mediaPlayer, int i, int i1) {
                    return false;
                }
            });
            //播放器音量配置
            __mediaPlayer.setVolume(1, 1);
            //是否循环播放
            __mediaPlayer.setLooping(false);
            //准备及播放
            __mediaPlayer.prepare();
            __mediaPlayer.start();
        } catch (IOException e) {
            e.printStackTrace();
            //播放失败正理
            return false;
        }
        return true;
    }

    //是否正在播放声音
    public boolean isPlayingAudio(){
        return __mediaPlayer.isPlaying();
    }
}