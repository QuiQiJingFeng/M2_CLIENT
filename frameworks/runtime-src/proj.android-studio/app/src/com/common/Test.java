package com.common;
import android.util.Log;
/*
    注意点:
        1、JAVA类 要求必须是一个单粒类,单粒返回必须是Object类型
        2、因为Lua中无法区分整形和浮点型,所以参数一律用double类型指定
        3、如果lua中需要传递过来一个回调函数,则该回调函数使用int参数来接收
        4、回调函数支持传递多个参数回去,参数类型仅限于基本类型,float String double int 
           多个参数必须是Object数组类型
*/
public class Test {
    private Test() {}
    private static Test __instance = null;
    public static synchronized Object getInstance(){
        if (__instance == null) {
            __instance = new Test();
        }
        return __instance;
    }
    //测试用例1 参数字符串/数字/布尔  返回一个字符串
    public String invokeFunc1(String param1,double param2,boolean param3){
        Log.d("FYD",param1);
        Log.d("FYD",""+param2);
        Log.d("FYD",""+param3);
        return "INVOKE SUCCESS";
    }
    //测试用例2 返回字符串类型
    public String invokeFunc2(){
        return "STRING";
    }
    //测试用例3 返回浮点数字类型
    public double invokeFunc3(){
        return 3.14;
    }
    //测试用例4 返回整形
    public int invokeFunc4(){
        return 33;
    }
    //测试用例5 传递一个lua方法的句柄,之后回调该句柄
    public void invokeFunc5(int callBack){
        Object[] array = {112,"STRING",true,3.14};
        FYDSDK.callBackWithVector(callBack,array);
    }

    //测试用例11 参数字符串/数字/布尔  返回一个字符串
    public static String invokeFunc11(String param1,double param2,boolean param3){
        Log.d("FYD",param1);
        Log.d("FYD",""+param2);
        Log.d("FYD",""+param3);
        return "INVOKE SUCCESS";
    }
    //测试用例12 返回字符串类型
    public static String invokeFunc12(){
        return "STRING";
    }
    //测试用例13 返回浮点数字类型
    public static double invokeFunc13(){
        return 3.14;
    }
    //测试用例14 返回整形
    public static int invokeFunc14(){
        return 33;
    }
    //测试用例15 传递一个lua方法的句柄,之后回调该句柄
    public static void invokeFunc15(int callBack){
        Object[] array = {112,"STRING",true,3.14};
        FYDSDK.callBackWithVector(callBack,array);
    }
}