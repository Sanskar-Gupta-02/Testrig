export {};

declare global {
    namespace NodeJS {
        interface ProcessENV {
            BROWSER: "chrome" | "firfox" | "webkit";
            ENV: "stguat" | "stgloadtest";
            BASEURL: string;
            HEAD: "true" | "false";
        }
    }
}
