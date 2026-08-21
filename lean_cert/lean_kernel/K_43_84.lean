import Sound
import lean_certs.cert_43_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_84_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 43) (d := 84) (c := cert_43_84) (by decide)
