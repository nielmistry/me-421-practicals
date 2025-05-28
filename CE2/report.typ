#import "@preview/problemst:0.1.2": pset


#let raw_from_m(file_name, tag_name) = {
  let fir_m_file = read("fir_identification.m")
  let lines = fir_m_file.split("\n")
  let idxs = lines.enumerate().filter(idx_data => idx_data.at(1).contains(tag_name))

  assert(idxs.len() == 2)
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
  caption: [$y$ vs $accent(y, hat)$]
)

The loss is:
$ J(accent(theta, hat)) = 2.87 times 10^4 $.
=== Covariance Code & Plots

#raw_from_m("fir_identification.m", "lst_fir_cov")


