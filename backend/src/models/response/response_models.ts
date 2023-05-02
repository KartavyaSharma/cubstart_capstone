/** ========== User ========== */
/** DELETE /planner */
export interface IDeleteUserResponse {
    user: string;
}
/** ========================== */

/** ========== Auth ========== */
/** GET /create-user */
export interface ICreateUser {
    /** JWT token after creating the user. */
    token: string;
}

export interface ICreateUserResponse {
    token: string;
}

/** POST /login */
export interface ILoginResponse {
    token: string;
}
/** ========================== */