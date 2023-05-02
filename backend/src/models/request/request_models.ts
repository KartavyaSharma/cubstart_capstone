/**
 * Interface models for incoming requests across all routes
 * on the rmembr server.
 * 
 * Data based on these models will be returned from the
 * corresponding functions from inside ../rmembr directory.
 */

/** ========== Auth ========== */
export interface ICreateUserRequest {
    name: string;
    email: string;
    password: string;
}
export interface ILoginRequest {
    email: string;
    password: string;
}
/** ========================== */