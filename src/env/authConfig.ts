class AuthConfig {
    private constructor() { }

    private static getEnv(key: string, defaultValue?: string): string {
        const value = process.env[key];

        if (value && value.trim() !== "") {
            return value;
        }

        if (defaultValue !== undefined) {
            return defaultValue;
        }

        throw new Error(`Missing required environment variable: ${key}`);
    }

    public static tenantId(): string {
        return this.getEnv("AUTHTENANTID");
    }

    public static graphBaseUrl(): string {
        return this.getEnv("GRAPHBASEURL");
    }

    public static apiBaseUrl(): string {
        return this.getEnv("GRAPHAPIBASEURL");
    }

    public static clientId(): string {
        return this.getEnv("AUTHCLIENTID");
    }

    public static clientSecret(): string {
        return this.getEnv("AUTHCLIENTSECRET");
    }

    public static scope(): string {
        return this.getEnv("AUTHSCOPE");
    }

    public static username(): string {
        return this.getEnv("AUTHUSERNAME");
    }

    public static password(): string {
        return this.getEnv("AUTHPASSWORD");
    }

    public static grantType(): string {
        return this.getEnv("AUTHGRANTTYPE", "password"); // example default
    }

    public static mailpitApiBaseUrl(): string {
        return this.getEnv("MAILPITAPIBASEURL");
    }
}

export { AuthConfig };