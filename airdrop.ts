import fs from "fs";
import holders from "./result-emates.json";

(async () => {
    for (let i = 0; i < 32; i += 1) {
        let tos = "[";
        let ids = "[";
        for (const [_id, holder] of Object.entries(holders)) {
            const id = parseInt(_id, 10);
            if (id >= i * 250 && id < (i + 1) * 250) {
                if (id > i * 250) {
                    tos += ",";
                    ids += ",";
                }
                tos += `"${holder}"`;
                ids += id;
            }
        }
        tos += "]";
        ids += "]";
        fs.writeFileSync(`parameters/parameter-${i}-tos.txt`, tos);
        fs.writeFileSync(`parameters/parameter-${i}-ids.txt`, ids);
    }
})();