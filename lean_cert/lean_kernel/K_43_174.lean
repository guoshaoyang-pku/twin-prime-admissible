import Sound
import lean_certs.cert_43_174

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_174_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 43) (d := 174) (c := cert_43_174) (by decide)
