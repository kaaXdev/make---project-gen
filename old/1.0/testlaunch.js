import { exec } from "child_process";
import path from "path";

const batPath = path.resolve("./make.bat");

exec(`start "" "${batPath}"`);