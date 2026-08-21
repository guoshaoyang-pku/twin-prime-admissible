import Sound
import lean_certs.cert_21_66

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_66_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 21) (d := 66) (c := cert_21_66) (by decide)
