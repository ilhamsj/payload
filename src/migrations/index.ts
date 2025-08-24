import * as migration_20250824_032708 from './20250824_032708';

export const migrations = [
  {
    up: migration_20250824_032708.up,
    down: migration_20250824_032708.down,
    name: '20250824_032708'
  },
];
