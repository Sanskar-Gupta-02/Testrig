/**
 * Enums and color utility class
 * Contains color enumerations and methods to get color codes in HEX and RGBA formats
 */

export enum Color {
    RED = "RED",
    GREEN = "GREEN",
    BLUE = "BLUE",
    YELLOW = "YELLOW",
    PINK = "PINK",
    ORANGE = "ORANGE",
    GREY = "GREY",
    VIOLET = "VIOLET",
    BLACK = "BLACK",
    WHITE = "WHITE",
    SANCTIONSRED = "SANCTIONSRED",
    SANCTIONSORANGE = "SANCTIONSORANGE",
    SANCTIONSYELLOW = "SANCTIONSYELLOW",
    DARKRED = "DARKRED",
    DARKYELLOW = "DARKYELLOW",
}

export class Enums {
    /**
     * This method is used to get color's HEX code by name
     * @param color - The color name (case-insensitive)
     * @returns The HEX code for the specified color
     */
    public static getColorHEXCode(color: string): string {
        const colorEnum = color.toUpperCase() as keyof typeof Color;

        if (!(colorEnum in Color)) {
            throw new Error(`Invalid color name: ${color}`);
        }

        switch (colorEnum) {
            case "RED":
                return "#ff0000";
            case "GREEN":
                return "#37ff00";
            case "BLUE":
                return "#0008f5";
            case "YELLOW":
                return "#fdf408";
            case "PINK":
                return "#f500cc";
            case "ORANGE":
                return "#ff3300";
            case "GREY":
                return "#c8c8c8";
            case "BLACK":
                return "#000000";
            case "WHITE":
                return "#ffffff";
            case "VIOLET":
                return "#9600fa";
            case "SANCTIONSRED":
                return "#9c0c02";
            case "SANCTIONSORANGE":
                return "#ffa500";
            case "SANCTIONSYELLOW":
                return "#ffff00";
            case "DARKRED":
                return "#e84e0f";
            case "DARKYELLOW":
                return "#f0ad4e";
            default:
                throw new Error(`Invalid color name: ${color}`);
        }
    }

    /**
     * This method is used to get color's RGBA code by color name
     * @param color - The color name (case-insensitive)
     * @returns The RGBA code for the specified color
     */
    public static getColorRGBA(color: string): string {
        const colorEnum = color.toUpperCase() as keyof typeof Color;

        if (!(colorEnum in Color)) {
            throw new Error(`Invalid color name: ${color}`);
        }

        switch (colorEnum) {
            case "RED":
                return "rgb(255, 0, 0)";
            case "DARKRED":
                return "rgb(232, 78, 15)";
            case "GREEN":
                return "rgb(55, 255, 0)";
            case "BLUE":
                return "rgb(0, 8, 245)";
            case "YELLOW":
                return "rgb(253, 244, 8)";
            case "PINK":
                return "rgb(245, 0, 204)";
            case "ORANGE":
                return "rgb(255, 51, 0)";
            case "GREY":
                return "rgb(200, 200, 200)";
            case "BLACK":
                return "rgb(0, 0, 0)";
            case "WHITE":
                return "rgb(255, 255, 255)";
            case "VIOLET":
                return "rgb(150, 0, 250)";
            case "SANCTIONSRED":
                return "rgb(156, 12, 2)";
            case "SANCTIONSYELLOW":
                return "rgb(255, 255, 0)";
            case "SANCTIONSORANGE":
                return "rgb(255, 165, 0)";
            case "DARKYELLOW":
                return "rgb(240, 173, 78)";
            default:
                throw new Error(`Invalid color name: ${color}`);
        }
    }
}
