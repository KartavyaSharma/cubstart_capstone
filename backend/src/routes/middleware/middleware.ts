import { Request, Response, NextFunction } from 'express';

const middleware: {
    [type: string]: {
        [type: string]: ((req: Request, res: Response, next: NextFunction) => Promise<void>)
    }
} = {
    'default': {
        'ignore': async (req: Request, res: Response, next: NextFunction) => {next();}
    }
}

export const getMiddleware = (inPath: string): ((req: Request, res: Response, next: NextFunction) => Promise<void>)[] => {
    if (inPath in middleware) {
        return Object.values(middleware[inPath]);
    }
    return Object.values(middleware['default']);
}