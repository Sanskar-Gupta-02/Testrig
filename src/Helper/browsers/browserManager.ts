import { chromium, firefox, LaunchOptions, webkit } from "@playwright/test";

const options: LaunchOptions = {
    headless: true,
    downloadsPath: "downloads",
    args: ["--window-size=1920,1080"],
};
export const invokeBrowser = () => {
    const browserType = process.env.BROWSER;
    switch (browserType) {
        case "chrome":
            return chromium.launch(options);
        case "firefox":
            return firefox.launch(options);
        case "webkit":
            return webkit.launch(options);
        default:
            throw new Error("Please set the proper browser");
    }
};
