import { model, Model, Schema } from 'mongoose';

export interface IEmoji {
    _id?: string;
    // 2D grid of strings representing an emoji
    emoji: string[][];
    // Name of the emoji
    name: string;
    userId: string;
}

const EmojiSchema: Schema = new Schema({
    emoji: {
        type: [[String]], required: true
    },
    name: { type: String, required: true },
    userId: { type: String, required: true }
});

export const EmojiModel: Model<IEmoji> = model<IEmoji>('Emoji', EmojiSchema);