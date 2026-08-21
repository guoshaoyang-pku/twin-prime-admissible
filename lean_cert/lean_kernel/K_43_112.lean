import Sound
import lean_certs.cert_43_112

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_112_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 43) (d := 112) (c := cert_43_112) (by decide)
