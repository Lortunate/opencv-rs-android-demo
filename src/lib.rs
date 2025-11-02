use opencv::core;
use opencv::core::Mat;

fn abc() -> &'static str {
    "abc"
}

fn opencv_demo(input: &Mat) -> opencv::Result<Mat> {
    let mut output = Mat::default();
    core::flip(input, &mut output, 1)?;
    Ok(output)
}
