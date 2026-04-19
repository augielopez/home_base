import { ref } from 'vue';
import * as auth from '@/lib/api/auth';

const modulesPerms = ref<Record<string, string[]>>({});
const loaded = ref(false);

export async function loadPermissions() {
  try {
    const res = await auth.getProfile();
    modulesPerms.value = res.modules_perms || {};
    loaded.value = true;
    return modulesPerms.value;
  } catch (err) {
    modulesPerms.value = {};
    loaded.value = true;
    throw err;
  }
}

export function hasModule(code: string) {
  return !!modulesPerms.value && !!modulesPerms.value[code];
}

export function hasPermission(moduleCode: string, permission: string) {
  const perms = modulesPerms.value[moduleCode] || [];
  return perms.indexOf(permission) !== -1;
}

export function getModules() {
  return Object.keys(modulesPerms.value || {});
}

export { modulesPerms, loaded };

