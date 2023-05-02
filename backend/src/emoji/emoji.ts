// Based on the emoji model,  create a class that uses mongoose to interact with the database.
import { IEmoji, EmojiModel} from "../models/db/emoji/emoji";

export class Emoji {
    private _id: string;
    private _emoji: string[][];
    private _name: string;
    private _userId: string;

    public get id(): string {
        return this._id;
    }

    public get emoji(): string[][] {
        return this._emoji;
    }

    public get name(): string {
        return this._name;
    }

    // Get Emoji class as object of all fields
    public get asObject(): IEmoji {
        return {
            emoji: this._emoji,
            name: this._name,
            userId: this._userId
        }
    }

    constructor(emojiObj: IEmoji) {
        this._emoji = emojiObj.emoji;
        this._name = emojiObj.name;
        this._userId = emojiObj.userId;
    }

    public async create(): Promise<Emoji> {
        // Check if emoji already exists
        const existingEmoji = await EmojiModel.findOne({ name: this.name, userId: this._userId});
        if (existingEmoji) {
            existingEmoji.emoji = this.emoji;
            existingEmoji.save();
            return new Emoji(existingEmoji);
        } else {
            const newEmoji: IEmoji = await EmojiModel.create(
                {
                    emoji: this.emoji,
                    name: this.name,
                    userId: this._userId
                }
            ); 
            const created = await EmojiModel.create(newEmoji);
            return new Emoji(created);
        }

    }

    public static async getUserEmojis(userId: string): Promise<Emoji[]> {
        const emojis = await EmojiModel.find({ userId: userId });
        return emojis.map((emoji) => new Emoji(emoji));
    }

}