declare const RefreshStrategy_base: new (...args: any[]) => any;
export declare class RefreshStrategy extends RefreshStrategy_base {
    constructor();
    validate(payload: any): Promise<{
        userId: any;
        email: any;
    }>;
}
export {};
