/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-require-imports */
const fs = require("fs-extra");

try {
    fs.ensureDir("reports");
    fs.emptyDir("reports");
    fs.ensureDir("downloads");
    fs.emptyDir("downloads");
} catch (error) {
    console.log("Folders not created!" + error);
}
