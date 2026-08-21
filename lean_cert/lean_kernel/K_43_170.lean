import Sound
import lean_certs.cert_43_170

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_170_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 43) (d := 170) (c := cert_43_170) (by decide)
