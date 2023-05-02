import Joi, { ObjectSchema } from "joi";
import * as res_mods from './response_models';

/** ========== User ========== */
/** DELETE */
export const JDeleteUserResponse: ObjectSchema = Joi.object<res_mods.IDeleteUserResponse>(
    {
        user: Joi.string().required(),
    }
);
/** ========================== */

/** ========== Auth ========== */
/** GET /create-user */
export const JCreateUser: ObjectSchema = Joi.object<res_mods.ICreateUser>(
    { token: Joi.string().required(), }
);
export const JCreateUserResponse: ObjectSchema = Joi.object<res_mods.ICreateUserResponse>().keys(
    {
        token: Joi.string().required(),
    }
);
/** POST /login */
export const JLoginResponse: ObjectSchema = Joi.object<res_mods.ILoginResponse>(
    { token: Joi.string().required(), }
);
/** ========================== */