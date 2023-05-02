import { Routes } from '../routes';
import { Request, Response, NextFunction } from 'express';
import { ICreateEmojiRequest } from '../../models/request/request_models';
import { JCreateEmojiRequest } from '../../models/request/request_validators';
import { Utils } from '../../utils/server_utils';
import { Emoji } from '../../emoji/emoji'
import User from '../../emoji/user/user';

export default class EmojiRoutes extends Routes {

    protected static readonly BASE = "/emoji";

    constructor() {
        super();
    }

    protected createRoutes(): void {
        this._routes.post(`/create-emoji`, async (req: Request, res: Response, next: NextFunction) => {
            let createUser: User;
            let createReq: ICreateEmojiRequest;
            let newEmoji: Emoji;
            try {
                createUser = req.body.user
                newEmoji = new Emoji({
                    emoji: req.body.emoji,
                    name: req.body.name,
                    userId: createUser.id
                });
                await newEmoji.create();
            } catch (err) {
                return next(err);
            }
            Utils.sendRes<ICreateEmojiRequest>(res, newEmoji);
        });

        this._routes.get(`/get-user-emojis`, async (req: Request, res: Response, next: NextFunction) => {
            let getUser: User;
            let userEmojis: Emoji[];
            try {
                getUser = req.body.user;
                userEmojis = await Emoji.getUserEmojis(getUser.id);
            } catch (err) {
                return next(err);
            }
            Utils.sendRes<Emoji[]>(res, userEmojis);
        });
    }
}