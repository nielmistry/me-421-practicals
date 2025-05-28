#import "@preview/problemst:0.1.2": pset


#let raw_from_m(file_name, tag_name) = {
  let fir_m_file = read(file_name)
  let lines = fir_m_file.split("\n")
  let idxs = lines.enumerate().filter(idx_data => idx_data.at(1).contains(tag_name))
  if (idxs.len() != 2) {
    panic(idxs)
  }
  let (start, end) = idxs
  let (start_id, _) = start
  let (end_id, _) = end
  let relevant_lines = lines.slice(start_id + 1, end_id)
  
  raw(relevant_lines.join("\n"), lang: "matlab", block: true)
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
  raw_from_m("fir_identification.m", "lst_1"),
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

#raw_from_m("fir_identification.m", "lst_fir_cov")

== ARX Model Identification
=== Estimation of Parameters

#figure(
  raw_from_m("arx_identification.m", "lst_arx_impl"),
  caption: [Least Squares for ARX Model Identification]
) <arx_id_code>

The parameters identified by @arx_id_code are as follows: 
$ accent(theta, hat) = mat(a_1; a_2; b_1; b_2) = mat(-1.7757;0.8134;0.0016;0.0090) $ 

=== Predicted Output and Loss

@arx_comp_fig shows the true output and the predicted output, as well as the error: 

#figure(
  image("plots/arx_y_ypred.png", width: 80%),
  caption: [ARX Output Comparison]
)<arx_comp_fig>

The sum-of-squares loss is:

$ J(accent(theta, hat)) = 788.5745  $

=== Output of the Identified System

