import Sound
import lean_certs.cert_18_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_66_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 18) (d := 66) (c := cert_18_66) (by decide)
