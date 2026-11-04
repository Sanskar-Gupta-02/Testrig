/* eslint-disable no-undef */
module.exports = {
    env: {
        browser: true,
        es2021: true,
        node: true, // Added for Node.js environment
    },
    extends: [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:@typescript-eslint/recommended-type-checked",
        "plugin:playwright/recommended", // New - Playwright BDD support
        "plugin:prettier/recommended"
    ],
    parser: "@typescript-eslint/parser",
    plugins: [
        "@typescript-eslint",
        "prettier",
        "playwright" // New - Playwright plugin
    ],
    root: true,
    parserOptions: {
        project: "./tsconfig.json",
        tsconfigRootDir: __dirname,
    },
    overrides: [
        {
            files: ["**/*.ts", "**/*.tsx"],
            parserOptions: {
                project: ["./tsconfig.json"],
            },
        },
        {
            files: ["**/*.spec.ts"],
            rules: {
                "@typescript-eslint/no-explicit-any": "off",
                "@typescript-eslint/no-unused-vars": "off",
                "@typescript-eslint/no-unsafe-assignment": "off",
                "@typescript-eslint/no-floating-promises": "off",
                "playwright/no-conditional-in-test": "off" // Optional for BDD
            },
        },
    ],
    rules: {
        "@typescript-eslint/no-unsafe-member-access": "off",
        "@typescript-eslint/no-unsafe-argument": "off",
        "@typescript-eslint/no-unsafe-call": "off",
        "@typescript-eslint/no-var-requires": "off",
        "prettier/prettier": "error",
        "playwright/no-page-pause": "warn" // Example Playwright rule
    },
};