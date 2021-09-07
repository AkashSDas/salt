/**
 * MainUser is the user which will consume/buy products
 * Role === 0
 */

import { Document, model, Schema } from "mongoose";
import crypto from "crypto";
import MongoPaging from "mongo-cursor-pagination";

type HashPasswordFunction = (password: string) => string;
type AuthenticateFunction = (password: string) => boolean;

/// Note: Keep properties between MainUserDocument and MainUserSchema in sync
export type MainUserDocument = Document & {
  username: string;
  email: string;

  role: number;
  address?: string;
  phoneNumber?: number;

  _password?: string;
  encryptPassword: string;
  salt: string;
  hashPassword: HashPasswordFunction;
  authenticate: AuthenticateFunction;

  createdAt: Date;
  updatedAt: Date;

  purchases: any;
  stripeCustomerId?: string;
};

const MainUserSchema = new Schema<MainUserDocument>(
  {
    username: { type: String, required: true, maxlength: 32, trim: true },
    email: { type: String, required: true, unique: true, trim: true },

    /// role = 0 for main users and this can't be updated
    role: { type: Number, default: 0, immutable: true },

    address: { type: String, trim: true, maxlength: 2048 },
    phoneNumber: { type: Number },

    encryptPassword: { type: String, required: true },
    salt: { type: String, required: true },

    /// by default user won't have anything purchased
    purchases: { type: Array, default: [] },

    /// Stripe customer id which links this customer to stripe
    stripeCustomerId: { type: String },
  },
  { timestamps: true }
);

/// Hashing user password before saving
const hashPassword: HashPasswordFunction = function (
  this: MainUserDocument,
  password
) {
  /// if password length is not atleast 6 then returning empty str
  /// and as encryptPassword field is required, this empty str will
  /// cause error by mongoose
  if (password.length < 6) return "";

  try {
    return crypto
      .createHmac("sha256", this.salt)
      .update(password)
      .digest("hex");
  } catch (err) {
    return "";
  }
};

MainUserSchema.methods.hashPassword = hashPassword;

/// Authenticate user with given password and saved hash
const authenticate: AuthenticateFunction = function (
  this: MainUserDocument,
  password
) {
  return this.hashPassword(password) === this.encryptPassword;
};

MainUserSchema.methods.authenticate = authenticate;

/// Hashing password given user and also returning user password rather than hash
/// when asked for password using password as property
///
/// I'm not sure how to work with _password, should I include it in user
/// document or just case this as any and then set _password to it as
/// a virtual is a property that is not stored in MongoDB. Virtuals are typically
/// used for computed properties on documents.
/// But these won't be displayed on client side as we've not set virtual=true for any
/// option in userSchema
///
/// If you want the virtual field to be displayed on client side, then set
/// {virtuals: true} for toObject and toJSON in schema options
MainUserSchema.virtual("password")
  .set(function (this: MainUserDocument, password: string): void {
    this._password = password;
    this.salt = crypto.randomUUID();
    this.encryptPassword = this.hashPassword(password);
  })
  .get(function (this: MainUserDocument) {
    return this._password;
  });

/// Implement pagination using either skip (or offset based) or cursor (recommended for scalability) based
/// To know how using mongoose, read the post below
/// https://cloudnweb.dev/2021/04/pagination-nodejs-mongoose/
///
/// But instead of creating this feature, mongo-cursor-pagination package is used
/// https://www.npmjs.com/package/mongo-cursor-pagination
/// The plugin will add paginate function
MainUserSchema.plugin(MongoPaging.mongoosePlugin, { name: "paginateUser" });

const MainUser = model<MainUserDocument>("MainUser", MainUserSchema);
export default MainUser;
