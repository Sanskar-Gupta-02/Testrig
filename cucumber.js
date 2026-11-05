const TEST = (process.env.npm_config_TEST || "api").toUpperCase();
const TEST_LOWER = (process.env.npm_config_TEST || "api").toLowerCase();
const PROJECT = process.env.npm_config_PROJECT || "KYC360";

module.exports = {
    default: {
        tags: process.env.npm_config_TAGS || "",
        formatOptions: {
            snippetInterface: "async-await",
            resultsDir: "reports/allure-results",
        },
        paths: [`src/tests/features/${PROJECT}/${TEST}`],
        publishQuiet: true,
        dryRun: false,
        require: [`src/tests/steps/**/*.ts`, `src/hooks/${TEST_LOWER}hooks.ts`],
        requireModule: ["ts-node/register"],
        format: [
            "progress",
            "allure-cucumberjs/reporter",
            `html:reports/cucumber-report.html`,
            `json:reports/cucumber-report.json`,
            `rerun:reports/rerun/@rerun.txt`,
        ],
    },
    rerun: {
        formatOptions: {
            snippetInterface: "async-await",
            resultsDir: "reports/allure-results",
        },
        publishQuiet: true,
        dryRun: false,
        require: [`src/tests/steps/**/*.ts`, `src/hooks/${TEST_LOWER}hooks.ts`],
        requireModule: ["ts-node/register"],
        format: [
            "progress",
            "allure-cucumberjs/reporter",
            `html:reports/cucumber-report.html`,
            `json:reports/cucumber-report.json`,
            `rerun:reports/rerun/@rerun.txt`,
        ],
    },
    apiTest: {
        tags: process.env.npm_config_TAGS || "",
        formatOptions: {
            snippetInterface: "async-await",
            resultsDir: "reports/allure-results",
        },
        paths: [`src/tests/features/${PROJECT}/${TEST}`],
        publishQuiet: true,
        dryRun: false,
        require: [`src/tests/steps/**/*.ts`, `src/hooks/${TEST_LOWER}hooks.ts`],
        requireModule: ["ts-node/register"],
        format: [
            "progress",
            "allure-cucumberjs/reporter",
            `html:reports/cucumber-report.html`,
            `json:reports/cucumber-report.json`,
            `rerun:reports/rerun/@rerun.txt`,
        ],
    },
    apiRerunTest: {
        formatOptions: {
            snippetInterface: "async-await",
            resultsDir: "reports/allure-results",
        },
        publishQuiet: true,
        dryRun: false,
        require: [`src/tests/steps/**/*.ts`, `src/hooks/${TEST_LOWER}hooks.ts`],
        requireModule: ["ts-node/register"],
        format: [
            "progress",
            "allure-cucumberjs/reporter",
            `html:reports/cucumber-report.html`,
            `json:reports/cucumber-report.json`,
            `rerun:reports/rerun/@rerun.txt`,
        ],
    },
};
