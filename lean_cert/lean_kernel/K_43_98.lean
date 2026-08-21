import Sound
import lean_certs.cert_43_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_98_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 43) (d := 98) (c := cert_43_98) (by decide)
