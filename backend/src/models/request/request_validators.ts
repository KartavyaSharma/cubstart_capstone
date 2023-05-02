import Joi, { ObjectSchema } from "joi";
import * as req_mods from './request_models';

/**
 * Interface models for incoming requests across all routes
 * on the rmembr server.
 * 
 * Data based on these models will be returned from the
 * corresponding functions from inside ../rmembr directory.
 */

/** ========== Auth ========== */
export const JCreateUserRequest: ObjectSchema = Joi.object<req_mods.ICreateUserRequest>(
    {
        name: Joi.string().required(),
        email: Joi.string().required(),
        password: Joi.string().required(),
    }
);
export const JLoginRequest: ObjectSchema = Joi.object<req_mods.ILoginRequest>(
    {
        email: Joi.string().required(),
        password: Joi.string().required(),
    }
);
/** ========================== */

/** Emoji */
export const JCreateEmojiRequest: ObjectSchema = Joi.object<req_mods.ICreateEmojiRequest>(
    {
        emoji: Joi.array().items(Joi.array().items(Joi.string())).required(),
        name: Joi.string().required(),
    }
);