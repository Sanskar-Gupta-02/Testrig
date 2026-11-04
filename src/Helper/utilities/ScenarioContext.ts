export class ScenarioContext {
    private static data = new Map<string, unknown>();

    static set<T>(key: string, value: T): void {
        this.data.set(key, value);
    }

    static get<T>(key: string): T | undefined {
        return this.data.get(key) as T | undefined;
    }

    static containsKey(key: string): boolean {
        return this.data.has(key);
    }

    static clear(): void {
        this.data.clear();
    }
}