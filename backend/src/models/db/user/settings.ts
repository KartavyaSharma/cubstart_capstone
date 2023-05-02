import { model, Model, Schema } from 'mongoose';

/** Defines all possible settings. */
export interface ISettings {
    intervals: IIntervals;
    warning: IWarning;
}

/** Defines revision intervals. */
export interface IIntervals {
    number: number[];
}

/** Defines warning for status changes. */
export interface IWarning {
    daysTillDeadline: number;
}

export const IIntervalSchema = new Schema<IIntervals>(
    {
        number: { type: [Number], required: true }
    }
);

export const IWarningSchema = new Schema<IWarning>(
    {
        daysTillDeadline: { type: Number, required: true }
    }
);

export const ISettingsSchema = new Schema<ISettings>(
    {
        intervals: { type: IIntervalSchema, required: true },
        warning: { type: IWarningSchema, required: true }
    }
);
