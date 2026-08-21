import Sound
import lean_certs.cert_43_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_142_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 43) (d := 142) (c := cert_43_142) (by decide)
