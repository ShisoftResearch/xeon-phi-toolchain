use std::{env,path::PathBuf,process::Command};
fn main() {
    let root=PathBuf::from(env::var_os("CARGO_MANIFEST_DIR").unwrap()).parent().unwrap().parent().unwrap().to_owned();
    let out=PathBuf::from(env::var_os("OUT_DIR").unwrap());
    let object=out.join("reference.o");
    assert!(Command::new(root.join("bin/knc-link")).args(["--knc-native-abi","-O3","-fno-tree-vectorize","-c","native-reference.c","-o"]).arg(&object).status().unwrap().success());
    assert!(Command::new(PathBuf::from(env::var_os("PHI_SDK_ROOT").unwrap_or_else(|| root.join("build/sdk").into_os_string())).join("sysroots/x86_64-mpsssdk-linux/usr/bin/k1om-mpss-linux/k1om-mpss-linux-ar")).arg("crs").arg(out.join("libreference.a")).arg(object).status().unwrap().success());
    println!("cargo:rustc-link-search=native={}",out.display());
    println!("cargo:rustc-link-lib=static=reference");
    println!("cargo:rerun-if-changed=native-reference.c");
}
