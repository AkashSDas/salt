/// Extending properties of Request by using Declaration Merging
/// creating an interface with extending Request would work in controller
/// but will give error while working with router, also code can be repeated
/// for just having same properties in Request. So this is a better way
/// Below post has lots of solution, some are out-dated but one used here is working
/// https://stackoverflow.com/questions/37377731/extend-express-request-object-using-typescript
///
/// To extend Express interfaces properties
/// 1. create folder ${PROJECT_ROOT}/@types/express/index.d.ts
/// 2. Add what's added below in that file
/// 3. in tsconfig.json, add / merge the property such that:
///     {"compilerOptions": "typeRoots": [ "@types" ] }

declare namespace Express {
  interface Request {
    foodCategory: any;
    auth: any;
    profile: any;
  }
}
