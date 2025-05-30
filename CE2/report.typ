#import "@preview/problemst:0.1.2": pset
#set math.equation(numbering: "(1)")

#let raw_from_m(file_name, tag_name: "") = {
  let fir_m_file = read(file_name)
  let lines = fir_m_file.split("\n")
  if (tag_name.len() > 0) {
    let idxs = lines.enumerate().filter(idx_data => idx_data.at(1).contains(tag_name))
    if (idxs.len() != 2) {
      panic(idxs)
    }
    let (start, end) = idxs
    let (start_id, _) = start
    let (end_id, _) = end
    lines = lines.slice(start_id + 1, end_id)
  } 
  raw(lines.join("\n"), lang: "matlab", block: true)
}

#show: pset.with(
  class: "ME-321 System Identification",
  student: "Niel Mistry (390177), Farah Elsousy (389923)",
  title: "CE2",
  date: datetime.today(),
)

#let deriv(num, dnm) = [$ (d num) / (d dnm) $]


= Identification of a DC Servo Motor

== FIR Model Identification

=== Code
#figure(
  raw_from_m("fir_identification.m", tag_name: "lst_1"),
  caption: [FIR Model Generation ($accent(theta, hat)$) Code]
)
=== Plots

#figure(
  image("plots/fir_y_ypred.png", width: 80%),
  caption: [FIR Output Comparison]
)

The loss is:
$ J(accent(theta, hat)) = 2.87 times 10^4 $.
=== Covariance Code & Plots

#raw_from_m("fir_identification.m", tag_name: "lst_fir_cov")

== ARX Model Identification
=== Estimation of Parameters

#figure(
  raw_from_m("arx_identification.m", tag_name: "lst_arx_impl"),
  caption: [Least Squares for ARX Model Identification]
) <arx_id_code>

The parameters identified by @arx_id_code are as follows: 
$ accent(theta, hat) = mat(a_1; a_2; b_1; b_2) = mat(-1.7757;0.8134;0.0016;0.0090) $ <arx_params> 

=== Predicted Output and Loss

@arx_comp_fig shows the true output and the predicted output, as well as the error: 

#figure(
  image("plots/arx_y_ypred.png", width: 80%),
  caption: [ARX Output Comparison]
)<arx_comp_fig>

The sum-of-squares loss is:

$ J(accent(theta, hat)) = 788.5745  $

=== Output of the Identified System
#figure(
  raw_from_m("get_model_from_theta.m"),
  caption: [Code to make linear model from the collected parameters]
)<get_model_code>

#figure(
  raw_from_m("arx_identification.m", tag_name: "arx_lsim"),
  caption: [Passing the paramaters to the model getter function in @get_model_code]

)<arx_model_code>

@arx_model_code shows the code to create the model and simulate it from the parameters determined by the ARX model. 

#figure(
  image("plots/arx_y_ym.png", width: 80%),
  caption: [The difference between the model predicted output $y_m$ and the measured output $y$]
)<arx_model_fig>

In @arx_model_fig, we can observe that the predicted value follows the trend of the measured output, but without the noise. $y_m$ is a _noiseless_ representation of the model output.

=== Instrumental Variable Method

The instrumental variable method uses a noiseless prediction of a previous model to improve results. @arx_inst_var code shows the code used to create these parameters. It is identical to @arx_id_code, where the ARX method is used but instead of using raw $y$, it uses $y_m$ from the system simulated by @arx_model_code.

#figure(
  raw_from_m("arx_identification.m", tag_name: "lst_inst_var"),
  caption: [Code to make linear model from the collected parameters]
)<arx_inst_var>

The parameters identified by the instrumental variable method are shown below: 

$ accent(theta, hat)_(i v) = mat(-1.1649;-1.7510;0.0021;0.0095) $ <inst_var_params> 

These paramaters are significantly different from @arx_params.


