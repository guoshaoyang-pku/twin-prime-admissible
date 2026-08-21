import Sound
import lean_certs.cert_43_176

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_176_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 43) (d := 176) (c := cert_43_176) (by decide)
