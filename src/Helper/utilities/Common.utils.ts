import { Workbook } from "exceljs";
import Ajv, { JSONSchemaType, ValidateFunction } from "ajv";
import * as fs from "fs";

/**
 * Returns data of given cell from given sheet and file
 *
 * @param fileName filename of the excel file
 * @param sheetName sheet name
 * @param rowNum row number
 * @param cellNum cell number (column)
 * @returns Cell data
 */
export async function readCell(fileName: string, sheetName: string, rowNum: number, cellNum: number): Promise<string> {
    const workbook = new Workbook();
    return workbook.xlsx.readFile(`./${fileName}`).then(function () {
        const sheet = workbook.getWorksheet(sheetName);
        return sheet.getRow(rowNum).getCell(cellNum).toString();
    });
}

/**
 * Fetches entire data of the given file name and sheet
 *
 * @param fileName name of the excel file
 * @param sheetName sheet name (optional), defaults to 'Sheet'
 * @returns sheet data in 2D array
 */
export async function getEntireData(fileName: string, sheetName?: string) {
    sheetName = sheetName || "Sheet";
    const workbook = new Workbook();
    return workbook.xlsx.readFile(`./${fileName}`).then(function () {
        const sheet = workbook.getWorksheet(sheetName);
        return sheet.getSheetValues();
    });
}

export function getRandomInt(digits: number): number {
    if (digits <= 0) {
        throw new Error("The number of digits must be greater than 0");
    }

    const min = Math.pow(10, digits - 1);
    const max = Math.pow(10, digits) - 1;

    return Math.floor(Math.random() * (max - min + 1)) + min;
}

export function generateRandomPassword(size: number) {
    const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_+=<>?";

    let password = "";
    for (let i = 0; i < size; i++) {
        const randomIndex = Math.floor(Math.random() * charset.length);
        password += charset.charAt(randomIndex);
    }
    return password;
}

export function getRandomItem<T>(items: T[]): T {
    const randomIndex = Math.floor(Math.random() * items.length);
    return items[randomIndex];
}

export function validateSchema<T>(data: T, schema: JSONSchemaType<T>): boolean {
    const ajv = new Ajv();
    const validate: ValidateFunction<T> = ajv.compile(schema);
    const valid: boolean = validate(data);
    if (!valid) {
        console.error("Schema validation errors:", validate.errors);
    }
    return valid;
}

export function readFileContent(filePath: string) {
    try {
        const data = fs.readFileSync(filePath, "utf8");
        return JSON.parse(data) as Record<string, unknown>;
    } catch (error) {
        console.error(`Error reading file: ${filePath}`, error);
        throw error;
    }
}

export function saveLocalDateFormatPatternToFile(filePath: string = "CultureInfo.json") {
    const locale = Intl.DateTimeFormat().resolvedOptions().locale;
    const now = new Date(); // Local system date

    const formatter = new Intl.DateTimeFormat(locale, {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
    });

    const parts = formatter.formatToParts(now);

    const pattern = parts
        .map(part => {
            switch (part.type) {
                case "day":
                    return "dd";
                case "month":
                    return "MM";
                case "year":
                    return "yyyy";
                case "literal":
                    return part.value;
                default:
                    return "";
            }
        })
        .join("");

    const cultureData = {
        locale,
        shortDatePattern: pattern,
    };

    fs.writeFileSync(`src/testData/${filePath}`, JSON.stringify(cultureData, null, 2));
}
