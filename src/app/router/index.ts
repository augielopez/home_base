export type AppRoute = {
  path: string;
  label: string;
};

import { balanceBaseRoutes } from "../../modules/balance-base/routes";
import { careerBaseRoutes } from "../../modules/career-base/routes";
import { celebrationBaseRoutes } from "../../modules/celebration-base/routes";
import { productivityBaseRoutes } from "../../modules/productivity-base/routes";
import { supplyBaseRoutes } from "../../modules/supply-base/routes";

export const appRoutes: AppRoute[] = [
  ...balanceBaseRoutes,
  ...careerBaseRoutes,
  ...celebrationBaseRoutes,
  ...productivityBaseRoutes,
  ...supplyBaseRoutes,
];
