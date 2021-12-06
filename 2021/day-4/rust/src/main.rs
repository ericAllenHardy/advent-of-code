use std::fs;

fn star_1() -> Result<(), std::io::Error> {
    let contents: String = fs::read_to_string("../input.txt")?;
    let sections: Vec<&str> = contents.split("\n\n").collect();

    let draws = sections[0];

    println!("Hello, world!");
    Ok(())
}

fn main() {
    star_1().expect("error");
}
