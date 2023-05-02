import { Request, Response, NextFunction } from "express";
import { IUser } from "./db/user/user";
import { ILoginResponse, IDeleteUserResponse } from "./response/response_models";
import User from "../emoji/user/user";

/** 
 * Contains all server models other than the ones defined
 * in the model subdir.
 */

export interface IErrorModel {
    /**
     * Unique error code which identifies the error.
     */
    code: string;

    /**
     * Status code of the error (by convention).
     */
    status: number;

    /**
     * Any additional data about the error. A helpful
     * string describing the error.
     */
    meta?: string;
}

export interface ISuccessModel<ResponseType> {
    /**
     * Code indicating response was a success.
     */
    readonly code: number;

    /**
     * Payload of the API response, contains objects.
     */
    payload: ResponseType;
}

export interface IUserSetupBundle {
    token: string, 
    user: IUser
}

/** Set of interfaces defining the User class. */
export interface IUserClass {
    createUser(): Promise<ILoginResponse>;
    get email(): string
    get id(): string
    get password(): string
    get name(): string
}

export interface IUserClassStatic {
    getUser(email: string): Promise<User>
    delete(user: User): Promise<IDeleteUserResponse>
    extractUser(req: Request): IUser
    setUser(req: Request, res: Response, next: NextFunction): Promise<void>;
}