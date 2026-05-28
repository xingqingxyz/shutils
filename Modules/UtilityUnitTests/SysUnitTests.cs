using PSCoreAudio;

namespace PSCoreAudioUnitTests;

public class PSCoreAudioUnitTests
{
    [Fact]
    public void TestGetVolume_ReturnsValidRange()
    {
        // Act
        float volume = Device.GetVolume();

        // Assert
        Assert.InRange(volume, 0.0f, 1.0f);
    }

    [Theory]
    [InlineData(0.0f)]
    [InlineData(0.25f)]
    [InlineData(0.5f)]
    [InlineData(0.75f)]
    [InlineData(1.0f)]
    public void TestSetVolume_ValidValues_SetsCorrectly(float testVolume)
    {
        // Act
        Device.SetVolume(testVolume);
        float actualVolume = Device.GetVolume();

        // Assert - 允许小的浮点误差
        Assert.Equal(testVolume, actualVolume, 2); // 精确到小数点后2位
    }

    [Theory]
    [InlineData(-0.1f)]
    [InlineData(1.1f)]
    public void TestSetVolume_OutOfRange_ThrowsException(float invalidVolume)
    {
        // Act & Assert
        var exception = Assert.Throws<ArgumentOutOfRangeException>(() => Device.SetVolume(invalidVolume));
        Assert.Contains("音量值必须在0.0到1.0之间", exception.Message);
    }

    [Fact]
    public void TestSetMute_SetsCorrectly()
    {
        // 设置为静音
        Device.SetMute(true);
        bool muteStatus = Device.GetMute();
        Assert.True(muteStatus, "静音状态应该为真");

        // 取消静音
        Device.SetMute(false);
        muteStatus = Device.GetMute();
        Assert.False(muteStatus, "静音状态应该为假");
    }

    [Fact]
    public void TestVolumeUp_IncreasesVolume()
    {
        // Arrange - 设置一个中间值以允许增加
        Device.SetVolume(0.5f);
        float initialVolume = Device.GetVolume();

        // Act
        Device.VolumeUp();
        float finalVolume = Device.GetVolume();

        // Assert
        Assert.True(finalVolume >= initialVolume, $"音量应该增加或保持不变，初始：{initialVolume}，最终：{finalVolume}");
        Assert.True(finalVolume <= 1.0f, $"音量不应超过1.0，实际：{finalVolume}");
    }

    [Fact]
    public void TestVolumeUp_AtMaxVolume_DoesNotExceedOne()
    {
        // Arrange - 设置最大音量
        Device.SetVolume(1.0f);

        // Act
        Device.VolumeUp();
        float volume = Device.GetVolume();

        // Assert
        Assert.Equal(1.0f, volume);
    }

    [Fact]
    public void TestVolumeDown_DecreasesVolume()
    {
        // Arrange - 设置一个中间值以允许减少
        Device.SetVolume(0.5f);
        float initialVolume = Device.GetVolume();

        // Act
        Device.VolumeDown();
        float finalVolume = Device.GetVolume();

        // Assert
        Assert.True(finalVolume <= initialVolume, $"音量应该减少或保持不变，初始：{initialVolume}，最终：{finalVolume}");
        Assert.True(finalVolume >= 0.0f, $"音量不应低于0.0，实际：{finalVolume}");
    }

    [Fact]
    public void TestVolumeDown_AtMinVolume_DoesNotGoBelowZero()
    {
        // Arrange - 设置最小音量
        Device.SetVolume(0.0f);

        // Act
        Device.VolumeDown();
        float volume = Device.GetVolume();

        // Assert
        Assert.Equal(0.0f, volume);
    }

    [Fact]
    public void TestVolumeUpWithCustomStep_IncreasesByStepAmount()
    {
        // Arrange
        float step = 0.02f;
        Device.SetVolume(0.5f);
        float initialVolume = Device.GetVolume();

        // Act
        Device.VolumeUp(step);
        float finalVolume = Device.GetVolume();

        // Assert
        float expectedVolume = Math.Min(initialVolume + step, 1.0f);
        Assert.InRange(finalVolume, expectedVolume - 0.001f, expectedVolume + 0.001f);
    }

    [Fact]
    public void TestVolumeDownWithCustomStep_DecreasesByStepAmount()
    {
        // Arrange
        float step = 0.02f;
        Device.SetVolume(0.5f);
        float initialVolume = Device.GetVolume();

        // Act
        Device.VolumeDown(step);
        float finalVolume = Device.GetVolume();

        // Assert
        float expectedVolume = Math.Max(initialVolume - step, 0.0f);
        Assert.InRange(finalVolume, expectedVolume - 0.001f, expectedVolume + 0.001f);
    }

    [Fact]
    public void TestMultipleVolumeChanges_AppliesCorrectly()
    {
        // Arrange
        Device.SetVolume(0.2f);

        // Act - 进行多次音量调整
        Device.VolumeUp(0.1f); // 0.3
        Device.VolumeUp(0.2f); // 0.5
        Device.VolumeDown(0.1f); // 0.4

        // Assert
        float expected = 0.4f;
        float actual = Device.GetVolume();
        Assert.InRange(actual, expected - 0.001f, expected + 0.001f);
    }
}
