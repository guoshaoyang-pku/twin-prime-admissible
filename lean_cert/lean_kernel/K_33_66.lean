import Sound
import lean_certs.cert_33_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H33_gt_66_kernel : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 33) (d := 66) (c := cert_33_66) (by decide)
