import { Request, Response } from "express";
import { validationResult } from "express-validator";

interface ResponseMessage {
  status: number;
  error?: boolean;
  message: string;
  data?: any;
}

/// Since most of the response msg will be about error, that's
/// why by default its true to avoid extra code
export function responseMsg(
  res: Response,
  { status, error = true, message, data }: ResponseMessage,
  next: Function = () => {}
) {
  res.status(status).json({ error, message, data } as ResponseMessage);
  next();
}

export function expressValidatorErrorResponse(req: Request, res: Response) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    /// If errors are there then return array where 1st value is
    /// whether errors are there or not and 2nd value is response.
    /// If error is there then return this response or else it is null

    return [
      true,
      responseMsg(res, {
        status: 422,
        message: errors.array()[0].msg,
      }),
    ];
  }

  return [false, null];
}
