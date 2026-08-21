import Sound
import lean_certs.cert_43_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_154_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 43) (d := 154) (c := cert_43_154) (by decide)
