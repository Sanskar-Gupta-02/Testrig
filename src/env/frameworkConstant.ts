class FrameworkConstant {
    private constructor() {}
    // Getters
    public static waitTime(): number {
        return 5;
    }

    public static FrameWorkMaxTime(): number {
        return 60;
    }

    public static actionTimeout(): number {
        return this.FrameWorkMaxTime();
    }

    public static viewportWidthHeight(): { width: number; height: number } {
        return { width: 1920, height: 1080 };
    }
}
export { FrameworkConstant };
