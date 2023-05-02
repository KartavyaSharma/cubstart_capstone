import { Express, RequestHandler, Response } from "express";
import { Routes } from '../routes/routes'
import { Exception } from "./errors/exception";
import { ErrorCode } from "./errors/error_codes";
import { Success } from "./success/success";
import { ISuccessModel } from "../models/server_models";
import { ObjectSchema } from "joi";

/**
 * Utils containing frequently used methods.
 */

export class Utils {

    /** 
     * Enum definitions. Enums are only being simulated in Utils since TypeScript does
     * not support object enum values.
     * */
    static readonly EMPTY_OBJECT = new Utils("EMPTY", {});

    /** 
     * Constructor used to make new enums for objects.
     * @param key the name of the enum entry.
     * @param value the value associated with the enum entry.
     */
    constructor(private readonly key: string, public readonly value: any) {}

    /**
     * Adds a new Router middleware for given server instance with a
     * Route class BASE property.
     * @param expressApp instance of the current server.
     * @param routerClass instance of the particular router being used.
     * @param middleware collection of middleware to be used before req is forwarded to the router.
     */
    public static addRoute(expressApp: Express, routerClass: Routes, ...middleware: RequestHandler[]): void {
        expressApp.use(routerClass.getBase, ...middleware, routerClass.getRouter);
    }

    /**
     * Validates object by verifying that it contains field FIELD, and that
     * it is not null or undefined. Throws an ValidationError if the field does
     * not exist.
     * @param targetObj object that is to be validated
     * @param field that the object must contain.
     */
    public static validateObject(targetObj: any, field: string): void {
        if (!Object.prototype.hasOwnProperty.call(targetObj, field)) {
            throw new Exception(
                ErrorCode.ValidationError,
                `Object ${targetObj.constructor.name} does not contain ${field}`
            );
        }
    }

    /**
     * Validation function to check if any objects implements
     * the <ObjectType> interface properly at runtime.
     * @param object to be validated.
     * @param validator schema to validate the object with.
     * @returns boolean value for if object implements <ObjectType>.
     */
    public static async validateObjectDeep<ObjectType>(object: ObjectType, validator: ObjectSchema): Promise<void> {
        try {
            await validator.validateAsync(object);
        } catch (err) {
            const msg: string = `${err}\nON OBJECT: ${object}\nObject does not impelement proper interface.`;
            throw new Exception(
                ErrorCode.ValidationError,
                msg
            );
        }
    }

    /** 
     * Sends res object to the client.
     * @param resObj response object from api route sending the response.
     * @param payloadObj object requested by the client.
     */
    public static sendRes<ResponseType>(resObj: Response, payloadObj: ResponseType): void {
        resObj.send({ code: Success.code, payload: payloadObj } as ISuccessModel<ResponseType>);
    }

    /** 
     * Validates email based on RegEx. 
     * @param email to validate.
     * @returns if email is valid.
    */
    public static checkEmail(email: string): boolean {
        const validator = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        return new RegExp(validator).test(email);
    }

    /**
     * Class decorator used to implement static methods in classes.
     */
    public static staticImplements<T>() {
        return <U extends T>(constructor: U) => {constructor};
    } 
}