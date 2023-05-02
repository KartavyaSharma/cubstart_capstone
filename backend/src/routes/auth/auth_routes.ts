import { NextFunction, Request, Response } from 'express';
import { Routes } from '../routes';
import User from '../../emoji/user/user';
import { Auth } from '../../emoji/auth/auth_engine';
import { ILoginRequest, ICreateUserRequest } from '../../models/request/request_models';
import { Utils } from '../../utils/server_utils';
import {
    ICreateUserResponse, 
    ILoginResponse
} from '../../models/response/response_models';
import { JCreateUserRequest, JLoginRequest } from '../../models/request/request_validators';

/**
 * Class defining authentication routes and associated functions.
 * Client can create a new user (register), and client can log into
 * an existing user.
 * 
 * Calls methods from ../../rmembr/auth/
 */
export default class AuthRoutes extends Routes {

    /** Base URL for all authentication routes. */
    protected static readonly BASE = "/auth";

    /**
     * Initializes routes object from Routes abstract class.
     * New routes can be added using super().routes.[CRUD OP]();
     */
    constructor() {
        super();
    }

    protected createRoutes(): void {
        /**
         * Adds a route for creating a user. Route is at /create-user.
         * Creates a new user in the DB.
         */
        this._routes.post(`/create-user`, async (req: Request, res: Response, next: NextFunction) => {
            let newUser: User;
            let token: ILoginResponse;
            try {
                await Utils.validateObjectDeep<ICreateUserRequest>(req.body, JCreateUserRequest);
                newUser = new User(User.extractUser(req));
                token = await newUser.createUser();
            } catch (err) {
                return next(err);
            }
            Utils.sendRes<ICreateUserResponse>(res, {token: token.token } as ICreateUserResponse);
        });

        /**
        * Adds a route for loggin in an existing user. Route is at /login.
        */
        this._routes.post(`/login`, async (req: Request, res: Response, next: NextFunction) => {
            let loginReq: ILoginRequest;
            let user: User;
            try {
                await Utils.validateObjectDeep<ILoginRequest>(req.body, JLoginRequest);
                loginReq = req.body;
                user = await Auth.authUser(loginReq.email, loginReq.password)
            } catch (err) {
                return next(err);
            }
            Utils.sendRes<ILoginResponse>(res, { token: Auth.generateToken(user) } as ILoginResponse);
        });
    }
}
