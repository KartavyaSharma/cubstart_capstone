import { model, Model, Schema } from "mongoose";
import { ISettings, ISettingsSchema } from "./settings";

/**
 * Defines a users properties.
 */
export interface IUser {
    _id?: string;
    email: string;
    password?: string;
    name?: string;
}

/**
 * Creates a mongoose schema which will be created inside
 * the 'users' collection in MongoDB Atlas. 
 * The user has:
 *  - an unique _id
 *  - an email
 *  - a nam 
 *  - a password
 */
const IUserSchema = new Schema<IUser>(
    {
        _id: { type: String, required: true },
        email: {
            type: String,
            required: true,
            lowercase: true,
            index: true,
            unique: true
        },
        name: { type: String, required: true },
        password: { type: String, required: true },
    },
    { collection: 'users', timestamps: true }
)

export const UserModel: Model<IUser> = model('user', IUserSchema);