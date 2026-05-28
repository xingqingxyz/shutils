using CoreAudio;

namespace Utility;

public static class AudioDevice
{
    private static readonly MMDeviceEnumerator _enumerator;
    private static readonly MMDevice _defaultDevice;
    private static readonly AudioEndpointVolume? _volumeControl;

    static AudioDevice()
    {
        _enumerator = new MMDeviceEnumerator();
        _defaultDevice = _enumerator.GetDefaultAudioEndpoint(DataFlow.Render, Role.Multimedia);
        _volumeControl = _defaultDevice.AudioEndpointVolume;
    }

    /// <summary>
    /// 获取当前系统音量（0.0-1.0）
    /// </summary>
    public static float GetVolume()
    {
        return _volumeControl?.MasterVolumeLevelScalar ?? 0.0f;
    }

    /// <summary>
    /// 设置系统音量（0.0-1.0）
    /// </summary>
    public static void SetVolume(float level)
    {
        if (level < 0.0f || level > 1.0f)
        {
            throw new ArgumentOutOfRangeException(nameof(level), "音量值必须在0.0到1.0之间");
        }
        _volumeControl?.MasterVolumeLevelScalar = level;
    }

    /// <summary>
    /// 获取当前静音状态
    /// </summary>
    public static bool GetMute()
    {
        return _volumeControl?.Mute ?? false;
    }

    /// <summary>
    /// 设置静音状态
    /// </summary>
    public static void SetMute(bool mute)
    {
        _volumeControl?.Mute = mute;
    }

    /// <summary>
    /// 增加音量
    /// </summary>
    public static void VolumeUp(float step = 0.02f)
    {
        float currentVolume = GetVolume();
        float newVolume = Math.Min(currentVolume + step, 1.0f);
        SetVolume(newVolume);
    }

    /// <summary>
    /// 减少音量
    /// </summary>
    public static void VolumeDown(float step = 0.02f)
    {
        float currentVolume = GetVolume();
        float newVolume = Math.Max(currentVolume - step, 0.0f);
        SetVolume(newVolume);
    }
}
